// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Console} from "test/unit/utils/Debug.sol";
import {TUBS} from "src/Constants.sol";
import {POSITIVE_ZERO, POSITIVE_ONE, fromUint256, Quad, wrap} from "src/types/ABDKMathQuad/Quad.sol";
import {subSplits} from "src/libraries/helpers/PoolHelper.sol";
import {LPTestCore} from "test/unit/libraries/internal/LPTestCore.sol";

contract GetUsedTest is LPTestCore {
    function getUsedTestCore(int256 startBin, int256 span) public {
        Quad[] memory result = pool.getUsed(startBin, startBin + span);
        assertEq(result.length, uint256(span));
    }

    function testGetUsed() public {
        initPool(15, POSITIVE_ONE, POSITIVE_ONE / fromUint256(100));
        (,, int256 splits) = pool.getPoolInfo();
        int256 maxBin = TUBS << uint256(subSplits(splits));
        int256 midBin = maxBin / 2;
        int256[16] memory starts = [
            int256(0),
            1,
            2,
            3,
            100,
            500,
            midBin - 99,
            midBin - 1,
            midBin,
            midBin + 1,
            midBin + 99,
            midBin - 500,
            midBin - 100,
            midBin - 3,
            midBin - 2,
            midBin - 1
        ];
        int256[4] memory spans = [int256(1), 2, 3, 10];
        for (uint256 i; i < starts.length; i++) {
            int256 startBin = starts[i];
            for (uint256 j = 0; j < spans.length; j++) {
                int256 span = spans[j];
                if (startBin + span <= maxBin) {
                    Console.log("startBin = ", startBin);
                    Console.log("span = ", span);
                    getUsedTestCore(startBin, span);
                }
            }
        }
    }
}
