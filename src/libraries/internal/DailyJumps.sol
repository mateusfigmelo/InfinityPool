// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, POSITIVE_ZERO} from "src/types/ABDKMathQuad/Quad.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {eraDay} from "src/libraries/helpers/PoolHelper.sol";

library DailyJumps {
    using SafeCast for int256;
    using SafeCast for uint256;

    struct Info {
        Quad[2] jumps;
        Quad latest;
        int32 atDay;
        bool touched;
    }

    error InvalidDay();

    function now(Info storage self, PoolState storage pool) internal returns (Quad) {
        fresh(self, pool);
        return self.latest;
    }

    function begin(Info storage self, PoolState storage pool, Quad amount) internal {
        if (!(self.touched)) {
            self.atDay = int32(eraDay(pool.era));
            self.latest = amount;
            self.touched = true;
        } else {
            self.latest = (self.latest + amount);
        }
    }

    function liftAt(Info storage self, int256 day) internal view returns (Quad) {
        if (((day <= self.atDay) && self.touched)) revert InvalidDay();

        if (self.touched && (self.atDay >= ((day - 2)))) {
            int256 idx = (day & 1);

            return self.jumps[idx.toUint256()];
        } else {
            return POSITIVE_ZERO;
        }
    }

    function fresh(Info storage self, PoolState storage pool) internal {
        if (self.touched) {
            int256 temp = (eraDay(pool.era) - self.atDay);

            if ((temp == 0)) {
                return;
            } else {
                if ((temp == 1)) {
                    int256 idx = (eraDay(pool.era) & 1);

                    self.latest = (self.latest + self.jumps[idx.toUint256()]);
                    self.jumps[idx.toUint256()] = POSITIVE_ZERO;
                } else {
                    self.latest = (self.latest + (self.jumps[0] + self.jumps[1]));
                    self.jumps[0] = POSITIVE_ZERO;
                    self.jumps[1] = POSITIVE_ZERO;
                }
            }
            self.atDay = int32(eraDay(pool.era));
        }
    }

    function defer(Info storage self, PoolState storage pool, Quad amount, int256 day) internal {
        if ((day <= eraDay(pool.era))) revert InvalidDay();

        if (!(self.touched)) {
            self.atDay = int32(eraDay(pool.era));
            int256 idx = (day & 1);

            self.jumps[idx.toUint256()] = amount;
            self.touched = true;
        } else {
            fresh(self, pool);
            int256 idx = (day & 1);

            self.jumps[idx.toUint256()] = (self.jumps[idx.toUint256()] + amount);
        }
    }
}
