// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, fromInt256, intoUint256, intoInt256, POSITIVE_ZERO, POSITIVE_ONE, POSITIVE_TWO, NEGATIVE_TWO} from "src/types/ABDKMathQuad/Quad.sol";
import {min, max, log, abs, exp2} from "src/types/ABDKMathQuad/Math.sol";
import {log1p, expm1} from "src/types/ABDKMathQuad/MathExtended.sol";
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

import {Spot} from "src/libraries/external/Spot.sol";
import {JUMPS, Z, I, LAMBDA} from "src/Constants.sol";

import {SubAdvanceHelpers} from "./SubAdvanceHelpers.sol";

library SubAdvance {
    using JumpyAnchorFaber for JumpyAnchorFaber.Info;
    using EraBoxcarMidSum for EraBoxcarMidSum.Info;
    using JumpyFallback for JumpyFallback.Info;
    using GrowthSplitFrame for GrowthSplitFrame.Info;
    using PiecewiseGrowthNew for PiecewiseGrowthNew.Info;

    using EachPayoff for PoolState;
    using Spot for PoolState;

    error InvalidAlphaOrGamma();
    error InavlidNewFrac(Quad newFrac);

    struct SubAdvanceLocalVars {
        Quad sqrtMid;
        Quad flow0base;
        Quad flow1base;
        Quad omega;
        Quad flow0start;
        Quad flow1start;
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
        bool terminus;
        Quad accrualForSpotFee;
    }

    function subAdvance(PoolState storage pool, Quad toDate) external {
        SubAdvanceLocalVars memory vars;

        while (true) {
            vars.sqrtMid = sqrtStrike(pool.splits, pool.tickBin);

            for (int256 i = 0; i < 2; i = i + 1) {
                JumpyAnchorFaber.Info storage temp = pool.flowHat[uint256(i)];
                temp.move(pool, pool.tickBin);
            }

            vars.flow0base = (
                (
                    (vars.sqrtMid * (pool.flowHat[0].halfsum + pool.flowDot[0][0].bidSum(pool)))
                        + ((h(pool.splits) * pool.flowDot[0][1].bidSum(pool)) / vars.sqrtMid)
                ) * pool.deflator
            );

            vars.flow1base = (
                (
                    ((vars.sqrtMid * h(pool.splits)) * pool.flowDot[1][0].askSum(pool))
                        + ((pool.flowHat[1].halfsum + pool.flowDot[1][1].askSum(pool)) / vars.sqrtMid)
                ) * pool.deflator
            );

            vars.omega = max((pool.owed.nowAt(pool.era, pool.splits, pool.tickBin) * pool.deflator), POSITIVE_ZERO);
            vars.flow0start = (vars.flow0base + (vars.omega * pool.binFrac));
            vars.flow1start = (vars.flow1base - (vars.omega * pool.binFrac));

            vars.temp = expm1((LAMBDA * (pool.date - toDate)));

            vars.fullRise = vars.temp.neg();
            vars.flowResidue = (vars.flow0base + vars.flow1base);
            vars.a = POSITIVE_ZERO;
            vars.qStop = 0;

            if (((vars.flow0start > POSITIVE_ZERO) && (vars.flow1start < POSITIVE_ZERO))) {
                vars.a = vars.flow1base;
                vars.qStop = 0;
            } else {
                if (((vars.flow0start < POSITIVE_ZERO) && (vars.flow1start > POSITIVE_ZERO))) {
                    vars.a = vars.flow0base.neg();
                    vars.qStop = 1;
                } else {
                    SubAdvanceHelpers.updateSurplusAndFees(pool, vars.fullRise, vars.flow0start, vars.flow1start, vars.sqrtMid);

                    pool.date = toDate;
                    pool.deflator = exp2(-pool.date);
                    pool.onSlip(POSITIVE_ZERO);
                    return;
                }
            }

            vars.alpha = max(fluidAt(pool.minted, pool.tickBin, pool.splits), POSITIVE_ZERO);
            vars.gamma = (gamma(pool.lent, pool.offRamp, pool.era, pool.splits, pool.tickBin) * pool.deflator);

            if (((vars.alpha == POSITIVE_ZERO) && (vars.gamma == POSITIVE_ZERO))) {
                pool.onSlip(abs((fromInt256(vars.qStop) - pool.binFrac)));
            } else {
                if ((vars.gamma >= vars.alpha)) revert InvalidAlphaOrGamma();

                vars.timeSide = (
                    (vars.gamma == POSITIVE_ZERO)
                        ? (vars.fullRise / vars.alpha)
                        : (log1p(((vars.gamma * vars.fullRise) / (vars.alpha - vars.gamma))) / vars.gamma)
                );

                vars.qBarrier = POSITIVE_ZERO;
                vars.target0 = POSITIVE_ZERO;
                vars.target1 = false;

                if ((vars.omega == POSITIVE_ZERO)) {
                    vars.flowSide = ((fromInt256(vars.qStop) - pool.binFrac) / vars.a);
                    vars.terminus = (vars.timeSide <= vars.flowSide);
                    vars.target0 = (vars.terminus ? vars.timeSide : vars.flowSide);
                    vars.target1 = vars.terminus;
                } else {
                    vars.qBarrier = (vars.a / vars.omega);
                    if ((((POSITIVE_ZERO) < vars.qBarrier) && (vars.qBarrier < POSITIVE_ONE))) {
                        vars.target0 = vars.timeSide;
                        vars.target1 = true;
                    } else {
                        vars.temp = log1p(((vars.omega * (pool.binFrac - fromInt256(vars.qStop))) / (vars.a - (vars.omega * pool.binFrac))));
                        vars.flowSide = (vars.temp.neg() / vars.omega);
                        vars.terminus = (vars.timeSide <= vars.flowSide);
                        vars.target0 = (vars.terminus ? vars.timeSide : vars.flowSide);
                        vars.target1 = vars.terminus;
                    }
                }

                vars.newFrac = POSITIVE_ZERO;
                vars.stepRise = POSITIVE_ZERO;
                vars.newDate = POSITIVE_ZERO;

                if (vars.target1) {
                    vars.timeSide = vars.target0;
                    vars.newFrac = (
                        (vars.omega == POSITIVE_ZERO)
                            ? (pool.binFrac + (vars.timeSide * vars.a))
                            : (pool.binFrac + ((pool.binFrac - vars.qBarrier) * expm1((vars.omega.neg() * vars.timeSide))))
                    );
                    if (!(POSITIVE_ZERO <= vars.newFrac && vars.newFrac <= POSITIVE_ONE)) revert InavlidNewFrac(vars.newFrac);
                    vars.stepRise = vars.fullRise;
                    vars.newDate = toDate;
                } else {
                    vars.flowSide = vars.target0;
                    vars.stepRise = (
                        (vars.gamma == POSITIVE_ZERO)
                            ? (vars.alpha * vars.flowSide)
                            : (((vars.alpha - vars.gamma) * expm1((vars.gamma * vars.flowSide))) / vars.gamma)
                    );
                    vars.newDate = min((pool.date - (log1p(vars.stepRise.neg()) / LAMBDA)), toDate);
                    vars.newFrac = fromInt256(vars.qStop);
                }

                PiecewiseGrowthNew.Info storage yield1 = pool.fees[1].live(pool.splits);
                PiecewiseGrowthNew.Info storage yield0 = pool.fees[0].live(pool.splits);

                if ((vars.omega != vars.gamma)) {
                    vars.accrual = (
                        (vars.omega <= abs((vars.omega - vars.gamma)))
                            ? (
                                (
                                    ((vars.a * vars.stepRise) + ((vars.alpha - vars.gamma) * pool.binFrac))
                                        - ((vars.alpha - (vars.gamma * (POSITIVE_ONE - vars.stepRise))) * vars.newFrac)
                                ) / (vars.omega - vars.gamma)
                            )
                            : (
                                ((vars.a / vars.omega) * vars.stepRise)
                                    + (
                                        (
                                            ((pool.binFrac - (vars.a / vars.omega)) * (vars.alpha - vars.gamma))
                                                * expm1(
                                                    (((vars.gamma - vars.omega) / vars.gamma) * log1p(((vars.gamma * vars.stepRise) / (vars.alpha - vars.gamma))))
                                                )
                                        ) / (vars.gamma - vars.omega)
                                    )
                            )
                    );

                    if (
                        !(
                            min(pool.binFrac, vars.newFrac) * vars.stepRise <= vars.accrual
                                && vars.accrual <= max(pool.binFrac, vars.newFrac) * vars.stepRise
                        )
                    ) vars.accrual = (pool.binFrac + vars.newFrac) / POSITIVE_TWO * vars.stepRise;

                    pool.binFracAccrue(vars.accrual, vars.stepRise);

                    if ((vars.omega != POSITIVE_ZERO)) {
                        yield1.accrued = (yield1.accrued + ((vars.accrual * pool.fees[1].binRate(pool)) * pool.deflator));

                        yield0.accrued = (yield0.accrued - ((vars.accrual * pool.fees[0].binRate(pool)) * pool.deflator));
                    }
                }

                yield1.accrued = yield1.accrued + pool.fees[1].dirtyRate(pool) * vars.stepRise * pool.deflator;
                yield0.accrued = yield0.accrued + pool.fees[0].dirtyRate(pool) * vars.stepRise * pool.deflator;

                vars.residue = (vars.flowResidue * vars.stepRise);

                if ((vars.qStop == 0)) {
                    vars.fee = SubAdvanceHelpers.subAdvance_computeFee_qStopCase0(
                        pool,
                        SubAdvanceHelpers.SubAdvanceComputeFeeQStopCase0Params({
                            alpha: vars.alpha,
                            gamma: vars.gamma,
                            omega: vars.omega,
                            flowResidue: vars.flowResidue,
                            flow0start: vars.flow0start,
                            flow1start: vars.flow1start,
                            flow0base: vars.flow0base,
                            flow1base: vars.flow1base,
                            stepRise: vars.stepRise,
                            newFrac: vars.newFrac,
                            a: vars.a
                        })
                    );

                    vars.charged = ((pool.epsilon / vars.sqrtMid) * vars.fee);

                    vars.accrualForSpotFee = (
                        (vars.charged * (POSITIVE_ONE - (pool.used.nowAt(pool.era, pool.splits, pool.tickBin) * pool.deflator)))
                            / (vars.alpha - vars.gamma)
                    );

                    spotFee(pool.fees, pool.splits, Z, vars.accrualForSpotFee, vars.charged);

                    pool.surplus0 = (pool.surplus0 + ((pool.epsilon / vars.sqrtMid) * (vars.residue - vars.fee)));
                } else {
                    if ((vars.qStop == 1)) {
                        vars.fee = SubAdvanceHelpers.subAdvance_computeFee_qStopCase1(
                            pool,
                            SubAdvanceHelpers.SubAdvanceComputeFeeQStopCase1Params({
                                alpha: vars.alpha,
                                gamma: vars.gamma,
                                omega: vars.omega,
                                flowResidue: vars.flowResidue,
                                flow0start: vars.flow0start,
                                flow0base: vars.flow0base,
                                flow1base: vars.flow1base,
                                stepRise: vars.stepRise,
                                newFrac: vars.newFrac,
                                a: vars.a
                            })
                        );

                        vars.charged = ((pool.epsilon * vars.sqrtMid) * vars.fee);

                        vars.accrualForSpotFee = (
                            (vars.charged * (POSITIVE_ONE - (pool.used.nowAt(pool.era, pool.splits, pool.tickBin) * pool.deflator)))
                                / (vars.alpha - vars.gamma)
                        );

                        spotFee(pool.fees, pool.splits, I, vars.accrualForSpotFee, vars.charged);

                        pool.surplus1 = (pool.surplus1 + ((pool.epsilon * vars.sqrtMid) * (vars.residue - vars.fee)));
                    }
                }

                pool.date = vars.newDate;
                pool.deflator = exp2(-pool.date);
                pool.onSlip(abs((vars.newFrac - pool.binFrac)));

                if ((pool.date == toDate)) {
                    pool.binFrac = vars.newFrac;
                    return;
                }
            }

            if ((vars.qStop == 0)) pool.downtick();
            else if ((vars.qStop == 1)) pool.uptick();
        }
    }
}
