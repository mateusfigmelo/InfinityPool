// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, POSITIVE_ZERO, POSITIVE_ONE, POSITIVE_TWO, fromInt256, HALF} from "src/types/ABDKMathQuad/Quad.sol";
import {ceil} from "src/types/ABDKMathQuad/Math.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {TUBS, JUMPS, JUMP_NONE, WORD_SIZE, Z, I, LAMBDA} from "src/Constants.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";

import {Spot} from "../external/Spot.sol";
import {subSplits, sqrtStrike, mid, h, logTick, binLowTick} from "src/libraries/helpers/PoolHelper.sol";
import {OptInt256} from "src/types/Optional/OptInt256.sol";

import {FloatBits, SparseFloat} from "src/libraries/internal/SparseFloat.sol";
import {Capper} from "src/libraries/internal/Capper.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";

library EachPayoff {
    using Capper for Capper.Info;
    using SparseFloat for SparseFloat.Info;
    using SafeCast for int256;
    using SafeCast for uint256;

    function capperBegin(PoolState storage pool, int256 pivotTick, bool side, int128 exponent) public returns (int128) {
        bytes32 key = keccak256(abi.encode(pivotTick, side));
        Capper.Info storage capper = pool.capper[key];
        if (capper.isInitialized) {
            capper.lastDrain = pool.era;
            capper.grow(pool, pivotTick, side);
            return capper.integral.read(exponent).significand;
        } else {
            pool.capper[key].init(pool, pivotTick, side);
            return 0;
        }
    }

    function growRuns(PoolState storage pool) internal {
        if (pool.deflator < pool.entryDeflator) {
            Quad integral = pool.entryDeflator - pool.deflator;
            SparseFloat.Info storage priceRun0 = pool.priceRun[0];
            SparseFloat.Info storage priceRun1 = pool.priceRun[1];
            Quad mid = mid(pool.splits, pool.tickBin);
            Quad h = h(pool.splits);
            priceRun0.add(integral * h / mid);
            priceRun1.add(h * mid * integral);

            // Add Merge
            pool.reserveRun[0].add(integral / (mid * h).sqrt());
            pool.reserveRun[1].add((mid / h).sqrt() * integral);
            pool.entryDeflator = pool.deflator;
        }
    }

    function runLevel(PoolState storage pool, int256 pivotTick, bool side, bool sqRoot) internal returns (FloatBits.Info memory) {
        growRuns(pool);
        Quad t1 = (sqRoot ? (logTick() / POSITIVE_TWO) : logTick());
        Quad log2Pivot = ((t1 * fromInt256(pivotTick)) / LAMBDA);
        Quad t2 = ((side == Z) ? log2Pivot.neg() : log2Pivot);
        int256 modulo = ceil(((t2 - pool.date) + HALF));

        uint256 t3 = side ? 1 : 0;
        SparseFloat.Info storage run = (sqRoot ? pool.reserveRun[t3] : pool.priceRun[t3]);
        return run.read((modulo.toInt128() - WORD_SIZE));
    }

    function uptick(PoolState storage pool) public {
        growRuns(pool);
        Spot._uptick(pool);

        if (pool.tickBin % (1 << subSplits(pool.splits).toUint256()).toInt256() == 0) {
            int256 pivotTick = binLowTick(pool.splits, pool.tickBin);
            bytes32 key;
            key = keccak256(abi.encode(pivotTick, Z));
            Capper.Info storage capperZ = pool.capper[key];
            if (capperZ.isInitialized) capperZ.unpeg(pool, pivotTick, Z);

            key = keccak256(abi.encode(pivotTick, I));
            Capper.Info storage capperI = pool.capper[key];
            if (capperI.isInitialized) capperI.pegUp(pool, pivotTick, I);
        }
    }

    function downtick(PoolState storage pool) public {
        growRuns(pool);

        if (pool.tickBin % (1 << subSplits(pool.splits).toUint256()).toInt256() == 0) {
            int256 pivotTick = binLowTick(pool.splits, pool.tickBin);
            bytes32 key;
            key = keccak256(abi.encode(pivotTick, Z));
            Capper.Info storage capperZ = pool.capper[key];
            if (capperZ.isInitialized) capperZ.pegUp(pool, pivotTick, Z);

            key = keccak256(abi.encode(pivotTick, I));
            Capper.Info storage capperI = pool.capper[key];
            if (capperI.isInitialized) capperI.unpeg(pool, pivotTick, I);
        }

        Spot._downtick(pool);
    }

    function binFracAccrue(PoolState storage pool, Quad accrual, Quad stepRise) public {
        if (accrual > POSITIVE_ZERO) pool.reserveRun[1].add(accrual * pool.epsilon * sqrtStrike(pool.splits, pool.tickBin) * pool.deflator);
        if (stepRise > accrual) pool.reserveRun[0].add((stepRise - accrual) * pool.epsilon / sqrtStrike(pool.splits, pool.tickBin) * pool.deflator);
    }
}
