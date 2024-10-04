// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {OptInt256} from "src/types/Optional/OptInt256.sol";
import {Quad, POSITIVE_ZERO, POSITIVE_TWO} from "src/types/ABDKMathQuad/Quad.sol";
import {MIN_SPLITS, MAX_SPLITS} from "src/Constants.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {DropsGroup, DeadlineSet} from "src/libraries/internal/DeadlineJumps.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";

library EraFaberTotals {
    using DeadlineSet for DeadlineSet.Info;
    using DropsGroup for DeadlineSet.Info;
    using SafeCast for int256;
    using SafeCast for uint256;

    struct Info {
        DeadlineSet.Info[2 << MIN_SPLITS] large;
        DeadlineSet.Info[1 << MAX_SPLITS] small;
        bool below;
    }

    error InvalidSumTotalArguments();
    error InvalidSumRangeArguments();
    error InvalidSubLeftSumArguments();

    function init(Info storage self, bool below) internal {
        self.below = below;
    }

    function dropSum(Info storage self, PoolState storage pool, int256 end, int256 deadEra) internal view returns (Quad) {
        int256 t1;
        int256 t2;
        if (self.below) {
            t1 = 0;
            t2 = end;
        } else {
            t1 = end;
            t2 = (1 << int256(pool.splits).toUint256()).toInt256();
        }

        return sumRangeDropReader(self, pool.splits, t1, t2, deadEra);
    }

    function smallAtDropReader(Info storage self, int256 node, int256 deadEra) internal view returns (Quad) {
        DeadlineSet.Info storage temp = self.small[node.toUint256()];
        return temp.dropAt(deadEra);
    }

    function sumTotalDropReader(Info storage self, int256 scale, int256 startIdx, int256 stopIdx, int256 deadEra) internal view returns (Quad) {
        if (!(((scale <= MIN_SPLITS.toInt256() && ((0 <= startIdx)) && (startIdx <= stopIdx)) && (stopIdx <= (1 << scale.toUint256()).toInt256())))) {
            revert InvalidSumTotalArguments();
        }

        Quad total = POSITIVE_ZERO;

        int256 start = ((1 << scale.toUint256()).toInt256() + startIdx);

        int256 stop = ((1 << scale.toUint256()).toInt256() + stopIdx);

        while ((start != stop)) {
            if (((start & 1) != 0)) {
                total = (total + largeAtDropReader(self, start, deadEra));
                start = (start + 1);
            }

            if (((stop & 1) != 0)) {
                stop = (stop - 1);
                total = (total + largeAtDropReader(self, stop, deadEra));
            }

            start = (start >> 1);
            stop = (stop >> 1);
        }

        return total;
    }

    function sumRangeDropReader(Info storage self, int256 scale, int256 startIdx, int256 stopIdx, int256 deadEra) internal view returns (Quad) {
        if ((scale <= MIN_SPLITS.toInt256())) {
            return sumTotalDropReader(self, scale, startIdx, stopIdx, deadEra);
        } else {
            if (!((((0 <= startIdx) && (startIdx <= stopIdx)) && (stopIdx <= (1 << scale.toUint256()).toInt256())))) {
                revert InvalidSumRangeArguments();
            }

            Quad coarse = sumTotalDropReader(
                self,
                MIN_SPLITS.toInt256(),
                (startIdx >> (scale - MIN_SPLITS.toInt256()).toUint256()),
                (stopIdx >> (scale - MIN_SPLITS.toInt256()).toUint256()),
                deadEra
            );

            return ((coarse - subLeftSumDropReader(self, scale, startIdx, deadEra)) + subLeftSumDropReader(self, scale, stopIdx, deadEra));
        }
    }

    function subLeftSumDropReader(Info storage self, int256 scale, int256 stopIdx, int256 deadEra) internal view returns (Quad) {
        if (((stopIdx % (1 << (scale - MIN_SPLITS.toInt256()).toUint256()).toInt256()) == 0)) {
            return POSITIVE_ZERO;
        } else {
            if (!(scale >= MIN_SPLITS.toInt256() && (((stopIdx & (-1 << scale.toUint256())) == 0)))) revert InvalidSubLeftSumArguments();

            Quad subArea = largeAtDropReader(self, ((1 << MIN_SPLITS).toInt256() + (stopIdx >> (scale - MIN_SPLITS.toInt256()).toUint256())), deadEra);

            Quad total = POSITIVE_ZERO;

            for (int256 depth = MIN_SPLITS.toInt256(); (depth < scale); depth = (depth + 1)) {
                Quad nextCoef = smallAtDropReader(self, ((1 << depth.toUint256()).toInt256() + (stopIdx >> (scale - depth).toUint256())), deadEra);

                bool rightChild = ((stopIdx & (1 << ((scale - depth) - 1).toUint256()).toInt256()) != 0);

                if (rightChild) total = (total + (subArea + nextCoef));

                subArea = (rightChild ? (subArea - nextCoef) : (subArea + nextCoef));
                subArea = (subArea / POSITIVE_TWO);
            }

            return (total / POSITIVE_TWO);
        }
    }

    function largeAtDropReader(Info storage self, int256 node, int256 deadEra) internal view returns (Quad) {
        DeadlineSet.Info storage temp = self.large[node.toUint256()];

        return temp.dropAt(deadEra);
    }
}
