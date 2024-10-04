// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad} from "src/types/ABDKMathQuad/Quad.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {DeadlineJumps, DeadlineSet, PiecewiseCurve} from "src/libraries/internal/DeadlineJumps.sol";
import {OptInt256, wrap, OPT_INT256_NONE} from "src/types/Optional/OptInt256.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";

import {MAX_SPLITS} from "src/Constants.sol";

library EraBoxcarMidSum {
    using DeadlineJumps for DeadlineSet.Info;
    using PiecewiseCurve for DeadlineSet.Info;
    using SafeCast for int256;

    struct Info {
        DeadlineSet.Info[4 << MAX_SPLITS] frame;
        bool ofBelow;
    }

    error OffsetOutOfRange();
    error InvalidAddRangeArguments();

    function init(Info storage self, bool ofBelow) public {
        self.ofBelow = ofBelow;
    }

    function apply_(Info storage self, int256 poolEra, int256 scale, int256 offset) public returns (Quad) {
        if (((offset < 0) || (offset >= int256(1 << scale.toUint256())))) revert OffsetOutOfRange();
        Quad total = coefAt(self, poolEra, 1);
        int256 node = (int256(1 << scale.toUint256()) + offset);
        while ((node > 1)) {
            total = (total + coefAt(self, poolEra, node));
            node = (node >> 1);
        }
        return total;
    }

    function coefAt(Info storage self, int256 poolEra, int256 node) public returns (Quad) {
        return self.frame[node.toUint256()].now(poolEra);
    }

    function coefAddExtend(Info storage self, int256 poolEra, int256 node, Quad amount, OptInt256 oldDeadEra, OptInt256 newDeadEra) public {
        self.frame[node.toUint256()].extend(poolEra, amount, oldDeadEra, newDeadEra);
    }

    function coefAddCreate(Info storage self, int256 poolEra, int256 node, Quad amount, OptInt256 deadEra, OptInt256) public {
        self.frame[node.toUint256()].create(poolEra, amount, deadEra);
    }

    function halfsum(Info storage self, PoolState storage pool, bool ask) public returns (Quad) {
        return apply_(self, pool.era, pool.splits, ask ? int256(pool.tickBin + 1) : int256(pool.tickBin));
    }

    function bidSum(Info storage self, PoolState storage pool) public returns (Quad) {
        return halfsum(self, pool, false);
    }

    function askSum(Info storage self, PoolState storage pool) public returns (Quad) {
        return halfsum(self, pool, true);
    }

    function addRange(
        Info storage self,
        PoolState storage pool,
        int256 scale,
        int256 startIdx,
        int256 stopIdx,
        Quad change,
        OptInt256 deadEra,
        OptInt256 newDeadEra,
        function (Info storage,int256, int256, Quad, OptInt256, OptInt256) internal coeffAdd
    ) internal {
        int256 length = int256(1 << scale.toUint256());

        if (!((((0 <= startIdx) && (startIdx <= stopIdx)) && (stopIdx <= length)))) revert InvalidAddRangeArguments();
        int256 start = (length + startIdx);
        int256 stop = (length + stopIdx);
        while ((start != stop)) {
            if (((start & 1) != 0)) {
                coeffAdd(self, pool.era, start, change, deadEra, newDeadEra);
                start = (start + 1);
            }

            if (((stop & 1) != 0)) {
                stop = (stop - 1);
                coeffAdd(self, pool.era, stop, change, deadEra, newDeadEra);
            }

            start = (start >> 1);
            stop = (stop >> 1);
        }
    }

    function create(Info storage self, PoolState storage pool, Quad amount, int256 scale, int256 offset, OptInt256 deadEra) public {
        int256 startIdx = self.ofBelow ? (offset + 1) : int256(0);
        int256 stopIdx = self.ofBelow ? int256(1 << scale.toUint256()) : (offset + 1);
        addRange(self, pool, scale, startIdx, stopIdx, amount, deadEra, wrap(OPT_INT256_NONE), coefAddCreate);
        coefAddCreate(
            self,
            pool.era,
            (((int256(1 << scale.toUint256()) + offset) << 1) + 1),
            self.ofBelow ? amount : amount.neg(),
            deadEra,
            wrap(OPT_INT256_NONE)
        );
    }

    function extend(Info storage self, PoolState storage pool, Quad amount, int256 scale, int256 offset, OptInt256 deadEra, OptInt256 newDeadEra)
        public
    {
        int256 startIdx = self.ofBelow ? (offset + 1) : int256(0);
        int256 stopIdx = self.ofBelow ? int256(1 << scale.toUint256()) : (offset + 1);
        addRange(self, pool, scale, startIdx, stopIdx, amount, deadEra, newDeadEra, coefAddExtend);
        coefAddExtend(
            self, pool.era, (((int256(1 << scale.toUint256()) + offset) << 1) + 1), self.ofBelow ? amount : amount.neg(), deadEra, newDeadEra
        );
    }
}
