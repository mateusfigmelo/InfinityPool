// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, fromInt256, POSITIVE_ZERO, POSITIVE_TWO} from "src/types/ABDKMathQuad/Quad.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {DeadlineJumps, DeadlineSet, PiecewiseCurve, PiecewiseGrowthNew, TailedJumps, DropsGroup} from "src/libraries/internal/DeadlineJumps.sol";
import {OptInt256, wrap} from "src/types/Optional/OptInt256.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";

import {MAX_SPLITS, MIN_SPLITS} from "src/Constants.sol";

library GrowthSplitFrame {
    using SafeCast for int256;
    using SafeCast for uint256;
    using PiecewiseGrowthNew for PiecewiseGrowthNew.Info;
    using DeadlineJumps for DeadlineSet.Info;
    using DropsGroup for DeadlineSet.Info;
    using PiecewiseCurve for DeadlineSet.Info;
    using TailedJumps for TailedJumps.Info;

    struct Info {
        PiecewiseGrowthNew.Info[2 << MIN_SPLITS] large;
        TailedJumps.Info[1 << MAX_SPLITS] small;
        int32 activeLeaf;
        bool below;
    }

    error InvalidSumTotalArguments();
    error InvalidAccruedRangeArguments();
    error InvalidAreaArguments();
    error InvalidAddArguments();
    error InvalidSumRangeArguments();
    error InvalidSubLeftSumArguments();

    function init(Info storage self, PoolState storage pool, int256 initBin, bool below) public {
        self.activeLeaf = int32(int256(1 << int256(pool.splits).toUint256()) + initBin);
        self.below = below;
    }

    function live(Info storage self, int256 splits) public view returns (PiecewiseGrowthNew.Info storage) {
        return self.large[int256(self.activeLeaf).toUint256() >> (splits - int256(MIN_SPLITS)).toUint256()];
    }

    function largeAtAccruedReader(Info storage self, int256 poolEra, Quad poolDeflator, int256 node) public returns (Quad) {
        return self.large[node.toUint256()].grow(poolEra, poolDeflator);
    }

    function largeAtTailReader(Info storage self, int256, Quad, int256 node) public view returns (Quad) {
        return self.large[node.toUint256()].tail;
    }

    function largeAtNowReader(Info storage self, PoolState storage pool, int256, Quad, int256 node) public returns (Quad) {
        return self.large[node.toUint256()].deadlineJumps.now(pool.era);
    }

    function sumTotal(
        Info storage self,
        int256 poolEra,
        Quad poolDeflator,
        int256 scale,
        int256 startIdx,
        int256 stopIdx,
        function (Info storage, int256, Quad,int256) returns(Quad) largeAt
    ) internal returns (Quad) {
        if (!(((scale <= int256(MIN_SPLITS) && (0 <= startIdx)) && (stopIdx <= int256(1 << scale.toUint256()))))) revert InvalidSumTotalArguments();

        Quad total;
        int256 start = (int256(1 << scale.toUint256()) + startIdx);
        int256 stop = (int256(1 << scale.toUint256()) + stopIdx);

        while ((start < stop)) {
            if (((start & 1) != 0)) {
                total = (total + largeAt(self, poolEra, poolDeflator, start));
                start = (start + 1);
            }
            if (((stop & 1) != 0)) {
                stop = (stop - 1);
                total = (total + largeAt(self, poolEra, poolDeflator, stop));
            }
            start = (start >> 1);
            stop = (stop >> 1);
        }
        return total;
    }

    function binRate(Info storage self, PoolState storage pool) public returns (Quad) {
        return areaNowReader(self, pool, pool.splits, pool.tickBin);
    }

    function dirtyRate(Info storage self, PoolState storage pool) public returns (Quad) {
        Quad left = subLeftSumNowReader(self, pool, pool.splits, pool.tickBin);
        return self.below ? left : live(self, pool.splits).deadlineJumps.now(pool.era) - left;
    }

    function sumOutside(Info storage self, int256 poolEra, Quad poolDeflator, int256 startTub, int256 stopTub) public returns (Quad) {
        return sumTotal(self, poolEra, poolDeflator, int256(MIN_SPLITS), startTub, stopTub, largeAtAccruedReader);
    }

    function accruedRange(Info storage self, PoolState storage pool, int256 startTub, int256 stopTub) public returns (Quad) {
        if (!((startTub < stopTub))) revert InvalidAccruedRangeArguments();
        int256 activeTub =
            (int256(int256(self.activeLeaf) - int256(1 << int256(pool.splits).toUint256())) >> (int256(pool.splits) - int256(MIN_SPLITS)).toUint256());
        if (activeTub < startTub || ((stopTub <= activeTub))) {
            return sumOutside(self, pool.era, pool.deflator, startTub, stopTub);
        } else {
            return (
                (sumOutside(self, pool.era, pool.deflator, startTub, activeTub) + live(self, pool.splits).accrued)
                    + sumOutside(self, pool.era, pool.deflator, (activeTub + 1), stopTub)
            );
        }
    }

    function smallAtTailReader(Info storage self, int256 node) public view returns (Quad) {
        return self.small[node.toUint256()].tail;
    }

    function smallAtNowReader(Info storage self, PoolState storage pool, int256 node) public returns (Quad) {
        return self.small[node.toUint256()].deadlineJumps.now(pool.era);
    }

    function areaTailReader(Info storage self, int256 scale, int256 offset) public view returns (Quad) {
        if (!(((offset & int256(-1 << scale.toUint256())) == 0))) revert InvalidAreaArguments();
        int256 node = (int256(1 << scale.toUint256()) + offset);
        int256 temp = ((scale > int256(MIN_SPLITS)) ? int256(node >> (scale - int256(MIN_SPLITS)).toUint256()) : node);

        Quad subArea = largeAtTailReader(self, 0, POSITIVE_ZERO, temp);
        for (int256 depth = int256(MIN_SPLITS); (depth < scale); depth = (depth + 1)) {
            Quad nextCoef = smallAtTailReader(self, (int256(1 << depth.toUint256()) + int256(offset >> (scale - depth).toUint256())));
            bool rightChild = ((offset & int256(1 << ((scale - depth).toUint256() - 1))) != 0);
            subArea = (rightChild ? (subArea - nextCoef) : (subArea + nextCoef));
            subArea = (subArea / POSITIVE_TWO);
        }
        return subArea;
    }

    function areaNowReader(Info storage self, PoolState storage pool, int256 scale, int256 offset) public returns (Quad) {
        if (!(((offset & int256(-1 << scale.toUint256())) == 0))) revert InvalidAreaArguments();
        int256 node = (int256(1 << scale.toUint256()) + offset);
        int256 temp = ((scale > int256(MIN_SPLITS)) ? int256(node >> (scale - int256(MIN_SPLITS)).toUint256()) : node);

        Quad subArea = largeAtNowReader(self, pool, 0, POSITIVE_ZERO, temp);
        for (int256 depth = int256(MIN_SPLITS); (depth < scale); depth = (depth + 1)) {
            Quad nextCoef = smallAtNowReader(self, pool, (int256(1 << depth.toUint256()) + int256(offset >> (scale - depth).toUint256())));
            bool rightChild = ((offset & int256(1 << ((scale - depth).toUint256() - 1))) != 0);
            subArea = (rightChild ? (subArea - nextCoef) : (subArea + nextCoef));
            subArea = (subArea / POSITIVE_TWO);
        }
        return subArea;
    }

    function subLeftSumTailReader(Info storage self, int256 scale, int256 stopIdx) public view returns (Quad) {
        if (((stopIdx % int256(1 << (scale - int256(MIN_SPLITS)).toUint256())) == 0)) {
            return POSITIVE_ZERO;
        } else {
            if (!(scale >= int256(MIN_SPLITS) && (((stopIdx & int256(-1 << scale.toUint256())) == 0)))) revert InvalidSubLeftSumArguments();
            Quad subArea = largeAtTailReader(
                self, 0, POSITIVE_ZERO, int256((1 << MIN_SPLITS) + (stopIdx >> (scale - int256(MIN_SPLITS)).toUint256()).toUint256())
            );

            Quad total = POSITIVE_ZERO;
            for (int256 depth = int256(MIN_SPLITS); (depth < scale); depth = (depth + 1)) {
                Quad nextCoef = smallAtTailReader(self, int256((1 << depth.toUint256()) + uint256(stopIdx >> (scale - depth).toUint256())));

                bool rightChild = ((stopIdx & int256(1 << ((scale - depth) - 1).toUint256())) != 0);

                if (rightChild) total = (total + (subArea + nextCoef));
                subArea = (rightChild ? (subArea - nextCoef) : (subArea + nextCoef));
                subArea = (subArea / POSITIVE_TWO);
            }
            return (total / POSITIVE_TWO);
        }
    }

    function subLeftSumNowReader(Info storage self, PoolState storage pool, int256 scale, int256 stopIdx) public returns (Quad) {
        if (((stopIdx % int256(1 << (scale - int256(MIN_SPLITS)).toUint256())) == 0)) {
            return POSITIVE_ZERO;
        } else {
            if (!(scale >= int256(MIN_SPLITS) && (((stopIdx & int256(-1 << scale.toUint256())) == 0)))) revert InvalidSubLeftSumArguments();
            Quad subArea = largeAtNowReader(
                self, pool, 0, POSITIVE_ZERO, int256((1 << MIN_SPLITS) + (stopIdx >> (scale - int256(MIN_SPLITS)).toUint256()).toUint256())
            );

            Quad total = POSITIVE_ZERO;
            for (int256 depth = int256(MIN_SPLITS); (depth < scale); depth = (depth + 1)) {
                Quad nextCoef = smallAtNowReader(self, pool, int256((1 << depth.toUint256()) + uint256(stopIdx >> (scale - depth).toUint256())));

                bool rightChild = ((stopIdx & int256(1 << ((scale - depth) - 1).toUint256())) != 0);

                if (rightChild) total = (total + (subArea + nextCoef));
                subArea = (rightChild ? (subArea - nextCoef) : (subArea + nextCoef));
                subArea = (subArea / POSITIVE_TWO);
            }
            return (total / POSITIVE_TWO);
        }
    }

    function sumRangeTailReader(Info storage self, PoolState storage pool, int256 scale, int256 startIdx, int256 stopIdx) public returns (Quad) {
        if ((scale <= int256(MIN_SPLITS))) {
            return sumTotal(self, pool.era, pool.deflator, scale, startIdx, stopIdx, largeAtTailReader);
        } else {
            if (!((0 <= startIdx) && (stopIdx <= int256(1 << scale.toUint256())))) revert InvalidSumRangeArguments();
            if (startIdx < stopIdx) {
                Quad coarse = sumTotal(
                    self,
                    pool.era,
                    pool.deflator,
                    int256(MIN_SPLITS),
                    int256(startIdx >> (scale - int256(MIN_SPLITS)).toUint256()),
                    int256(stopIdx >> (scale - int256(MIN_SPLITS)).toUint256()),
                    largeAtTailReader
                );
                return ((coarse - subLeftSumTailReader(self, scale, startIdx)) + subLeftSumTailReader(self, scale, stopIdx));
            } else {
                return POSITIVE_ZERO;
            }
        }
    }

    function sumTail(Info storage self, PoolState storage pool, int256 startTub, int256 stopTub) internal returns (Quad) {
        return sumRangeTailReader(self, pool, pool.splits, startTub, stopTub);
    }

    function tailAt(Info storage self, PoolState storage pool, int256 bin) public view returns (Quad) {
        return areaTailReader(self, pool.splits, bin);
    }

    function move(Info storage self, PoolState storage pool, bool up) public {
        int256 oldNode = int256(self.activeLeaf >> (pool.splits - int256(MIN_SPLITS)).toUint256());

        self.activeLeaf = (up ? (self.activeLeaf + 1) : (self.activeLeaf - 1));
        int256 newNode = int256(self.activeLeaf >> (pool.splits - int256(MIN_SPLITS)).toUint256());

        if ((newNode == oldNode)) return;
        bool thawing = (up == self.below);
        Quad accrued = self.large[oldNode.toUint256()].accrued;

        while (true) {
            if (thawing) self.large[oldNode.toUint256()].markAccrual(pool.era, pool.deflator);
            else self.large[newNode.toUint256()].grow(pool.era, pool.deflator);
            self.large[newNode.toUint256()].atDeflator = POSITIVE_ZERO;
            int256 sibling = oldNode ^ 1;

            oldNode = (oldNode >> 1);
            newNode = (newNode >> 1);
            if ((newNode == oldNode)) return;
            accrued = (accrued + self.large[sibling.toUint256()].grow(pool.era, pool.deflator));
            self.large[oldNode.toUint256()].accrued = accrued;
        }
    }

    function accruing(Info storage self, PoolState storage pool, int256 node, int256 depth) public view returns (bool) {
        int256 active = int256(self.activeLeaf >> (pool.splits - depth).toUint256());
        if (self.below) return (node < active);
        else return (active < node);
    }

    function largeAddCreate(Info storage self, PoolState storage pool, int256 node, Quad amount, int256 depth, OptInt256 deadEra, OptInt256) public {
        self.large[node.toUint256()].create(pool.era, pool.deflator, amount, deadEra, accruing(self, pool, node, depth));
    }

    function smallAddCreate(Info storage self, PoolState storage pool, int256 node, Quad amount, OptInt256 deadEra, OptInt256) public {
        self.small[node.toUint256()].create(pool.era, amount, deadEra);
    }

    struct AddLocalVars {
        Quad[] carry;
        int256 first;
        int256 node;
        int256 depth;
        Quad change;
    }

    function add(
        Info storage self,
        PoolState storage pool,
        int256 scale,
        int256 start,
        Quad[] memory areas,
        OptInt256 aDeadEra,
        OptInt256 newDeadEra,
        function (Info storage, PoolState storage, int256, Quad, int256, OptInt256, OptInt256) internal largeAdd,
        function (Info storage, PoolState storage, int256, Quad, OptInt256, OptInt256) internal smallAdd
    ) internal {
        AddLocalVars memory vars;

        if (!((scale.toUint256() >= MIN_SPLITS && ((start >= 0)) && ((start.toUint256() + areas.length) <= (1 << scale.toUint256()))))) {
            revert InvalidAddArguments();
        }

        vars.carry = new Quad[](scale.toUint256());
        vars.first = ((1 << scale.toUint256()) + start.toUint256()).toInt256();
        vars.node = 0;
        vars.depth = 0;
        vars.change = POSITIVE_ZERO;

        for (int256 index = 0; (index.toUint256() < areas.length); index = (index + 1)) {
            vars.node = (vars.first + index);
            vars.change = areas[index.toUint256()];
            vars.depth = (scale - 1);
            while ((vars.depth.toUint256() >= MIN_SPLITS)) {
                bool leftChild = ((vars.node & 1) == 0);

                vars.node = (vars.node >> 1);
                if (leftChild) {
                    vars.carry[vars.depth.toUint256()] = vars.change;
                    break;
                } else {
                    smallAdd(self, pool, vars.node, (vars.carry[vars.depth.toUint256()] - vars.change), aDeadEra, newDeadEra);
                    vars.change = (vars.change + vars.carry[vars.depth.toUint256()]);
                }
                vars.depth = (vars.depth - 1);
            }

            if ((vars.depth.toUint256() < MIN_SPLITS)) {
                largeAdd(self, pool, vars.node, vars.change, MIN_SPLITS.toInt256(), aDeadEra, newDeadEra);
                while (true) {
                    bool leftChild = ((vars.node & 1) == 0);

                    vars.node = (vars.node >> 1);
                    if (leftChild) {
                        vars.carry[vars.depth.toUint256()] = vars.change;
                        break;
                    } else {
                        vars.change = (vars.change + vars.carry[vars.depth.toUint256()]);
                        if ((vars.node <= 1)) break;

                        largeAdd(self, pool, vars.node, vars.change, vars.depth, aDeadEra, newDeadEra);
                    }
                    vars.depth = (vars.depth - 1);
                }
            }
        }

        if ((vars.depth.toUint256() >= MIN_SPLITS)) {
            smallAdd(self, pool, vars.node, vars.change, aDeadEra, newDeadEra);
            while ((vars.depth.toUint256() > MIN_SPLITS)) {
                vars.depth = (vars.depth - 1);
                bool leftChild = ((vars.node & 1) == 0);

                vars.node = (vars.node >> 1);
                if (leftChild) {
                    smallAdd(self, pool, vars.node, vars.change, aDeadEra, newDeadEra);
                } else {
                    smallAdd(self, pool, vars.node, (vars.carry[vars.depth.toUint256()] - vars.change), aDeadEra, newDeadEra);
                    vars.change = (vars.change + vars.carry[vars.depth.toUint256()]);
                }
            }
        }

        while ((vars.node > 1)) {
            largeAdd(self, pool, vars.node, vars.change, vars.depth, aDeadEra, newDeadEra);
            vars.depth = (vars.depth - 1);
            if (((vars.node & 1) != 0)) vars.change = (vars.change + vars.carry[vars.depth.toUint256()]);

            vars.node = (vars.node >> 1);
        }

        largeAdd(self, pool, 1, vars.change, 0, aDeadEra, newDeadEra);
    }

    function create(Info storage self, PoolState storage pool, int256 scale, int256 start, Quad[] memory areas, OptInt256 deadEra) public {
        add(self, pool, scale, start, areas, deadEra, wrap(0), largeAddCreate, smallAddCreate);
    }
}
