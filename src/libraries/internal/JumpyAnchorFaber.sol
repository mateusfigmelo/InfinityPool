// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, POSITIVE_ZERO, POSITIVE_TWO} from "src/types/ABDKMathQuad/Quad.sol";
import {OptInt256} from "src/types/Optional/OptInt256.sol";
import {MIN_SPLITS, MAX_SPLITS} from "src/Constants.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {DropsGroup, DeadlineSet, PiecewiseCurve, DeadlineJumps} from "src/libraries/internal/DeadlineJumps.sol";
import {EraFaberTotals} from "src/libraries/internal/EraFaberTotals.sol";
import {SignedMath} from "@openzeppelin/contracts/utils/math/SignedMath.sol";
import {JUMPS, JUMP_NONE} from "src/Constants.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";

import {
    jumpBitLength,
    maybeJump,
    jumpIndex as jumpIndexHelper,
    isJumpDefined,
    validDeadline,
    deadEra as deadEraHelper
} from "src/libraries/helpers/DeadlineHelper.sol";

using DeadlineSet for DeadlineSet.Info;
using AnchorSet for AnchorSet.Info;
using Anchor for Anchor.Info;
using JumpyAnchorFaber for JumpyAnchorFaber.Info;
using SafeCast for uint256;
using SafeCast for int256;
using PiecewiseCurve for DeadlineSet.Info;
using DeadlineJumps for DeadlineSet.Info;
using EraFaberTotals for EraFaberTotals.Info;

library Anchor {
    struct Info {
        // Reorder the variables to save gas
        Quad halfsum;
        int32 end;
        bool touched;
    }

    function zero(Info storage self) internal {
        self.touched = false;
        self.end = 0;
        self.halfsum = POSITIVE_ZERO;
    }

    function validEnd(Info storage self, JumpyAnchorFaber.Info storage jumpyAnchorFaberDataStructure) internal returns (int256) {
        if (!self.touched) {
            self.end = int32(jumpyAnchorFaberDataStructure.end);
            self.touched = true;
        }
        return self.end;
    }

    function addAt(Info storage self, JumpyAnchorFaber.Info storage jumpyAnchorFaberDataStructure, int256 bin, Quad amount) internal {
        bool shouldAdd;
        if (jumpyAnchorFaberDataStructure.eraFaberTotals.below) shouldAdd = (bin < validEnd(self, jumpyAnchorFaberDataStructure));
        else shouldAdd = (bin >= validEnd(self, jumpyAnchorFaberDataStructure));

        if (shouldAdd) self.halfsum = self.halfsum + amount;
    }
}

library AnchorSet {
    struct Info {
        Anchor.Info[JUMPS] drops;
        int32 dropsEra;
        int8 nextJump;
        bool touched;
    }

    error InvalidDeadline();

    function dropOff(AnchorSet.Info storage self, Anchor.Info storage drop) internal {}

    function _apply(Info storage self, int256 poolEra, int256 deadEra) internal returns (Anchor.Info storage) {
        int256 idx = self.slot(poolEra, deadEra, dropOff);
        return self.drops[idx.toUint256()];
    }

    function jumpIndex(Info storage self, int256 deadEra) internal view returns (int8) {
        return jumpIndexHelper(self.dropsEra, deadEra);
    }

    function deadEra(Info storage self, int8 jumpIndex) internal view returns (int256) {
        return deadEraHelper(self.dropsEra, jumpIndex);
    }

    function slot(Info storage self, int256 poolEra, int256 deadEra, function (AnchorSet.Info storage, Anchor.Info storage) internal dropoff)
        internal
        returns (int8)
    {
        if (!(validDeadline(poolEra, deadEra))) revert InvalidDeadline();

        if (!(self.touched)) {
            self.dropsEra = int32(poolEra);
            self.nextJump = jumpIndex(self, deadEra);
            self.touched = true;
            return self.nextJump;
        }

        int8 jump = jumpIndex(self, deadEra);

        if (!isJumpDefined(jump)) {
            reanchor(self, poolEra, dropoff);
            jump = maybeJump(self.dropsEra, deadEra);
        }

        if ((jump < self.nextJump)) self.nextJump = jump;

        return int8(jump);
    }

    function assign(
        Info storage self,
        int256 poolEra,
        Anchor.Info storage value,
        int256 deadEra,
        function (AnchorSet.Info storage, Anchor.Info storage) internal dropoff
    ) internal {
        int8 jump = slot(self, poolEra, deadEra, dropoff);
        self.drops[int256(jump).toUint256()] = value;
    }

    function assign(
        Info storage self,
        int256 poolEra,
        Anchor.Info storage value,
        OptInt256 deadEra,
        function (AnchorSet.Info storage, Anchor.Info storage) internal dropoff
    ) internal {
        if (deadEra.isDefined()) assign(self, poolEra, value, deadEra.get(), dropoff);
    }

    function reanchor(Info storage self, int256 poolEra, function (AnchorSet.Info storage, Anchor.Info storage) internal dropoff) internal {
        bool unset = true;

        for (int8 oldIndex = self.nextJump; (oldIndex < JUMPS); oldIndex = (oldIndex + 1)) {
            Anchor.Info storage drop = self.drops[int256(oldIndex).toUint256()];

            if ((!(drop.touched && drop.end == 0 && drop.halfsum == POSITIVE_ZERO))) {
                int256 deadline = deadEra(self, oldIndex);

                if ((deadline <= poolEra)) {
                    dropoff(self, drop);
                } else {
                    int8 newIndex = maybeJump(poolEra, deadline);

                    if (unset) {
                        self.nextJump = newIndex;
                        unset = false;
                    }

                    if ((newIndex == oldIndex)) break;

                    self.drops[int256(newIndex).toUint256()] = drop;
                }
                self.drops[int256(oldIndex).toUint256()].zero();
            }
        }

        self.dropsEra = int32(poolEra);
        if (unset) self.nextJump = JUMPS;
    }
}

library JumpyAnchorFaber {
    struct Info {
        int256 end;
        Quad halfsum;
        EraFaberTotals.Info eraFaberTotals;
        AnchorSet.Info drops;
    }

    error InvalidAddArguments();
    error InvalidSubLeftSumArguments();
    error InvalidCreateArguments();
    error InvalidMoveDropArguments();
    error InvalidSumTotalArguments();
    error InvalidSumRangeArguments();

    function init(Info storage self, int256 end, bool below) public {
        self.end = end;
        self.eraFaberTotals.init(below);
    }

    function setEnd(Info storage self, PoolState storage pool, int256 deadEra, int256 newEnd) public {
        Anchor.Info storage anchor = self.drops._apply(pool.era, deadEra);

        if (anchor.touched) {
            moveDrop(self, pool, anchor, deadEra, newEnd);
        } else {
            anchor.end = int32(newEnd);
            anchor.touched = true;
        }
    }

    function propel(Info storage self, PoolState storage pool, int256 toEra) external {
        int8 temp = self.drops.jumpIndex(toEra);

        if (temp != JUMP_NONE) {
            int8 jumpIndex = temp;

            int256 idx = int256(jumpIndex);

            Anchor.Info storage anchor = self.drops.drops[idx.toUint256()];

            if (anchor.touched) {
                moveDrop(self, pool, anchor, toEra, self.end);
                self.halfsum = self.halfsum - anchor.halfsum;
                self.drops.drops[idx.toUint256()].zero();
            }

            int256 t2 = (idx + 1);

            int8 t3 = t2.toInt8();

            self.drops.nextJump = t3;
        }
    }

    function largeAddExpireWriter(Info storage self, int256 poolEra, int256 node, Quad amount, int256, int256 deadEra) public {
        DeadlineSet.Info storage temp = self.eraFaberTotals.large[node.toUint256()];

        temp.expire(poolEra, amount, deadEra);
    }

    function largeAddCreateWriter(Info storage self, int256 poolEra, int256 node, Quad amount, int256, OptInt256 deadEra) public {
        DeadlineSet.Info storage temp = self.eraFaberTotals.large[node.toUint256()];

        temp.create(poolEra, amount, deadEra);
    }

    function lateCreate(Info storage self, int256 poolEra, Quad amount, int256 scale, int256 offset, OptInt256 deadEra) public {
        addCreateWriter(self, poolEra, scale, offset, amount, deadEra);
    }

    function smallAddCreateWriter(Info storage self, int256 poolEra, int256 node, Quad amount, OptInt256 deadEra) public {
        DeadlineSet.Info storage temp = self.eraFaberTotals.small[node.toUint256()];

        temp.create(poolEra, amount, deadEra);
    }

    function smallAddExpireWriter(Info storage self, int256 poolEra, int256 node, Quad amount, int256 deadEra) public {
        DeadlineSet.Info storage temp = self.eraFaberTotals.small[node.toUint256()];

        temp.expire(poolEra, amount, deadEra);
    }

    struct AddCreateWriteLocalState {
        Quad[] carry;
        int256 first;
        int256 node;
        int256 depth;
        Quad change;
        uint256 index;
        bool leftChild;
    }

    function addCreateWriter(Info storage self, int256 poolEra, int256 scale, int256 start, Quad[] memory areas, OptInt256 deadEra) public {
        AddCreateWriteLocalState memory localState;

        if (!((scale >= MIN_SPLITS.toInt256() && ((start >= 0)) && ((start + areas.length.toInt256()) <= (1 << scale.toUint256()).toInt256())))) {
            revert InvalidAddArguments();
        }

        localState.carry = new Quad[](scale.toUint256());
        localState.first = ((1 << scale.toUint256()).toInt256() + start);

        for (localState.index = 0; (localState.index < areas.length); localState.index++) {
            localState.node = (localState.first + int256(localState.index));
            localState.change = areas[localState.index];
            localState.depth = (scale - 1);

            while (localState.depth >= MIN_SPLITS.toInt256()) {
                localState.leftChild = ((localState.node & 1) == 0);

                localState.node = (localState.node >> 1);

                if (localState.leftChild) {
                    localState.carry[localState.depth.toUint256()] = localState.change;
                    break;
                } else {
                    smallAddCreateWriter(
                        self, poolEra, localState.node, (localState.carry[localState.depth.toUint256()] - localState.change), deadEra
                    );
                    localState.change = (localState.change + localState.carry[localState.depth.toUint256()]);
                }

                localState.depth = (localState.depth - 1);
            }

            if (localState.depth < MIN_SPLITS.toInt256()) {
                largeAddCreateWriter(self, poolEra, localState.node, localState.change, MIN_SPLITS.toInt256(), deadEra);

                while (true) {
                    localState.leftChild = ((localState.node & 1) == 0);
                    localState.node = (localState.node >> 1);

                    if (localState.leftChild) {
                        localState.carry[localState.depth.toUint256()] = localState.change;
                        break;
                    } else {
                        localState.change = (localState.change + localState.carry[localState.depth.toUint256()]);

                        if (localState.node <= 1) break;

                        largeAddCreateWriter(self, poolEra, localState.node, localState.change, localState.depth, deadEra);
                    }

                    localState.depth = (localState.depth - 1);
                }
            }
        }

        if (localState.depth >= MIN_SPLITS.toInt256()) {
            smallAddCreateWriter(self, poolEra, localState.node, localState.change, deadEra);

            while (localState.depth > MIN_SPLITS.toInt256()) {
                localState.depth = (localState.depth - 1);
                localState.leftChild = ((localState.node & 1) == 0);
                localState.node = (localState.node >> 1);

                if (localState.leftChild) {
                    smallAddCreateWriter(self, poolEra, localState.node, localState.change, deadEra);
                } else {
                    smallAddCreateWriter(
                        self, poolEra, localState.node, (localState.carry[localState.depth.toUint256()] - localState.change), deadEra
                    );
                    localState.change = (localState.change + localState.carry[localState.depth.toUint256()]);
                }
            }
        }

        while (localState.node > 1) {
            largeAddCreateWriter(self, poolEra, localState.node, localState.change, localState.depth, deadEra);
            localState.depth = (localState.depth - 1);

            if ((localState.node & 1) != 0) localState.change = (localState.change + localState.carry[localState.depth.toUint256()]);

            localState.node = (localState.node >> 1);
        }

        largeAddCreateWriter(self, poolEra, 1, localState.change, 0, deadEra);
    }

    function addCreateWriter(Info storage self, int256 poolEra, int256 scale, int256 offset, Quad area, OptInt256 deadEra) public {
        if (!(scale >= MIN_SPLITS.toInt256() && (((offset & (-1 << scale.toUint256())) == 0)))) revert InvalidAddArguments();

        int256 node = ((1 << scale.toUint256()).toInt256() + offset);

        while ((node >= (2 << MIN_SPLITS).toInt256())) {
            bool branchUp = ((node & 1) != 0);

            node = (node >> 1);
            if (branchUp) smallAddCreateWriter(self, poolEra, node, area.neg(), deadEra);
            else smallAddCreateWriter(self, poolEra, node, area, deadEra);
        }

        int256 depth = MIN_SPLITS.toInt256();

        while ((node > 0)) {
            largeAddCreateWriter(self, poolEra, node, area, depth, deadEra);
            node = (node >> 1);
            depth = (depth - 1);
        }
    }

    function smallAtNowReader(Info storage self, int256 poolEra, int256 node) public returns (Quad) {
        DeadlineSet.Info storage temp = self.eraFaberTotals.small[node.toUint256()];

        return temp.now(poolEra);
    }

    function lateExpire(Info storage self, int256 poolEra, Quad amount, int256 scale, int256 offset, int256 deadEra) public {
        addExpireWriter(self, poolEra, scale, offset, amount, deadEra);
    }

    function subLeftSumNowReader(Info storage self, int256 poolEra, int256 scale, int256 stopIdx) public returns (Quad) {
        if (((stopIdx % (1 << (scale - MIN_SPLITS.toInt256()).toUint256()).toInt256()) == 0)) {
            return POSITIVE_ZERO;
        } else {
            if (!(scale >= MIN_SPLITS.toInt256() && (((stopIdx & (-1 << scale.toUint256())) == 0)))) revert InvalidSubLeftSumArguments();

            Quad subArea = largeAtNowReader(self, poolEra, ((1 << MIN_SPLITS).toInt256() + (stopIdx >> (scale - MIN_SPLITS.toInt256()).toUint256())));

            Quad total = POSITIVE_ZERO;

            for (int256 depth = MIN_SPLITS.toInt256(); (depth < scale); depth = (depth + 1)) {
                Quad nextCoef = smallAtNowReader(self, poolEra, ((1 << depth.toUint256()).toInt256() + (stopIdx >> (scale - depth).toUint256())));

                bool branchUp = ((stopIdx & (1 << ((scale - depth) - 1).toUint256()).toInt256()) != 0);

                if (branchUp) total = (total + (subArea + nextCoef));

                if (branchUp) subArea = (subArea - nextCoef);
                else subArea = (subArea + nextCoef);

                subArea = (subArea / POSITIVE_TWO);
            }

            return (total / POSITIVE_TWO);
        }
    }

    function largeAtNowReader(Info storage self, int256 poolEra, int256 node) public returns (Quad) {
        DeadlineSet.Info storage temp = self.eraFaberTotals.large[node.toUint256()];

        return temp.now(poolEra);
    }

    function sumRangeNowReader(Info storage self, int256 poolEra, int256 scale, int256 startIdx, int256 stopIdx) public returns (Quad) {
        if ((scale <= MIN_SPLITS.toInt256())) {
            return sumTotalNowReader(self, poolEra, scale, startIdx, stopIdx);
        } else {
            if (!((((0 <= startIdx) && (startIdx <= stopIdx)) && (stopIdx <= (1 << scale.toUint256()).toInt256())))) {
                revert InvalidSumRangeArguments();
            }

            Quad coarse = sumTotalNowReader(
                self,
                poolEra,
                MIN_SPLITS.toInt256(),
                (startIdx >> (scale - MIN_SPLITS.toInt256()).toUint256()),
                (stopIdx >> (scale - MIN_SPLITS.toInt256()).toUint256())
            );

            return ((coarse - subLeftSumNowReader(self, poolEra, scale, startIdx)) + subLeftSumNowReader(self, poolEra, scale, stopIdx));
        }
    }

    function addExpireWriter(Info storage self, int256 poolEra, int256 scale, int256 offset, Quad area, int256 deadEra) public {
        if (!(scale >= MIN_SPLITS.toInt256() && (((offset & (-1 << scale.toUint256())) == 0)))) revert InvalidAddArguments();

        int256 node = ((1 << scale.toUint256()).toInt256() + offset);

        while ((node >= (2 << MIN_SPLITS).toInt256())) {
            bool branchUp = ((node & 1) != 0);

            node = (node >> 1);
            if (branchUp) smallAddExpireWriter(self, poolEra, node, area.neg(), deadEra);
            else smallAddExpireWriter(self, poolEra, node, area, deadEra);
        }

        int256 depth = MIN_SPLITS.toInt256();

        while ((node > 0)) {
            largeAddExpireWriter(self, poolEra, node, area, depth, deadEra);
            node = (node >> 1);
            depth = (depth - 1);
        }
    }

    function move(Info storage self, PoolState storage pool, int256 newEnd) public {
        Quad diff = sumRangeNowReader(self, pool.era, pool.splits, SignedMath.min(self.end, newEnd), SignedMath.max(self.end, newEnd));

        if (self.eraFaberTotals.below != ((newEnd < self.end))) self.halfsum = self.halfsum + diff;
        else self.halfsum = self.halfsum + diff.neg();

        self.end = newEnd;
    }

    function create(Info storage self, PoolState storage pool, Quad[] memory amounts, int256 scale, int256 start, OptInt256 deadEra) public {
        if (!((scale <= pool.splits))) revert InvalidCreateArguments();

        addCreateWriter(self, pool.era, scale, start, amounts, deadEra);

        int256 _start;
        if (self.eraFaberTotals.below) _start = 0;
        else _start = SignedMath.max((self.end - start), 0);

        int256 _end;
        if (self.eraFaberTotals.below) _end = SignedMath.min((self.end - start), amounts.length.toInt256());
        else _end = amounts.length.toInt256();

        for (int256 index = _start; (index < _end); index = (index + 1)) {
            self.halfsum = (self.halfsum + amounts[index.toUint256()]);
        }

        if (deadEra.isDefined()) {
            int256 _deadEra = deadEra.get();

            Anchor.Info storage anchor = self.drops._apply(pool.era, _deadEra);

            int256 end = anchor.validEnd(self);

            int256 _start;
            if (self.eraFaberTotals.below) _start = 0;
            else _start = SignedMath.max((end - start), 0);

            int256 _end;
            if (self.eraFaberTotals.below) _end = SignedMath.min((end - start), amounts.length.toInt256());
            else _end = amounts.length.toInt256();

            for (int256 index = _start; (index < _end); index = (index + 1)) {
                anchor.halfsum = (anchor.halfsum + amounts[index.toUint256()]);
            }
        }
    }

    function moveDrop(Info storage self, PoolState storage pool, Anchor.Info storage anchor, int256 deadEra, int256 newEnd) public {
        if (!(anchor.touched)) revert InvalidMoveDropArguments();

        Quad diff =
            self.eraFaberTotals.sumRangeDropReader(pool.splits, SignedMath.min(anchor.end, newEnd), SignedMath.max(anchor.end, newEnd), deadEra);

        if (self.eraFaberTotals.below != ((newEnd < anchor.end))) anchor.halfsum = anchor.halfsum + diff;
        else anchor.halfsum = anchor.halfsum + diff.neg();

        anchor.end = int32(newEnd);
    }

    function sumTotalNowReader(Info storage self, int256 poolEra, int256 scale, int256 startIdx, int256 stopIdx) public returns (Quad) {
        if (!(((scale <= MIN_SPLITS.toInt256() && ((0 <= startIdx)) && (startIdx <= stopIdx)) && (stopIdx <= (1 << scale.toUint256()).toInt256())))) {
            revert InvalidSumTotalArguments();
        }

        Quad total = POSITIVE_ZERO;

        int256 start = ((1 << scale.toUint256()).toInt256() + startIdx);

        int256 stop = ((1 << scale.toUint256()).toInt256() + stopIdx);

        while ((start != stop)) {
            if (((start & 1) != 0)) {
                total = (total + largeAtNowReader(self, poolEra, start));
                start = (start + 1);
            }

            if (((stop & 1) != 0)) {
                stop = (stop - 1);
                total = (total + largeAtNowReader(self, poolEra, stop));
            }

            start = (start >> 1);
            stop = (stop >> 1);
        }

        return total;
    }
}
