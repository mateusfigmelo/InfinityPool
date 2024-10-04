// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {JUMPS, JUMP_NONE} from "src/Constants.sol";
import {OptInt256} from "src/types/Optional/OptInt256.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {
    maybeJump, jumpIndex as jumpIndexHelper, isJumpDefined, validDeadline, deadEra as deadEraHelper
} from "src/libraries/helpers/DeadlineHelper.sol";

library DeadlineFlag {
    using DeadlineFlag for DeadlineFlag.Info;
    using SafeCast for uint256;
    using SafeCast for int256;

    struct Info {
        int32 dropsEra;
        int8 nextJump;
        bool touched;
        bool[JUMPS] drops;
    }

    error InvalidDeadline();

    function dropOff(DeadlineFlag.Info storage self, bool drop) internal {}

    function dropAt(Info storage self, int256 deadEra) internal view returns (bool) {
        if (jumpIndex(self, deadEra) == JUMP_NONE) return false;
        else return self.drops[int256(jumpIndex(self, deadEra)).toUint256()];
    }

    function _apply(Info storage self, int256 poolEra, int256 deadEra) internal returns (bool) {
        int256 idx = self.slot(deadEra, poolEra, dropOff);
        return self.drops[idx.toUint256()];
    }

    function jumpIndex(Info storage self, int256 deadline) internal view returns (int8) {
        return jumpIndexHelper(self.dropsEra, deadline);
    }

    function deadEra(Info storage self, int8 jumpIndex) internal view returns (int256) {
        return deadEraHelper(self.dropsEra, jumpIndex);
    }

    function slot(Info storage self, int256 poolEra, int256 deadEra, function (DeadlineFlag.Info storage, bool) internal dropoff)
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

    function assign(Info storage self, int256 poolEra, bool value, int256 deadEra) internal {
        int8 jump = slot(self, poolEra, deadEra, dropOff);
        self.drops[int256(jump).toUint256()] = value;
    }

    function assign(Info storage self, int256 poolEra, bool value, OptInt256 deadEra) internal {
        if (deadEra.isDefined()) assign(self, poolEra, value, deadEra.get());
    }

    function reanchor(Info storage self, int256 poolEra, function (DeadlineFlag.Info storage, bool) internal dropoff) internal {
        bool unset = true;

        for (int8 oldIndex = self.nextJump; (oldIndex < JUMPS); oldIndex = (oldIndex + 1)) {
            bool drop = self.drops[int256(oldIndex).toUint256()];

            if (drop) {
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
                self.drops[int256(oldIndex).toUint256()] = false;
            }
        }

        self.dropsEra = int32(poolEra);
        if (unset) self.nextJump = JUMPS;
    }
}
