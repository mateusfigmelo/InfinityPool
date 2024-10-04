// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Quad, fromUint256} from "src/types/ABDKMathQuad/Quad.sol";
import {POSITIVE_ONE, fromInt256, fromUint256, intoUint256, Quad, wrap} from "src/types/ABDKMathQuad/Quad.sol";
import {InfinityPoolsFactory} from "src/InfinityPoolsFactory.sol";
import {InfinityPool} from "src/InfinityPool.sol";
import {logQuad} from "test/unit/utils/QuadDebug.sol";
import {InfinityPoolTestCore} from "./InfinityPoolTestCore.sol";

contract BlockTimestampTest is InfinityPoolTestCore {
    function logInt256(string memory msg, int256 x) internal {
        if (x >= 0) console2.log(msg, uint256(x));
        else console2.log(string.concat(msg, "-"), uint256(-x));
    }

    function test_BlockTimestamp_sans_scaling() public {
        uint256 t0 = infinityPool.currentLogicalSeconds();
        vm.warp(block.timestamp + 1 hours);
        assertEq(infinityPool.currentLogicalSeconds() - t0, 1 hours);
    }

    function test_BlockTimestamp_with_scaling() public {
        factory.setTimestampScalingFactor(3600);
        uint256 t0 = infinityPool.currentLogicalSeconds();
        vm.warp(block.timestamp + 2 seconds);
        console2.log("diff = ", infinityPool.currentLogicalSeconds() - t0 - (2 hours));
        assertTrue(fromInt256(int256(infinityPool.currentLogicalSeconds() - t0) - (2 hours)).abs() <= POSITIVE_ONE);
    }
}
