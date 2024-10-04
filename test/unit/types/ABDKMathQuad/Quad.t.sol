// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "src/types/ABDKMathQuad/Quad.sol";

contract QuadTest is Test {
    function setUp() public {}

    function testIsZero() public pure {
        assertTrue(isZero(POSITIVE_ZERO));
        assertTrue(isZero(NEGATIVE_ZERO));
        assertFalse(isZero(POSITIVE_ONE));
        assertFalse(isZero(NEGATIVE_ONE));
    }

    function testIsPositive() public pure {
        assertTrue(isPositive(POSITIVE_ONE));
        assertTrue(isPositive(fromInt256(1) / fromUint256(1000000000000000000000)));
        assertFalse(isPositive(POSITIVE_ZERO));
        assertFalse(isPositive(NEGATIVE_ZERO));
        assertFalse(isPositive(NEGATIVE_ONE));
    }

    function testIsNegative() public pure {
        assertTrue(isNegative(NEGATIVE_ONE));
        assertTrue(isNegative(fromInt256(-1) / fromUint256(1000000000000000000000)));
        assertFalse(isNegative(POSITIVE_ZERO));
        assertFalse(isNegative(NEGATIVE_ZERO));
        assertFalse(isNegative(POSITIVE_ONE));
    }

    function testIsNonnegative() public pure {
        assertFalse(isNonnegative(NEGATIVE_ONE));
        assertFalse(isNonnegative(fromInt256(-1) / fromUint256(1000000000000000000000)));
        assertTrue(isNonnegative(POSITIVE_ZERO));
        assertTrue(isNonnegative(NEGATIVE_ZERO));
        assertTrue(isNonnegative(POSITIVE_ONE));
        assertTrue(isNonnegative(fromInt256(1) / fromUint256(1000000000000000000000)));
    }

    function test_ABDK_ZERO() public pure {
        assertFalse(POSITIVE_ZERO == NEGATIVE_ZERO); // thanks, ABDK
        assertEq(intoInt256(NEGATIVE_ZERO), 0);
        assertEq(intoUint256(NEGATIVE_ZERO), 0);
        assertEq(intoInt256(POSITIVE_ZERO), 0);
        assertEq(intoUint256(POSITIVE_ZERO), 0);
    }
}
