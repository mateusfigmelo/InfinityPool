// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, POSITIVE_ZERO} from "src/types/ABDKMathQuad/Quad.sol";
import {DeadlineJumps, DeadlineSet, PiecewiseCurve} from "src/libraries/internal/DeadlineJumps.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {OptInt256} from "src/types/Optional/OptInt256.sol";
import {MAX_SPLITS, MIN_SPLITS, JUMPS} from "src/Constants.sol";

library DeadlineShaded {
    using DeadlineJumps for DeadlineSet.Info;
    using DeadlineSet for DeadlineSet.Info;
    using PiecewiseCurve for DeadlineSet.Info;

    struct Info {
        DeadlineSet.Info deadlineJumps;
        bool terminal;
    }
}

library JumpyFallback {
    using DeadlineShaded for DeadlineShaded.Info;
    using DeadlineJumps for DeadlineSet.Info;
    using DeadlineSet for DeadlineSet.Info;
    using PiecewiseCurve for DeadlineSet.Info;
    using SafeCast for int256;
    using SafeCast for uint256;

    struct Info {
        DeadlineShaded.Info[1 << MAX_SPLITS] tree;
    }

    error InvalidAtArguments();
    error InvalidEnterArguments();

    function at(
        Info storage self,
        int256 poolEra,
        int256 splits,
        int256 offset,
        function(DeadlineSet.Info storage, int256) internal returns (Quad) read
    ) internal returns (Quad) {
        if (!(((offset & (-1 << splits.toUint256())) == 0))) revert InvalidAtArguments();

        int256 cursor = ((1 << splits.toUint256()).toInt256() + offset);

        while (!(self.tree[cursor.toUint256()].deadlineJumps.touched)) {
            if (((cursor >> MIN_SPLITS) == 1)) return POSITIVE_ZERO;

            cursor = (cursor >> 1);
        }

        DeadlineShaded.Info storage leaf = self.tree[cursor.toUint256()];

        if (leaf.terminal) return read(leaf.deadlineJumps, poolEra);

        bool temp = true;

        while (temp) {
            if (!(((cursor >> MIN_SPLITS) > 1))) revert InvalidAtArguments();

            cursor = (cursor >> 1);
            temp = !(self.tree[cursor.toUint256()].deadlineJumps.touched);
        }

        DeadlineShaded.Info storage trunk = self.tree[cursor.toUint256()];

        if (!trunk.terminal) revert InvalidAtArguments();

        Quad trunkValue = read(trunk.deadlineJumps, poolEra);

        if ((trunk.deadlineJumps.nextJump == JUMPS)) {
            leaf.deadlineJumps.latest = (leaf.deadlineJumps.latest + trunk.deadlineJumps.latest);
            leaf.terminal = true;
            return read(leaf.deadlineJumps, poolEra);
        } else {
            return (trunkValue + read(leaf.deadlineJumps, poolEra));
        }
    }

    function nowAt(Info storage self, int256 poolEra, int256 splits, int256 offset) internal returns (Quad) {
        return at(self, poolEra, splits, offset, PiecewiseCurve.now);
    }

    function dropAt(Info storage self, int256 splits, int256 offset, int256 deadEra) public returns (Quad) {
        return at(self, deadEra, splits, offset, DeadlineSet.dropAt);
    }

    function enter(Info storage self, int256 poolEra, int256 splits, int256 offset) public returns (DeadlineShaded.Info storage) {
        if (!(((offset & (-1 << splits.toUint256())) == 0))) revert InvalidEnterArguments();

        int256 cursor = ((1 << splits.toUint256()).toInt256() + offset);

        DeadlineShaded.Info storage leaf = self.tree[cursor.toUint256()];

        if (leaf.deadlineJumps.touched) return leaf;
        bool temp = true;

        while (temp) {
            cursor = (cursor >> 1);
            if (((cursor >> MIN_SPLITS) == 0)) {
                leaf.terminal = true;
                return leaf;
            }

            temp = !(self.tree[cursor.toUint256()].deadlineJumps.touched);
        }

        DeadlineShaded.Info storage trunk = self.tree[cursor.toUint256()];

        if (trunk.terminal) return leaf;

        while (true) {
            if (!(((cursor >> MIN_SPLITS) > 1))) revert InvalidEnterArguments();

            cursor = (cursor >> 1);
            DeadlineShaded.Info storage base = self.tree[cursor.toUint256()];

            if (base.terminal) {
                trunk.deadlineJumps.latest = (trunk.deadlineJumps.latest + base.deadlineJumps.now(poolEra));
                trunk.terminal = true;
                return leaf;
            }

            if (base.deadlineJumps.touched) revert InvalidEnterArguments();
        }

        return leaf;
    }

    function createOne(Info storage self, int256 poolEra, int256 splits, Quad amount, int256 bin, OptInt256 deadEra) public {
        enter(self, poolEra, splits, bin).deadlineJumps.create(poolEra, amount, deadEra);
    }

    function expireOne(Info storage self, int256 poolEra, int256 splits, Quad amount, int256 bin, int256 deadEra) public {
        enter(self, poolEra, splits, bin).deadlineJumps.expire(poolEra, amount, deadEra);
    }

    function extendOne(Info storage self, int256 poolEra, int256 splits, Quad amount, int256 bin, OptInt256 oldDeadEra, OptInt256 newDeadEra)
        public
    {
        enter(self, poolEra, splits, bin).deadlineJumps.extend(poolEra, amount, oldDeadEra, newDeadEra);
    }
}
