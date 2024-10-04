// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, fromInt256, POSITIVE_ZERO, POSITIVE_ONE, POSITIVE_TWO, HALF} from "src/types/ABDKMathQuad/Quad.sol";
import {ceil} from "src/types/ABDKMathQuad/Math.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {TUBS, JUMPS, WORD_SIZE, Z, I} from "src/Constants.sol";
import {DailyJumps} from "src/libraries/internal/DailyJumps.sol";
import {GrowthSplitFrame} from "src/libraries/internal/GrowthSplitFrame.sol";
import {DeadlineFlag} from "src/libraries/internal/DeadlineFlag.sol";
import {JumpyAnchorFaber, Anchor, AnchorSet} from "src/libraries/internal/JumpyAnchorFaber.sol";
import {SignedMath} from "@openzeppelin/contracts/utils/math/SignedMath.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {BoxcarTubFrame} from "src/libraries/internal/BoxcarTubFrame.sol";
import {GrowthSplitFrame} from "src/libraries/internal/GrowthSplitFrame.sol";
import {eraDate, subSplits, sqrtStrike, logBin, BINS, tubLowSqrt, tubLowTick} from "src/libraries/helpers/PoolHelper.sol";
import {deadEra} from "src/libraries/helpers/DeadlineHelper.sol";
import {OptInt256} from "src/types/Optional/OptInt256.sol";
import {GapStagedFrame} from "src/libraries/internal/GapStagedFrame.sol";
import {JumpyFallback} from "src/libraries/internal/JumpyFallback.sol";

import {EachPayoff} from "src/libraries/internal/EachPayoff.sol";
import {FloatBits, SparseFloat, QuadPacker} from "src/libraries/internal/SparseFloat.sol";
import {Capper} from "src/libraries/internal/Capper.sol";
import {LAMBDA} from "src/Constants.sol";
import {LP} from "./LP.sol";

library LPShed {
    using DeadlineFlag for DeadlineFlag.Info;
    using BoxcarTubFrame for BoxcarTubFrame.Info;
    using JumpyAnchorFaber for JumpyAnchorFaber.Info;
    using GrowthSplitFrame for GrowthSplitFrame.Info;
    using GapStagedFrame for GapStagedFrame.Info;
    using JumpyFallback for JumpyFallback.Info;
    using AnchorSet for AnchorSet.Info;
    using Capper for Capper.Info;
    using SafeCast for uint256;
    using SafeCast for int256;
    using FloatBits for Quad;

    struct ShedLocalVars {
        Quad drainDate;
        int128 oldLower0;
        int128 oldUpper0;
        int128 oldLower1;
        int128 oldUpper1;
        int128 exponent;
        int256 lowerTick;
        bytes32 tLZ1;
        FloatBits.Info tLZ3;
        int128 newLower0;
        bytes32 tLI1;
        FloatBits.Info tLI3;
        int128 newLower1;
        int256 upperTick;
        bytes32 TUZ1;
        FloatBits.Info TUZ3;
        int128 newUpper0;
        bytes32 TUI1;
        FloatBits.Info TUI3;
        int128 newUpper1;
        Quad lowerSqrtPrice;
        Quad upperSqrtPrice;
        Quad ratio0;
        Quad ratio1;
        Quad reflator;
        Quad res1;
        Quad res2;
    }

    function shed(LP.Info storage self, PoolState storage pool, bool flush) public returns (Quad, Quad) {
        if (self.stage == LP.Stage.Exit) {
            ShedLocalVars memory vars;

            vars.drainDate = self.drainDate;
            vars.oldLower0 = self.lower0;
            vars.oldUpper0 = self.upper0;
            vars.oldLower1 = self.lower1;
            vars.oldUpper1 = self.upper1;

            int128 exponent = int128(ceil((vars.drainDate.neg() + HALF))) - int128(WORD_SIZE);

            vars.lowerTick = tubLowTick(self.startTub);
            vars.tLZ1 = keccak256(abi.encode(vars.lowerTick, Z));

            Capper.Info storage tLZ2 = pool.capper[vars.tLZ1];
            vars.tLZ3 = tLZ2.read(pool, vars.lowerTick, Z, exponent);
            vars.newLower0 = vars.tLZ3.significand;

            if (self.startTub > 0) {
                vars.tLI1 = keccak256(abi.encode(vars.lowerTick, I));
                Capper.Info storage tLI2 = pool.capper[vars.tLI1];
                vars.tLI3 = tLI2.read(pool, vars.lowerTick, I, exponent);
                vars.newLower1 = vars.tLI3.significand;
            } else {
                vars.newLower1 = ~pool.deflator.truncate(exponent);
            }

            vars.upperTick = tubLowTick(self.stopTub);

            if (self.stopTub < TUBS) {
                vars.TUZ1 = keccak256(abi.encode(vars.upperTick, Z));
                Capper.Info storage TUZ2 = pool.capper[vars.TUZ1];
                vars.TUZ3 = TUZ2.read(pool, vars.upperTick, Z, exponent);
                vars.newUpper0 = vars.TUZ3.significand;
            } else {
                vars.newUpper0 = ~pool.deflator.truncate(exponent);
            }

            vars.TUI1 = keccak256(abi.encode(vars.upperTick, I));
            Capper.Info storage TUI2 = pool.capper[vars.TUI1];
            vars.TUI3 = TUI2.read(pool, vars.upperTick, I, exponent);
            vars.newUpper1 = vars.TUI3.significand;

            if (flush) {
                self.stage = LP.Stage.Exit;
                self.drainDate = vars.drainDate;
                self.lower0 = vars.newLower0;
                self.upper0 = vars.newUpper0;
                self.lower1 = vars.newLower1;
                self.upper1 = vars.newUpper1;
            }

            vars.lowerSqrtPrice = tubLowSqrt(self.startTub);
            vars.upperSqrtPrice = tubLowSqrt(self.stopTub);

            unchecked {
                vars.ratio0 = (
                    (QuadPacker.repack(FloatBits._apply(exponent, vars.newLower0 - vars.oldLower0)) / vars.lowerSqrtPrice)
                        - (QuadPacker.repack(FloatBits._apply(exponent, vars.newUpper0 - vars.oldUpper0)) / vars.upperSqrtPrice)
                );
                vars.ratio1 = (
                    (QuadPacker.repack(FloatBits._apply(exponent, vars.newUpper1 - vars.oldUpper1)) * vars.upperSqrtPrice)
                        - (QuadPacker.repack(FloatBits._apply(exponent, vars.newLower1 - vars.oldLower1)) * vars.lowerSqrtPrice)
                );
            }

            vars.reflator = (((LAMBDA * vars.drainDate)).exp() * self.liquidity);
            vars.res1 = (vars.ratio0 * vars.reflator);
            vars.res2 = (vars.ratio1 * vars.reflator);
            return (vars.res1.max(POSITIVE_ZERO), vars.res2.max(POSITIVE_ZERO));
        } else {
            return (POSITIVE_ZERO, POSITIVE_ZERO);
        }
    }
}
