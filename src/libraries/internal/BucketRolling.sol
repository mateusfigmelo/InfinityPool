// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, POSITIVE_ZERO, POSITIVE_ONE, POSITIVE_EIGHT, fromInt256} from "src/types/ABDKMathQuad/Quad.sol";
import {floor} from "src/types/ABDKMathQuad/Math.sol";
import {floorMod} from "src/libraries/helpers/PoolHelper.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";

library BucketRolling {
    struct Info {
        int32 lastBucket;
        Quad[9] ring;
    }

    function init(BucketRolling.Info storage self, PoolState storage pool, Quad initial) internal {
        Quad date = pool.date;
        Quad bucketInitial = initial / POSITIVE_EIGHT;
        for (uint8 i; i < 9; i++) {
            self.ring[i] = bucketInitial;
        }

        self.lastBucket = int32(floor(date * POSITIVE_EIGHT));
        self.ring[uint256(floorMod(self.lastBucket, 9))] = (bucketInitial * (date * POSITIVE_EIGHT - fromInt256(self.lastBucket)));
    }

    function sum(BucketRolling.Info storage self, PoolState storage pool) internal view returns (Quad) {
        int256 bucket = floor((pool.date * POSITIVE_EIGHT));
        Quad fraction = ((pool.date * POSITIVE_EIGHT) - fromInt256(bucket));
        int256 idx = floorMod((bucket + 1), 9);
        Quad _sum = POSITIVE_ZERO;
        for (int256 i = 0; (i < 9); i = (i + 1)) {
            _sum = (_sum + self.ring[uint256(i)]);
        }
        return (_sum - (self.ring[uint256(idx)] * fraction));
    }

    function add(BucketRolling.Info storage self, PoolState storage pool, Quad value) internal {
        int256 bucket = floor((pool.date * POSITIVE_EIGHT));

        if (((bucket - self.lastBucket) >= 9)) {
            for (int256 idx = 0; (idx < 9); idx = (idx + 1)) {
                self.ring[uint256(idx)] = POSITIVE_ZERO;
            }
        } else {
            for (int256 passed = (self.lastBucket + 1); (passed < bucket); passed = (passed + 1)) {
                int256 idx = floorMod(passed, 9);
                self.ring[uint256(idx)] = POSITIVE_ZERO;
            }
        }
        if ((bucket > self.lastBucket)) {
            int256 idx = floorMod(bucket, 9);

            self.ring[uint256(idx)] = value;
            self.lastBucket = int32(bucket);
        } else {
            int256 idx = floorMod(bucket, 9);
            self.ring[uint256(idx)] = (self.ring[uint256(idx)] + value);
        }
    }
}
