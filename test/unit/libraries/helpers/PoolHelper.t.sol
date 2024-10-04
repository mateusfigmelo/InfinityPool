// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {floorDiv, floorMod} from "src/libraries/helpers/PoolHelper.sol";

contract PoolHelpersTest is Test {
    function testFloorMod() public {
        assertEq(floorMod(100, 10), 0);
        assertEq(floorMod(121, 11), 0);
        assertEq(floorMod(10, 7), 3);
        assertEq(floorMod(50, 7), 1);
        assertEq(floorMod(-50, 7), 6);
        assertEq(floorMod(50, -7), -6);
        assertEq(floorMod(-50, -7), -1);
    }

    function testFloorDiv() public {
        assertEq(floorDiv(-10, 5), -2);
        assertEq(floorDiv(20, 6), 3);
    }
}
