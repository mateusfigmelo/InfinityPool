// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Console} from "test/unit/utils/Debug.sol";
import {TUBS} from "src/Constants.sol";
import {POSITIVE_ZERO, POSITIVE_ONE, fromUint256, Quad, wrap} from "src/types/ABDKMathQuad/Quad.sol";
import {subSplits} from "src/libraries/helpers/PoolHelper.sol";
import {LPTestCore} from "test/unit/libraries/internal/LPTestCore.sol";
import {Structs} from "src/libraries/external/Structs.sol";

contract GetMintedTest is LPTestCore {
    function getMintedTestCore(int256 startTubOffset, int256 stopTubOffset) public {
        Quad[] memory result = pool.getMinted(startTubOffset, stopTubOffset);
        assertEq(result.length, uint256(stopTubOffset - startTubOffset));
    }

    function testGetMinted() public {
        initPool(15, POSITIVE_ONE, POSITIVE_ONE / fromUint256(100));
        getMintedTestCore(0, TUBS);
    }
}
