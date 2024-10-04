// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Console} from "test/unit/utils/Debug.sol";
import {TUBS} from "src/Constants.sol";
import {POSITIVE_ZERO, POSITIVE_ONE, fromUint256, Quad, wrap} from "src/types/ABDKMathQuad/Quad.sol";
import {subSplits} from "src/libraries/helpers/PoolHelper.sol";
import {LPTestCore} from "test/unit/libraries/internal/LPTestCore.sol";
import {Structs} from "src/libraries/external/Structs.sol";

contract GetLiquidityInfoTest is LPTestCore {
    function getLiquidityInfoTestCore(int256 startTubOffset, int256 stopTubOffset) public {
        Structs.LiquidityInfo memory result = pool.getLiquidityInfo(startTubOffset, stopTubOffset);
        assertEq(result.perTubInfos.length, uint256(stopTubOffset - startTubOffset));
    }

    function testGetLiquidityInfo() public {
        initPool(15, POSITIVE_ONE, POSITIVE_ONE / fromUint256(100));
        getLiquidityInfoTestCore(0, TUBS);
    }
}
