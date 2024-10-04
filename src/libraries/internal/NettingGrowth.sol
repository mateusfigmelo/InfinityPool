// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, POSITIVE_ZERO} from "src/types/ABDKMathQuad/Quad.sol";
import {DeadlineJumps, DeadlineSet, PiecewiseCurve, DropsGroup} from "src/libraries/internal/DeadlineJumps.sol";
import {GapStagedFrame} from "src/libraries/internal/GapStagedFrame.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {LN2, JUMPS} from "src/Constants.sol";
import {eraDate} from "src/libraries/helpers/PoolHelper.sol";

library NettingGrowth {
    using PiecewiseCurve for DeadlineSet.Info;
    using DeadlineSet for DeadlineSet.Info;
    using DropsGroup for DeadlineSet.Info;
    using GapStagedFrame for GapStagedFrame.Info;

    struct Info {
        // Reordered to save space
        Quad accrued;
        Quad atDate;
        DeadlineSet.Info superC;
    }

    function now(Info storage self, PoolState storage pool) internal returns (Quad) {
        if (self.superC.touched) {
            while ((self.superC.nextJump < JUMPS) && (pool.era >= (self.superC.deadEra(int8(self.superC.nextJump))))) {
                Quad nextDate = eraDate(self.superC.deadEra(int8(self.superC.nextJump)));

                self.accrued = (self.accrued + (((pool.twapSpread * LN2) * self.superC.latest) * (nextDate - self.atDate)));
                self.atDate = nextDate;
                uint8 idx = uint8(self.superC.nextJump);
                self.superC.latest = (self.superC.latest - self.superC.drops[idx]);
                self.superC.drops[idx] = POSITIVE_ZERO;
                self.superC.nextJump += 1;
            }
            self.accrued = (self.accrued + (((pool.twapSpread * LN2) * self.superC.latest) * (pool.date - self.atDate)));
            self.atDate = pool.date;
        }

        return self.accrued;
    }

    function dropOff(DeadlineSet.Info storage self, Quad drop) internal {
        self.latest = (self.latest - drop);
    }

    function reanchor(Info storage self, PoolState storage pool) internal {
        now(self, pool);
        self.superC.reanchor(pool.era, dropOff);
    }

    function create(Info storage self, PoolState storage pool, Quad amount, int256 deadEra) internal {
        now(self, pool);
        if (!(self.superC.touched)) self.atDate = pool.date;

        self.superC.begin(pool.era, amount);
        self.superC.expire(pool.era, amount, deadEra, dropOff);
    }
}
