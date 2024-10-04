// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {BoxcarTubFrame} from "src/libraries/internal/BoxcarTubFrame.sol";
import {POSITIVE_ZERO, fromInt256, fromUint256, intoUint256, Quad} from "src/types/ABDKMathQuad/Quad.sol";

contract BoxcarTubFrameTest is Test {
    BoxcarTubFrame.Info info; // the methods require this to be storage

    function setUp() public {
        // reset the coefficients
        for (uint256 i; i < info.coef.length; i++) {
            info.coef[i] = POSITIVE_ZERO;
        }
    }

    function testRangeAddsWithoutScale() public {
        assertTrue(BoxcarTubFrame.apply_(info, 10) == POSITIVE_ZERO);
        assertTrue(BoxcarTubFrame.apply_(info, 11) == POSITIVE_ZERO);
        assertTrue(BoxcarTubFrame.apply_(info, 12) == POSITIVE_ZERO);
        assertTrue(BoxcarTubFrame.apply_(info, 13) == POSITIVE_ZERO);
        assertTrue(BoxcarTubFrame.apply_(info, 14) == POSITIVE_ZERO);

        // add 1 to tubs 11 & 12; it should not affect tubs 10, 13 and 14
        BoxcarTubFrame.addRange(info, 11, 13, fromUint256(uint256(1)));
        assertTrue(BoxcarTubFrame.apply_(info, 10) == POSITIVE_ZERO);
        assertTrue(BoxcarTubFrame.apply_(info, 11) == fromUint256(1));
        assertTrue(BoxcarTubFrame.apply_(info, 12) == fromUint256(1));
        assertTrue(BoxcarTubFrame.apply_(info, 13) == POSITIVE_ZERO);
        assertTrue(BoxcarTubFrame.apply_(info, 14) == POSITIVE_ZERO);

        // add 2 to tubs 12 & 13; it should not affect tubs 10, 11, and 14
        BoxcarTubFrame.addRange(info, 12, 14, fromUint256(uint256(2)));
        assertTrue(BoxcarTubFrame.apply_(info, 10) == POSITIVE_ZERO);
        assertTrue(BoxcarTubFrame.apply_(info, 11) == fromUint256(1));
        assertTrue(BoxcarTubFrame.apply_(info, 12) == fromUint256(3));
        assertTrue(BoxcarTubFrame.apply_(info, 13) == fromUint256(2));
        assertTrue(BoxcarTubFrame.apply_(info, 14) == POSITIVE_ZERO);
    }
}
