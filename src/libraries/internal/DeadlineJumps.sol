// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, POSITIVE_ZERO, wrap} from "src/types/ABDKMathQuad/Quad.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {OptInt256} from "src/types/Optional/OptInt256.sol";
import {JUMPS, JUMP_NONE} from "src/Constants.sol";
import {eraDate, getDeflatorStep} from "src/libraries/helpers/PoolHelper.sol";
import {
    jumpBitLength,
    maybeJump,
    jumpIndex as jumpIndexHelper,
    isJumpDefined,
    validDeadline,
    deadEra as deadEraHelper
} from "src/libraries/helpers/DeadlineHelper.sol";

/**
 * @dev This library allows for tracking float values called "drops" associated to future time points, they are defined as a finite and fixed number of indexes (up to `JUMPS`) based on the `dropsEra` tracked in the data structure.
 * @dev The tracked values represent liquidity drops expiring in the future.
 * @dev The functions overloading on `deadEra` that can be both specified or not (int256 vs OptInt256) are used to keep the caller logic simpler since the overloading is resolved internally in the library.
 */
library DeadlineSet {
    using SafeCast for int256;

    struct Info {
        Quad[JUMPS] drops;
        Quad latest;
        int32 dropsEra;
        // The next `jump` (0 <= `jump` < `JUMPS`) to be processed
        int8 nextJump;
        // If the data structure is initialized
        bool touched;
    }

    error InvalidDeadline();

    /**
     * @dev Conversion function from an "era" to a "jump"
     */
    function jumpIndex(Info storage self, int256 deadEra) internal view returns (int8) {
        return jumpIndexHelper(self.dropsEra, deadEra);
    }

    /**
     * @dev Conversion function from a "jump" to an "era"
     */
    function deadEra(Info storage self, int8 jumpIndex) internal view returns (int256) {
        return deadEraHelper(self.dropsEra, jumpIndex);
    }

    function dropAt(Info storage self, int256 deadEra) internal view returns (Quad) {
        if (jumpIndex(self, deadEra) == JUMP_NONE) return POSITIVE_ZERO;
        else return self.drops[int256(jumpIndex(self, deadEra)).toUint256()];
    }

    /**
     * @dev This function returns the index in the drops array that corresponds to the input deadEra.
     * @dev This function is called within many other functions to get the nextJump Index to work on.
     * @param self The storage struct
     * @param deadEra The deadline era
     * @return The index corresponding to the input deadline era, resetting the `self.nextJump` to this value
     */
    function slot(Info storage self, int256 poolEra, int256 deadEra, function (DeadlineSet.Info storage,Quad) internal dropoff)
        internal
        returns (int8)
    {
        // Input Validation
        if (!(validDeadline(poolEra, deadEra))) revert InvalidDeadline();

        if (!(self.touched)) {
            // If not touched, initialize the data structure with the current pool era and compute the nextJump index for the input deadline era, then return the index.
            self.dropsEra = int32(poolEra);
            self.nextJump = jumpIndex(self, deadEra);
            self.touched = true;
            return self.nextJump;
        }

        // If touched, compute the nextJump index for the input deadline era
        int8 jump = jumpIndex(self, deadEra);

        // It is possible that the jump is not defined, in this case, it is required to do a temporal realignment of the data structure which involves resetting the `self.dropsEra = poolEra` (like in the initialization logic branch above, this is done in the reanchor() function
        if (!isJumpDefined(jump)) {
            reanchor(self, poolEra, dropoff);
            jump = maybeJump(self.dropsEra, deadEra);
        }

        if ((jump < self.nextJump)) self.nextJump = jump;

        return int8(jump);
    }

    /**
     * @dev Assigns a value to a deadline slot
     * @param self The storage struct
     * @param poolEra The current pool era
     * @param value The value to assign
     * @param deadEra The deadline era
     * @param dropoff The function to call when a deadline is reached
     */
    function assign(Info storage self, int256 poolEra, Quad value, int256 deadEra, function (DeadlineSet.Info storage,Quad) internal dropoff)
        internal
    {
        int8 jump = slot(self, poolEra, deadEra, dropoff);
        self.drops[int256(jump).toUint256()] = value;
    }

    /**
     * @dev Assigns a value to a deadline slot
     * @param self The storage struct
     * @param poolEra The current pool era
     * @param value The value to assign
     * @param deadEra The deadline era
     * @param dropoff The function to call when a deadline is reached
     */
    function assign(Info storage self, int256 poolEra, Quad value, OptInt256 deadEra, function (DeadlineSet.Info storage,Quad) internal dropoff)
        internal
    {
        if (deadEra.isDefined()) assign(self, poolEra, value, deadEra.get(), dropoff);
    }

    /**
     * @dev This function is used to adjust the data structure when the timeline has moved past certain deadlines.
     * @dev It shifts valid deadlines to new positions, resets others, and updates the timeline (dropsEra) and nextJump.
     * @param self The storage struct
     * @param poolEra The current pool era
     * @param dropoff The function to call when a deadline is reached
     */
    function reanchor(Info storage self, int256 poolEra, function (DeadlineSet.Info storage,Quad) internal dropoff) internal {
        bool unset = true;

        // Loop over all the indexes between the nextJump and JUMPS
        for (int8 oldIndex = self.nextJump; (oldIndex < JUMPS); oldIndex = (oldIndex + 1)) {
            Quad drop = self.drops[int256(oldIndex).toUint256()];

            // Only non zero drops are processed in this loop
            if ((drop != POSITIVE_ZERO)) {
                // Computes the deadline era for the current index / jump
                int256 deadline = deadEra(self, oldIndex);

                if ((deadline <= poolEra)) {
                    // If this non zero drop is expired, call the dropoff function
                    dropoff(self, drop);
                } else {
                    // If this non zero drop is not expired, compute the new index / jump based on the current poolEra
                    int8 newIndex = maybeJump(poolEra, deadline);

                    if (unset) {
                        // If this is the first non zero drop encountered in this loop, set the nextJump to the new index
                        // All the zero jumps before this non zero jump are skipped
                        self.nextJump = newIndex;
                        unset = false;
                    }

                    // If this index did not change, then there is no need to check the other following indexes / jumps
                    if ((newIndex == oldIndex)) break;

                    // Reassign the drop to the new index
                    // This does not interfere with the assignment of `drop` in the loop since it should always be the case that `newIndex < oldIndex` in this branch of logic
                    self.drops[int256(newIndex).toUint256()] = drop;
                }
                self.drops[int256(oldIndex).toUint256()] = POSITIVE_ZERO;
            }
        }

        // Updates the `dropsEra` to the current `poolEra` as all the jumps have been reset accordingly
        self.dropsEra = int32(poolEra);
        if (unset) self.nextJump = JUMPS;
    }
}

library DropsGroup {
    using DeadlineSet for DeadlineSet.Info;
    using SafeCast for int256;

    error DeadlineNotDefined();

    /**
     * @dev These functions handle the process of updating a drop at specific deadline.
     * @dev This specific overloaded version of the function, directly updates the drop at a specified deadline by adding to the existing drop value.
     * @dev This process utilizes the `slot()` function from the DeadlineSet library to reanchor it in time if necessary and compute the correct index in the drops array and updates it.
     * @dev It calls the dropoff function when a deadline is reached.
     * @param self The storage struct
     * @param poolEra The current pool era
     * @param drop The amount to drop
     * @param deadEra The deadline era
     * @param dropoff The function to call when a deadline is reached
     */
    function expire(
        DeadlineSet.Info storage self,
        int256 poolEra,
        Quad drop,
        int256 deadEra,
        function (DeadlineSet.Info storage,Quad) internal dropoff
    ) internal {
        int256 idx = self.slot(poolEra, deadEra, dropoff);

        self.drops[idx.toUint256()] = self.drops[idx.toUint256()] + drop;
    }

    function expire(
        DeadlineSet.Info storage self,
        int256 poolEra,
        Quad drop,
        OptInt256 deadEra,
        function (DeadlineSet.Info storage,Quad) internal dropoff
    ) internal {
        if (deadEra.isDefined()) expire(self, poolEra, drop, deadEra.get(), dropoff);
    }

    function expire(DeadlineSet.Info storage self, int256 poolEra, Quad drop, int256 deadEra) internal {
        expire(self, poolEra, drop, deadEra, dropOff);
    }

    function expire(DeadlineSet.Info storage self, int256 poolEra, Quad drop, OptInt256 deadEra) internal {
        expire(self, poolEra, drop, deadEra, dropOff);
    }

    /**
     * @dev This function is used to adjust the value of a drop at an old deadline and move or replicate this value to a new deadline.
     * @dev It calls the dropoff function when a deadline is reached.
     * @param self The storage struct
     * @param poolEra The current pool era
     * @param amount The amount to extend
     * @param oldDeadEra The old deadline era
     * @param newDeadEra The new deadline era
     * @param dropoff The function to call when a deadline is reached
     */
    function extend(
        DeadlineSet.Info storage self,
        int256 poolEra,
        Quad amount,
        OptInt256 oldDeadEra,
        OptInt256 newDeadEra,
        function (DeadlineSet.Info storage,Quad) internal dropoff
    ) internal {
        if (!(oldDeadEra.isDefined())) revert DeadlineNotDefined();

        expire(self, poolEra, amount.neg(), oldDeadEra, dropoff);
        expire(self, poolEra, amount, newDeadEra, dropoff);
    }

    function dropOff(DeadlineSet.Info storage self, Quad drop) internal {}

    function extend(DeadlineSet.Info storage self, int256 poolEra, Quad amount, OptInt256 oldDeadEra, OptInt256 newDeadEra) internal {
        extend(self, poolEra, amount, oldDeadEra, newDeadEra, dropOff);
    }

    function reanchor(DeadlineSet.Info storage self, int256 poolEra) internal {
        self.reanchor(poolEra, dropOff);
    }
}

library PiecewiseCurve {
    using DropsGroup for DeadlineSet.Info;
    using DeadlineSet for DeadlineSet.Info;
    using SafeCast for int256;

    function dropOff(DeadlineSet.Info storage self, Quad drop) internal {
        self.latest = self.latest - drop;
    }

    /**
     * @dev This function is used to get the current value of the `latest` tracker.
     * @dev It adjusts the data structure by removing expired deadlines and their values and updating the `latest` accordingly.
     * @param self The storage struct
     * @param poolEra The current pool era
     * @return The current value of the latest deadline
     */
    function now(DeadlineSet.Info storage self, int256 poolEra) internal returns (Quad) {
        if (self.touched) {
            // Loops over the expired jumps, if any, and removes the corresponding amount from the `latest` tracker
            // A jump is expired if the `poolEra`, a measure of the current time, is greater than the deadline era
            while (self.nextJump < JUMPS && (poolEra >= (self.deadEra(self.nextJump)))) {
                self.latest = self.latest - self.drops[(int256(self.nextJump)).toUint256()];
                self.drops[int256(self.nextJump).toUint256()] = POSITIVE_ZERO;
                self.nextJump = self.nextJump + 1;
            }
        }

        return self.latest;
    }

    /**
     * @dev This function is used to initialize or update the state.
     * @dev The update case just increases the tracked amount while the initialize case also defines the temporal dimension by setting the `dropsEra` field.
     * @param self The storage struct
     * @param poolEra The current pool era
     */
    function begin(DeadlineSet.Info storage self, int256 poolEra, Quad amount) internal {
        if (!(self.touched)) {
            // Data structure needs to be re-initialized from a temporal perspective so it is anchored to the current time, represented by `poolEra`, and the Jumps scheduled is initialized as empty
            self.latest = amount;
            self.dropsEra = int32(poolEra);
            self.nextJump = JUMPS;
            self.touched = true;
        } else {
            // Data structure is already initialized so it just needs to be updated with the new amount
            self.latest = (self.latest + amount);
        }
    }

    function expire(DeadlineSet.Info storage self, int256 poolEra, Quad drop, int256 deadEra) internal {
        self.expire(poolEra, drop, deadEra, dropOff);
    }

    function expire(DeadlineSet.Info storage self, int256 poolEra, Quad drop, OptInt256 deadEra) internal {
        self.expire(poolEra, drop, deadEra, dropOff);
    }

    function extend(DeadlineSet.Info storage self, int256 poolEra, Quad amount, OptInt256 oldDeadEra, OptInt256 newDeadEra) internal {
        self.extend(poolEra, amount, oldDeadEra, newDeadEra, dropOff);
    }

    function assign(DeadlineSet.Info storage self, int256 poolEra, Quad value, int256 deadEra) internal {
        self.assign(poolEra, value, deadEra, dropOff);
    }

    function assign(DeadlineSet.Info storage self, int256 poolEra, Quad value, OptInt256 deadEra) internal {
        self.assign(poolEra, value, deadEra, dropOff);
    }

    function reanchor(DeadlineSet.Info storage self, int256 poolEra) internal {
        self.reanchor(poolEra, dropOff);
    }
}

library DeadlineJumps {
    using DeadlineSet for DeadlineSet.Info;
    using PiecewiseCurve for DeadlineSet.Info;

    /**
     * @dev Adds a new value `amount` that expires at `deadEra`
     */
    function create(DeadlineSet.Info storage self, int256 poolEra, Quad amount, OptInt256 deadEra) internal {
        self.begin(poolEra, amount);
        self.expire(poolEra, amount, deadEra);
    }
}

library TailedJumps {
    using PiecewiseCurve for DeadlineSet.Info;

    struct Info {
        DeadlineSet.Info deadlineJumps;
        Quad tail;
    }

    /**
     * @dev If the `deadEra` is defined, tracks the new expiring value `drop` at `deadEra`, otherwise it tracks it at `tail` that has no temporal reference.
     */
    function expire(Info storage self, int256 poolEra, Quad drop, OptInt256 deadEra) internal {
        if (deadEra.isDefined()) self.deadlineJumps.expire(poolEra, drop, deadEra);
        else self.tail = self.tail + drop;
    }

    function create(Info storage self, int256 poolEra, Quad amount, OptInt256 deadEra) internal {
        self.deadlineJumps.begin(poolEra, amount);
        expire(self, poolEra, amount, deadEra);
    }
}

/**
 * @dev Here time is tracked in 2 reference systems: the discretized time represented by the concept of "eras" and the continuous time represented by the concept of "deflator".
 */
library PiecewiseGrowthNew {
    using SafeCast for int256;
    using SafeCast for uint256;
    using PiecewiseCurve for DeadlineSet.Info;
    using DeadlineSet for DeadlineSet.Info;

    struct Info {
        // Reordered to save space
        Quad accrued;
        Quad atDeflator;
        Quad tail;
        int32 atEra;
        DeadlineSet.Info deadlineJumps;
    }

    function accruing(Info storage self) public view returns (bool) {
        return (self.atDeflator != POSITIVE_ZERO);
    }

    /**
     * @dev Tracks the last time the accrual accounting was updated.
     */
    function markAccrual(Info storage self, int256 poolEra, Quad poolDeflator) public {
        self.atEra = int32(poolEra);
        self.atDeflator = poolDeflator;
    }

    function growAccruing(Info storage self, int256 poolEra, Quad poolDeflator) public {
        if (self.deadlineJumps.touched && (((poolDeflator) < self.atDeflator))) {
            // If some time passed since last time the accrual accounting was updated, then there is some new accrual to account
            // NOTE: The deflator decreases over time therefore the `poolDeflator < self.atDeflator` means some time has passed since the last update

            // Loop to clear all the expired jumps the usual way (see above)
            while (self.deadlineJumps.nextJump < JUMPS && self.atEra >= self.deadlineJumps.deadEra(self.deadlineJumps.nextJump)) {
                self.deadlineJumps.latest = self.deadlineJumps.latest - self.deadlineJumps.drops[int256(self.deadlineJumps.nextJump).toUint256()];
                self.deadlineJumps.drops[int256(self.deadlineJumps.nextJump).toUint256()] = POSITIVE_ZERO;
                self.deadlineJumps.nextJump = self.deadlineJumps.nextJump + 1;
            }

            if (poolEra == (self.atEra) || ((self.deadlineJumps.nextJump == JUMPS))) {
                // If some time has passed since the last update but not enough to trigger a new era or if there are no jumps in the future to process just update the accrual accounting (this is done also in the other branch of the logic)

                // The `latest` accrued value is proportional to the DeltaT between the `atDeflator` and the current `poolDeflator`
                self.accrued = (self.accrued + (self.deadlineJumps.latest * (self.atDeflator - poolDeflator)));
            } else {
                int8 t1 = maybeJump(self.deadlineJumps.dropsEra, poolEra);

                int256 lastJump = (t1 < (JUMPS - 1)) ? int8(t1) : (JUMPS - 1);

                if ((poolEra < self.deadlineJumps.deadEra(lastJump.toInt8()))) lastJump = (lastJump - 1);

                int256 pastJump = -1;

                int256 pastEra = 0;

                Quad nextDeflator = self.atDeflator;

                while (self.deadlineJumps.nextJump <= (lastJump)) {
                    // Process the jumps between the last processed jump and the one in `lastJump` (inclusive)
                    Quad drop = self.deadlineJumps.drops[int256(self.deadlineJumps.nextJump).toUint256()];

                    if ((drop != POSITIVE_ZERO)) {
                        if ((pastJump == -1)) {
                            pastJump = int8(self.deadlineJumps.nextJump);
                            pastEra = self.deadlineJumps.deadEra(pastJump.toInt8());
                            nextDeflator = (-eraDate(pastEra)).exp2();
                        } else {
                            self.atDeflator = nextDeflator;
                            while ((pastJump < self.deadlineJumps.nextJump)) {
                                int256 eraStep = 0;

                                if ((pastJump == 0)) eraStep = 0;
                                else if (((pastEra & (1 << (pastJump.toUint256() - 1)).toInt256()) != 0)) eraStep = (pastJump - 1);
                                else eraStep = pastJump;

                                pastEra = (pastEra + (1 << eraStep.toUint256()).toInt256());
                                nextDeflator = (nextDeflator * getDeflatorStep(eraStep.toUint256()));
                                pastJump = (pastJump + 1);
                            }
                        }
                        // Before clearing out the expired jumps, update the accrual accounting with that included
                        self.accrued = (self.accrued + (self.deadlineJumps.latest * (self.atDeflator - nextDeflator)));
                        self.deadlineJumps.latest = (self.deadlineJumps.latest - drop);
                        self.deadlineJumps.drops[int256(self.deadlineJumps.nextJump).toUint256()] = POSITIVE_ZERO;
                    }

                    self.deadlineJumps.nextJump = self.deadlineJumps.nextJump + 1;
                }
                self.accrued = (self.accrued + (self.deadlineJumps.latest * (nextDeflator - poolDeflator)));
            }
        }

        markAccrual(self, poolEra, poolDeflator);
    }

    function grow(Info storage self, int256 poolEra, Quad poolDeflator) public returns (Quad) {
        if (accruing(self)) growAccruing(self, poolEra, poolDeflator);
        return self.accrued;
    }

    function reanchor(Info storage self, int256 poolEra, Quad poolDeflator) public {
        grow(self, poolEra, poolDeflator);
        self.deadlineJumps.reanchor(poolEra);
    }

    /**
     * @dev Adds a new value `amount` that expires at `deadEra` but if `isAccruing` is true, it will also update the accruing accounting.
     */
    function create(Info storage self, int256 poolEra, Quad poolDeflator, Quad amount, OptInt256 deadEra, bool isAccruing) public {
        if (isAccruing) growAccruing(self, poolEra, poolDeflator);
        self.deadlineJumps.begin(poolEra, amount);
        expire(self, poolEra, amount, deadEra);
    }

    function expire(Info storage self, int256 poolEra, Quad drop, OptInt256 deadEra) public {
        if (deadEra.isDefined()) self.deadlineJumps.expire(poolEra, drop, deadEra);
        else self.tail = self.tail + drop;
    }
}
