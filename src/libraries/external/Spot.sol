// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {Quad, LibOptQuad, POSITIVE_ZERO, POSITIVE_ONE} from "src/types/ABDKMathQuad/Quad.sol";
import {max, min} from "src/types/ABDKMathQuad/Math.sol";
import {Z, I} from "src/Constants.sol";
import {GapStagedFrame} from "src/libraries/internal/GapStagedFrame.sol";
import {GrowthSplitFrame} from "src/libraries/internal/GrowthSplitFrame.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {JumpyFallback} from "src/libraries/internal/JumpyFallback.sol";
import {BucketRolling} from "src/libraries/internal/BucketRolling.sol";
import {EachPayoff} from "src/libraries/internal/EachPayoff.sol";
import {liquid, mid, sqrtStrike, exFee, gamma, spotFee, BINS} from "src/libraries/helpers/PoolHelper.sol";

library Spot {
    using GapStagedFrame for GapStagedFrame.Info;
    using GrowthSplitFrame for GrowthSplitFrame.Info;
    using JumpyFallback for JumpyFallback.Info;
    using LibOptQuad for LibOptQuad.Raw;
    using BucketRolling for BucketRolling.Info;
    using EachPayoff for PoolState;

    error InvalidTickBin(int256 tickBin);
    error InvalidPushAmount();

    function updateFees(PoolState storage self, bool isUp) internal {
        self.fees[0].move(self, isUp);
        self.fees[1].move(self, isUp);
    }

    function pool(PoolState storage self, bool isUp) internal {
        if (isUp) {
            self.tickBin = (self.tickBin + 1);
            self.binFrac = POSITIVE_ZERO;
        } else {
            self.tickBin = (self.tickBin - 1);
            self.binFrac = POSITIVE_ONE;
        }
    }

    function _uptick(PoolState storage self) internal {
        if (self.tickBin >= ((BINS(self.splits) - 1))) revert InvalidTickBin(self.tickBin);

        self.joinStaged.flush(self, self.tickBin + 1);
        updateFees(self, true);
        pool(self, true);
    }

    function _downtick(PoolState storage self) internal {
        if (self.tickBin <= (0)) revert InvalidTickBin(self.tickBin);
        self.joinStaged.flush(self, self.tickBin - 1);
        updateFees(self, false);
        pool(self, false);
    }

    function onSlip(PoolState storage pool, Quad qMove) public {
        if (qMove >= POSITIVE_ZERO) pool.dayMove.add(pool, qMove);
    }

    struct SwapLocalVars {
        Quad netInput;
        Quad output;
        Quad qMove;
        UserPay.Info transfer;
        bool consumed;
        Quad gamma;
        Quad liquid;
        Quad qNew;
        Quad qStep;
        Quad sweepInput;
        Quad inputFrac;
        Quad usedInput;
        Quad accrual;
        Quad change;
    }

    struct SwapParams {
        Quad push;
        bool token;
        LibOptQuad.Raw limitPrice;
    }

    function swap(PoolState storage pool, SwapParams memory params) external returns (UserPay.Info memory) {
        if (params.push < POSITIVE_ZERO) revert InvalidPushAmount();
        SwapLocalVars memory vars;

        vars.netInput = params.push * exFee(pool.fee);
        vars.transfer = UserPay.Info(POSITIVE_ZERO, POSITIVE_ZERO);
        vars.consumed = true;

        if (params.token == Z) {
            while (vars.netInput > POSITIVE_ZERO) {
                if (pool.binFrac == POSITIVE_ZERO) {
                    if (pool.tickBin == 0) {
                        vars.consumed = false;
                        break;
                    }
                    pool.downtick();
                }

                if (params.limitPrice.isDefined() && mid(pool.splits, pool.tickBin) * exFee(pool.fee) < params.limitPrice.get()) {
                    vars.consumed = false;
                    break;
                }

                vars.gamma = gamma(pool.lent, pool.offRamp, pool.era, pool.splits, pool.tickBin);
                vars.liquid = liquid(pool.minted, pool.tickBin, pool.splits, vars.gamma, pool.deflator);

                if (vars.liquid > POSITIVE_ZERO) {
                    vars.sweepInput = (pool.epsilon * vars.liquid) / sqrtStrike(pool.splits, pool.tickBin);
                    vars.inputFrac = vars.netInput / vars.sweepInput;
                    vars.qNew = max(pool.binFrac - vars.inputFrac, POSITIVE_ZERO);
                    vars.qStep = pool.binFrac - vars.qNew;
                    vars.usedInput = vars.qStep * vars.sweepInput;

                    vars.netInput = vars.netInput - vars.usedInput;
                    vars.output = vars.output + (vars.usedInput * mid(pool.splits, pool.tickBin));

                    vars.accrual = (
                        (
                            ((POSITIVE_ONE - pool.used.nowAt(pool.era, pool.splits, pool.tickBin) * pool.deflator) * pool.epsilon)
                                / sqrtStrike(pool.splits, pool.tickBin)
                        ) * pool.fee / exFee(pool.fee)
                    ) * vars.qStep;
                    vars.change = pool.fee * vars.usedInput / exFee(pool.fee);
                    spotFee(pool.fees, pool.splits, params.token, vars.accrual, vars.change);
                } else {
                    vars.qNew = POSITIVE_ZERO;
                    vars.qStep = pool.binFrac;
                }

                vars.qMove = vars.qMove + vars.qStep;
                pool.binFrac = vars.qNew;

                if (vars.qNew > POSITIVE_ZERO) {
                    vars.consumed = true;
                    break;
                }
            }
            vars.transfer = UserPay.Info(vars.consumed ? params.push : params.push - (vars.netInput / exFee(pool.fee)), vars.output.neg());
        } else {
            if (params.token == I) {
                while (vars.netInput > POSITIVE_ZERO) {
                    if (pool.binFrac == POSITIVE_ONE) {
                        if (pool.tickBin == (BINS(pool.splits) - 1)) {
                            vars.consumed = false;
                            break;
                        }
                        pool.uptick();
                    }

                    if (params.limitPrice.isDefined() && mid(pool.splits, pool.tickBin) / exFee(pool.fee) > params.limitPrice.get()) {
                        vars.consumed = false;
                        break;
                    }

                    vars.gamma = gamma(pool.lent, pool.offRamp, pool.era, pool.splits, pool.tickBin);
                    vars.liquid = liquid(pool.minted, pool.tickBin, pool.splits, vars.gamma, pool.deflator);

                    if (vars.liquid > POSITIVE_ZERO) {
                        vars.sweepInput = (pool.epsilon * vars.liquid) * sqrtStrike(pool.splits, pool.tickBin);
                        vars.inputFrac = vars.netInput / vars.sweepInput;
                        vars.qNew = min(pool.binFrac + vars.inputFrac, POSITIVE_ONE);
                        vars.qStep = vars.qNew - pool.binFrac;
                        vars.usedInput = vars.qStep * vars.sweepInput;

                        vars.netInput = vars.netInput - vars.usedInput;
                        vars.output = vars.output + (vars.usedInput / mid(pool.splits, pool.tickBin));

                        vars.accrual = (
                            (
                                ((POSITIVE_ONE - pool.used.nowAt(pool.era, pool.splits, pool.tickBin) * pool.deflator) * pool.epsilon)
                                    * sqrtStrike(pool.splits, pool.tickBin)
                            ) * pool.fee / exFee(pool.fee)
                        ) * vars.qStep;
                        vars.change = pool.fee * vars.usedInput / exFee(pool.fee);
                        spotFee(pool.fees, pool.splits, params.token, vars.accrual, vars.change);
                    } else {
                        vars.qNew = POSITIVE_ONE;
                        vars.qStep = POSITIVE_ONE - pool.binFrac;
                    }

                    vars.qMove = vars.qMove + vars.qStep;
                    pool.binFrac = vars.qNew;

                    if (vars.qNew < POSITIVE_ONE) {
                        vars.consumed = true;
                        break;
                    }
                }

                vars.transfer = UserPay.Info(vars.output.neg(), vars.consumed ? params.push : params.push - (vars.netInput / exFee(pool.fee)));
            }
        }

        onSlip(pool, vars.qMove);
        return vars.transfer;
    }
}
