// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, fromInt256, intoUint256, intoInt256, POSITIVE_ZERO, POSITIVE_ONE, POSITIVE_TWO, NEGATIVE_TWO} from "src/types/ABDKMathQuad/Quad.sol";
import {min, max, log, abs, exp2} from "src/types/ABDKMathQuad/Math.sol";
import {expm1} from "src/types/ABDKMathQuad/MathExtended.sol";
import {wrap} from "src/types/Optional/OptInt256.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {SignedMath} from "@openzeppelin/contracts/utils/math/SignedMath.sol";
import {JumpyAnchorFaber} from "src/libraries/internal/JumpyAnchorFaber.sol";
import {JumpyFallback} from "src/libraries/internal/JumpyFallback.sol";
import {DailyJumps} from "src/libraries/internal/DailyJumps.sol";
import {DeadlineJumps, PiecewiseGrowthNew, PiecewiseCurve, DeadlineSet} from "src/libraries/internal/DeadlineJumps.sol";
import {GrowthSplitFrame} from "src/libraries/internal/GrowthSplitFrame.sol";
import {DeadlineFlag} from "src/libraries/internal/DeadlineFlag.sol";

import {DropFaberTotals} from "src/libraries/internal/DropFaberTotals.sol";
import {EraFaberTotals} from "src/libraries/internal/EraFaberTotals.sol";
import {EraBoxcarMidSum} from "src/libraries/internal/EraBoxcarMidSum.sol";
import {EachPayoff} from "src/libraries/internal/EachPayoff.sol";
import {spotFee, eraDate, dateEra, sqrtStrike, fluidAt, h, gamma, liquid} from "src/libraries/helpers/PoolHelper.sol";
import {deadEra} from "src/libraries/helpers/DeadlineHelper.sol";

import {Spot} from "src/libraries/external/Spot.sol";
import {JUMPS, Z, I, LAMBDA} from "src/Constants.sol";

import {SubAdvance} from "./SubAdvance.sol";
import {Structs} from "./Structs.sol";
import {NewLoan} from "./NewLoan.sol";

library Advance {
    using JumpyAnchorFaber for JumpyAnchorFaber.Info;
    using EraBoxcarMidSum for EraBoxcarMidSum.Info;
    using JumpyFallback for JumpyFallback.Info;
    using GrowthSplitFrame for GrowthSplitFrame.Info;
    using PiecewiseGrowthNew for PiecewiseGrowthNew.Info;
    using DeadlineSet for DeadlineSet.Info;
    using DeadlineFlag for DeadlineFlag.Info;
    using DropFaberTotals for DropFaberTotals.Info;
    using EraFaberTotals for EraFaberTotals.Info;

    using EachPayoff for PoolState;
    using Spot for PoolState;

    error TargetDateInPast();
    error InvalidAlphaOrGamma();
    error InavlidNewFrac(Quad newFrac);

    event AccountingHole(Quad hole0, Quad hole1);
    event PoolPriceUpdated(Structs.PoolPriceInfo priceInfo);

    struct Advancevars {
        int256 startEra;
        int256 jumpIndex;
        int256 deadline;
        Quad nextDate;
        bool terminus;
        Quad freed0;
        Quad freed1;
        Quad needed;
        Quad surplus0;
        Quad surplus1;
        Quad liquidity;
        Quad qMove;
        bool upward;
        Quad hole0;
        Quad hole1;
        Quad temp;
        Quad fullRise;
        Quad flowResidue;
        Quad a;
        int256 qStop;
        Quad alpha;
        Quad gamma;
        Quad timeSide;
        Quad qBarrier;
        Quad target0;
        bool target1;
        Quad newFrac;
        Quad stepRise;
        Quad newDate;
        Quad accrual;
        Quad residue;
        Quad fee;
        Quad charged;
        Quad flowSide;
        Quad sqrtMid;
        Quad flow0base;
        Quad flow1base;
        Quad omega;
        Quad flow0start;
        Quad flow1start;
    }

    function advance(PoolState storage pool, Quad toDate, bool emitPriceUpdated) external {
        if ((toDate < pool.date)) revert TargetDateInPast();

        Advancevars memory vars;

        vars.startEra = pool.era;

        for (; (vars.jumpIndex < JUMPS); vars.jumpIndex = (vars.jumpIndex + 1)) {
            vars.deadline = deadEra(vars.startEra, int8(vars.jumpIndex));

            vars.nextDate = eraDate(vars.deadline);

            if ((vars.nextDate > toDate)) break;

            if (pool.resets.dropAt(vars.deadline)) {
                SubAdvance.subAdvance(pool, vars.nextDate);
                DeadlineSet.Info storage expire0 = pool.expire[0];
                DeadlineSet.Info storage expire1 = pool.expire[1];

                vars.freed0 = expire0.dropAt(vars.deadline);

                vars.freed1 = expire1.dropAt(vars.deadline);

                if (vars.freed0 != POSITIVE_ZERO || vars.freed1 != POSITIVE_ZERO) {
                    DropFaberTotals.Info storage lentEnd0 = pool.lentEnd[0];

                    DropFaberTotals.Info storage lentEnd1 = pool.lentEnd[1];

                    vars.freed0 = (vars.freed0 - lentEnd0.eraFaberTotals.dropSum(pool, (pool.tickBin + 1), vars.deadline));
                    vars.freed1 = (vars.freed1 - lentEnd1.eraFaberTotals.dropSum(pool, pool.tickBin, vars.deadline));
                    vars.freed0 = (vars.freed0 * pool.deflator);
                    vars.freed1 = (vars.freed1 * pool.deflator);
                    vars.needed = (pool.lent.dropAt(pool.splits, pool.tickBin, vars.deadline) * pool.deflator);

                    vars.surplus0 =
                        (vars.freed0 - ((((POSITIVE_ONE - pool.binFrac) * pool.epsilon) * vars.needed) / sqrtStrike(pool.splits, pool.tickBin)));

                    vars.surplus1 = (vars.freed1 - (((pool.binFrac * pool.epsilon) * vars.needed) * sqrtStrike(pool.splits, pool.tickBin)));

                    if (((vars.surplus0 >= POSITIVE_ZERO) && (vars.surplus1 >= POSITIVE_ZERO))) {
                        pool.surplus0 = (pool.surplus0 + vars.surplus0);
                        pool.surplus1 = (pool.surplus1 + vars.surplus1);
                    } else {
                        if (((vars.surplus0 <= POSITIVE_ZERO) && (vars.surplus1 <= POSITIVE_ZERO))) {
                            vars.hole0 = (
                                (vars.surplus0 == POSITIVE_ZERO)
                                    ? POSITIVE_ZERO
                                    : (vars.surplus0.neg() / (expire0.dropAt(vars.deadline) * pool.deflator))
                            );

                            vars.hole1 = (
                                (vars.surplus1 == POSITIVE_ZERO)
                                    ? POSITIVE_ZERO
                                    : (vars.surplus1.neg() / (expire1.dropAt(vars.deadline) * pool.deflator))
                            );

                            if (((vars.hole0 > POSITIVE_ZERO) || (vars.hole1 > POSITIVE_ZERO))) emit AccountingHole(vars.hole0, vars.hole1);
                        } else {
                            vars.upward = (vars.surplus0 < vars.surplus1);

                            vars.gamma = gamma(pool.lent, pool.offRamp, pool.era, pool.splits, pool.tickBin);
                            vars.liquidity = liquid(pool.minted, pool.tickBin, pool.splits, vars.gamma, pool.deflator);

                            vars.qMove = POSITIVE_ZERO;

                            if (vars.upward) {
                                vars.freed1 = (vars.freed1 - ((pool.epsilon * vars.needed) * sqrtStrike(pool.splits, pool.tickBin)));
                                vars.qMove = (POSITIVE_ONE - pool.binFrac);
                                vars.freed0 = (vars.freed0 + (((vars.qMove * pool.epsilon) * vars.liquidity) / sqrtStrike(pool.splits, pool.tickBin)));
                                vars.freed1 = (vars.freed1 - (((vars.qMove * pool.epsilon) * vars.liquidity) * sqrtStrike(pool.splits, pool.tickBin)));
                            } else {
                                vars.freed0 = (vars.freed0 - ((pool.epsilon * vars.needed) / sqrtStrike(pool.splits, pool.tickBin)));
                                vars.qMove = pool.binFrac;
                                vars.freed1 = (vars.freed1 + (((vars.qMove * pool.epsilon) * vars.liquidity) * sqrtStrike(pool.splits, pool.tickBin)));
                                vars.freed0 = (vars.freed0 - (((vars.qMove * pool.epsilon) * vars.liquidity) / sqrtStrike(pool.splits, pool.tickBin)));
                            }
                            while ((((vars.upward) ? vars.freed0 : vars.freed1) < POSITIVE_ZERO)) {
                                if (vars.upward) pool.uptick();
                                else pool.downtick();

                                vars.qMove = vars.qMove + POSITIVE_ONE;
                                vars.needed = pool.lent.dropAt(pool.splits, pool.tickBin, vars.deadline) * pool.deflator;

                                vars.gamma = gamma(pool.lent, pool.offRamp, pool.era, pool.splits, pool.tickBin);
                                vars.liquidity = liquid(pool.minted, pool.tickBin, pool.splits, vars.gamma, pool.deflator);
                                if (vars.upward) {
                                    vars.freed0 =
                                        vars.freed0 + ((pool.epsilon * (vars.liquidity + vars.needed)) / sqrtStrike(pool.splits, pool.tickBin));
                                    vars.freed1 =
                                        vars.freed1 - ((pool.epsilon * (vars.liquidity + vars.needed)) * sqrtStrike(pool.splits, pool.tickBin));
                                } else {
                                    vars.freed1 =
                                        vars.freed1 + ((pool.epsilon * (vars.liquidity + vars.needed)) * sqrtStrike(pool.splits, pool.tickBin));
                                    vars.freed0 =
                                        vars.freed0 - ((pool.epsilon * (vars.liquidity + vars.needed)) / sqrtStrike(pool.splits, pool.tickBin));
                                }
                            }

                            vars.liquidity = vars.liquidity + vars.needed;
                            if (vars.upward) {
                                pool.binFrac = max(
                                    POSITIVE_ONE - (((vars.freed0 / pool.epsilon) / vars.liquidity) * sqrtStrike(pool.splits, pool.tickBin)),
                                    POSITIVE_ZERO
                                );
                                vars.qMove = vars.qMove - (POSITIVE_ONE - pool.binFrac);
                                vars.freed1 = vars.freed1
                                    + (((POSITIVE_ONE - pool.binFrac) * pool.epsilon) * vars.liquidity) * sqrtStrike(pool.splits, pool.tickBin);
                                pool.surplus1 = pool.surplus1 + vars.freed1;
                            } else {
                                pool.binFrac =
                                    min(((vars.freed1 / pool.epsilon) / vars.liquidity) / sqrtStrike(pool.splits, pool.tickBin), POSITIVE_ONE);
                                vars.qMove = vars.qMove - pool.binFrac;
                                vars.freed0 = vars.freed0 + ((pool.binFrac * pool.epsilon) * vars.liquidity) / sqrtStrike(pool.splits, pool.tickBin);
                                pool.surplus0 = pool.surplus0 + vars.freed0;
                            }
                            pool.onSlip(vars.qMove);
                        }
                    }
                }
                setEra(pool, vars.deadline);
            }
        }

        if ((toDate > pool.date)) {
            SubAdvance.subAdvance(pool, toDate);
            setEra(pool, dateEra(toDate));
        }
        if (emitPriceUpdated) emit PoolPriceUpdated(Structs.PoolPriceInfo(pool.splits, pool.tickBin, pool.binFrac, NewLoan.quadVar(pool), pool.date));
    }

    function setEra(PoolState storage pool, int256 toEra) internal {
        for (int256 i = 0; (i < int256(pool.flowHat.length)); i = (i + 1)) {
            JumpyAnchorFaber.Info storage temp = pool.flowHat[uint256(i)];
            temp.propel(pool, toEra);
        }
        pool.era = int32(toEra);
    }
}
