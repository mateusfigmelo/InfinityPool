// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, POSITIVE_ZERO} from "src/types/ABDKMathQuad/Quad.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {TUBS, JUMPS, WORD_SIZE, TICK_SUB_SLITS, Z, I} from "src/Constants.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {EachPayoff} from "src/libraries/internal/EachPayoff.sol";
import {logBin, tickSqrtPrice, binLowTick} from "src/libraries/helpers/PoolHelper.sol";

import {FloatBits, SparseFloat, QuadPacker} from "src/libraries/internal/SparseFloat.sol";

library Capper {
    using SparseFloat for SparseFloat.Info;
    using Capper for Info;
    using FloatBits for FloatBits.Info;

    struct Info {
        Quad entryDeflator;
        int32 lastDrain;
        bool isInitialized;
        FloatBits.Info entryLevel;
        SparseFloat.Info integral;
    }

    function init(Info storage self, PoolState storage pool, int256 pivotTick, bool token) internal {
        self.isInitialized = true;
        if (pivotTick <= binLowTick(pool.splits, pool.tickBin) == token) {
            self.entryDeflator = pool.deflator;
        } else {
            self.entryLevel = EachPayoff.runLevel(pool, pivotTick, token, true);
            self.entryDeflator = POSITIVE_ZERO;
        }
        self.lastDrain = pool.era;
    }

    function unpeg(Info storage self, PoolState storage pool, int256 pivotTick, bool token) internal {
        self.integral.add(due(self, pool, pivotTick, token));
        self.entryLevel = EachPayoff.runLevel(pool, pivotTick, token, true);
        self.entryDeflator = POSITIVE_ZERO;
    }

    function pegUp(Info storage self, PoolState storage pool, int256 pivotTick, bool token) internal {
        self.integral.add(due(self, pool, pivotTick, token));
        self.entryDeflator = pool.deflator;

        self.entryLevel.exponent = 0;
        self.entryLevel.significand = 0;
    }

    function due(Info storage self, PoolState storage pool, int256 pivotTick, bool token) internal returns (Quad) {
        if (self.entryDeflator == POSITIVE_ZERO) {
            EachPayoff.growRuns(pool);
            Quad t2 = pool.reserveRun[(token == Z ? 0 : 1)].growth(self.entryLevel);
            return (t2 * tickSqrtPrice(((token == Z) ? pivotTick : -pivotTick)));
        } else {
            return (self.entryDeflator - pool.deflator);
        }
    }

    function grow(Info storage self, PoolState storage pool, int256 pivotTick, bool token) internal {
        if (self.entryDeflator == POSITIVE_ZERO) unpeg(self, pool, pivotTick, token);
        else pegUp(self, pool, pivotTick, token);
    }

    function read(Info storage self, PoolState storage pool, int256 pivotTick, bool token, int128 exponent)
        internal
        returns (FloatBits.Info memory)
    {
        return self.integral.read(exponent).add(due(self, pool, pivotTick, token));
    }
}
