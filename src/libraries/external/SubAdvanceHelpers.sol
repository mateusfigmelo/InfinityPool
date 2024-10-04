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

library SubAdvanceHelpers {
    using JumpyAnchorFaber for JumpyAnchorFaber.Info;
    using EraBoxcarMidSum for EraBoxcarMidSum.Info;
    using JumpyFallback for JumpyFallback.Info;
    using GrowthSplitFrame for GrowthSplitFrame.Info;

    using EachPayoff for PoolState;

    error TargetDateInPast();
    error InvalidAlphaOrGamma();
    error InavlidNewFrac(Quad newFrac);

    event AccountingHole(Quad hole0, Quad hole1);

    struct SubAdvanceComputeFeeQStopCase0Params {
        Quad alpha;
        Quad gamma;
        Quad omega;
        Quad flowResidue;
        Quad flow0start;
        Quad flow1start;
        Quad flow0base;
        Quad flow1base;
        Quad stepRise;
        Quad newFrac;
        Quad a;
    }

    struct SubAdvanceCompueFeeQStopCase0LocalVars {
        Quad resFee;
        Quad fee;
        Quad qSwitch;
        Quad switchRise;
        Quad integral;
        Quad temp;
        Quad t1;
    }

    function subAdvance_computeFee_qStopCase0(PoolState storage pool, SubAdvanceComputeFeeQStopCase0Params memory params)
        external
        view
        returns (Quad)
    {
        SubAdvanceCompueFeeQStopCase0LocalVars memory vars;

        vars.resFee = POSITIVE_ZERO;

        if ((params.omega == POSITIVE_ZERO)) {
            vars.resFee = (min(params.flowResidue, ((NEGATIVE_TWO * pool.fee) * params.flow1base)) * params.stepRise);
        } else {
            vars.fee = POSITIVE_ZERO;
            vars.qSwitch = POSITIVE_ZERO;
            vars.switchRise = POSITIVE_ZERO;

            if ((params.flowResidue < ((NEGATIVE_TWO * pool.fee) * params.flow1start))) {
                vars.qSwitch = max(((((params.flowResidue / POSITIVE_TWO) / pool.fee) + params.flow1base) / params.omega), params.newFrac);
                vars.t1 = log1p(((params.omega * (pool.binFrac - vars.qSwitch)) / params.flow1start));
                if ((params.gamma == POSITIVE_ZERO)) {
                    vars.switchRise = ((params.alpha * vars.t1.neg()) / params.omega);
                } else {
                    vars.temp = expm1(((params.gamma.neg() / params.omega) * vars.t1));
                    vars.switchRise = (((params.alpha / params.gamma) - POSITIVE_ONE) * vars.temp);
                }
                vars.switchRise = min(POSITIVE_ONE, vars.switchRise);
                vars.fee = (params.flowResidue * vars.switchRise);
            } else {
                vars.fee = POSITIVE_ZERO;
                vars.qSwitch = pool.binFrac;
                vars.switchRise = POSITIVE_ZERO;
            }
            if ((vars.qSwitch > params.newFrac)) {
                vars.integral = (
                    (params.omega == params.gamma)
                        ? (
                            (
                                ((params.alpha - params.gamma) * params.flow1start)
                                    * log1p(
                                        (
                                            (params.gamma * (params.stepRise - vars.switchRise))
                                                / (params.alpha - (params.gamma * (POSITIVE_ONE - vars.switchRise)))
                                        )
                                    )
                            ) / params.gamma
                        )
                        : (
                            (
                                (
                                    params.gamma
                                        * (
                                            (params.stepRise * (params.a - (params.omega * params.newFrac)))
                                                - (vars.switchRise * (params.a - (params.omega * vars.qSwitch)))
                                        )
                                ) - ((params.omega * (params.alpha - params.gamma)) * (params.newFrac - vars.qSwitch))
                            ) / (params.gamma - params.omega)
                        )
                );
                vars.fee = (vars.fee + ((NEGATIVE_TWO * pool.fee) * vars.integral));
            }
            vars.resFee = vars.fee;
        }
        return vars.resFee;
    }

    struct SubAdvanceComputeFeeQStopCase1Params {
        Quad alpha;
        Quad gamma;
        Quad omega;
        Quad flowResidue;
        Quad flow0start;
        Quad flow0base;
        Quad flow1base;
        Quad stepRise;
        Quad newFrac;
        Quad a;
    }

    struct SubAdvanceCompueFeeQStopCase1LocalVars {
        Quad resFee;
        Quad fee;
        Quad qSwitch;
        Quad switchRise;
        Quad integral;
        Quad temp;
        Quad t1;
    }

    function subAdvance_computeFee_qStopCase1(PoolState storage pool, SubAdvanceComputeFeeQStopCase1Params memory params)
        external
        view
        returns (Quad)
    {
        SubAdvanceCompueFeeQStopCase1LocalVars memory vars;

        vars.resFee = POSITIVE_ZERO;

        if ((params.omega == POSITIVE_ZERO)) {
            vars.resFee = (min(params.flowResidue, ((NEGATIVE_TWO * pool.fee) * params.flow0base)) * params.stepRise);
        } else {
            vars.fee = POSITIVE_ZERO;
            vars.qSwitch = POSITIVE_ZERO;
            vars.switchRise = POSITIVE_ZERO;

            if ((params.flowResidue < ((NEGATIVE_TWO * pool.fee) * params.flow0start))) {
                vars.qSwitch = min(((((params.flowResidue / POSITIVE_TWO) / pool.fee) + params.flow0base) / params.omega.neg()), params.newFrac);
                if ((params.gamma == POSITIVE_ZERO)) {
                    vars.temp = log1p(((params.omega * (pool.binFrac - vars.qSwitch)) / params.flow0start.neg()));
                    vars.switchRise = ((params.alpha * vars.temp.neg()) / params.omega);
                } else {
                    vars.t1 = log1p(((params.omega * (pool.binFrac - vars.qSwitch)) / params.flow0start.neg()));
                    vars.temp = expm1(((params.gamma.neg() / params.omega) * vars.t1));
                    vars.switchRise = (((params.alpha / params.gamma) - POSITIVE_ONE) * vars.temp);
                }
                vars.switchRise = min(POSITIVE_ONE, vars.switchRise);
                vars.fee = (params.flowResidue * vars.switchRise);
            } else {
                vars.fee = POSITIVE_ZERO;
                vars.qSwitch = pool.binFrac;
                vars.switchRise = POSITIVE_ZERO;
            }
            if ((vars.qSwitch < params.newFrac)) {
                vars.integral = (
                    (params.omega == params.gamma)
                        ? (
                            (
                                ((params.alpha - params.gamma) * params.flow0start.neg())
                                    * log1p(
                                        (
                                            (params.gamma * (params.stepRise - vars.switchRise))
                                                / (params.alpha - (params.gamma * (POSITIVE_ONE - vars.switchRise)))
                                        )
                                    )
                            ) / params.gamma
                        )
                        : (
                            (
                                (
                                    params.gamma
                                        * (
                                            (params.stepRise * (params.a - (params.omega * params.newFrac)))
                                                - (vars.switchRise * (params.a - (params.omega * vars.qSwitch)))
                                        )
                                ) - ((params.omega * (params.alpha - params.gamma)) * (params.newFrac - vars.qSwitch))
                            ) / (params.gamma - params.omega)
                        )
                );
                vars.fee = (vars.fee + ((POSITIVE_TWO * pool.fee) * vars.integral));
            }

            vars.resFee = vars.fee;
        }
        return vars.resFee;
    }

    function updateSurplusAndFees(PoolState storage pool, Quad fullRise, Quad flow0start, Quad flow1start, Quad sqrtMid) public {
        pool.surplus0 = (pool.surplus0 + (((pool.epsilon / sqrtMid) * flow0start) * fullRise));
        pool.surplus1 = (pool.surplus1 + (((pool.epsilon * sqrtMid) * flow1start) * fullRise));

        pool.binFracAccrue(pool.binFrac * fullRise, fullRise);

        pool.fees[1].live(pool.splits).accrued = (
            pool.fees[1].live(pool.splits).accrued
                + (((pool.fees[1].dirtyRate(pool) + pool.binFrac * pool.fees[1].binRate(pool)) * fullRise) * pool.deflator)
        );

        pool.fees[0].live(pool.splits).accrued = (
            pool.fees[0].live(pool.splits).accrued
                + (((pool.fees[0].dirtyRate(pool) - pool.binFrac * pool.fees[0].binRate(pool)) * fullRise) * pool.deflator)
        );
    }
}
