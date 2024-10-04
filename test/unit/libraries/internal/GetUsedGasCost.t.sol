// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Console} from "test/unit/utils/Debug.sol";
import {TUBS} from "src/Constants.sol";
import {POSITIVE_ZERO, POSITIVE_ONE, fromUint256, Quad, wrap} from "src/types/ABDKMathQuad/Quad.sol";
import {subSplits} from "src/libraries/helpers/PoolHelper.sol";
import {LPTestCore} from "test/unit/libraries/internal/LPTestCore.sol";

contract GetUsedGasCostTest is LPTestCore {
    function getUsedTestCore(int256 startBin, int256 span) public {
        Quad[] memory result = pool.getUsed(startBin, startBin + span);
        assertEq(result.length, uint256(span));
    }

    function testFullRangeGetUsed() public {
        initPool(15, POSITIVE_ONE, POSITIVE_ONE / fromUint256(100));
        (,, int256 splits) = pool.getPoolInfo();
        int256 maxBin = TUBS << uint256(subSplits(splits));
        getUsedTestCore(0, maxBin);
    }
}
