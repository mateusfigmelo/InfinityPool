// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Quad, fromInt256, fromUint256, wrap} from "src/types/ABDKMathQuad/Quad.sol";
import {
    HALF,
    POSITIVE_ONE,
    POSITIVE_TWO,
    NEGATIVE_TWO,
    POSITIVE_THREE,
    POSITIVE_FOUR,
    POSITIVE_EIGHT,
    POSITIVE_NINE,
    POSITIVE_TEN,
    POSITIVE_ONE_OVER_FOUR,
    POSITIVE_EIGHT_OVER_NINE
} from "src/types/ABDKMathQuad/Constants.sol";
import {getDeflatorStep} from "src/libraries/helpers/PoolHelper.sol";
import {LOG1PPC, LAMBDA} from "src/Constants.sol";

contract ConstantsTest is Test {
    function delta(Quad x, Quad y) internal pure returns (Quad) {
        return (x - y).abs();
    }

    function test_quad_constants() public pure {
        assertTrue(POSITIVE_ONE == fromUint256(1));
        assertTrue(POSITIVE_TWO == fromUint256(2));
        assertTrue(NEGATIVE_TWO == fromInt256(-2));
        assertTrue(POSITIVE_THREE == fromUint256(3));
        assertTrue(POSITIVE_FOUR == fromUint256(4));
        assertTrue(POSITIVE_EIGHT == fromUint256(8));
        assertTrue(POSITIVE_NINE == fromUint256(9));
        assertTrue(POSITIVE_TEN == fromUint256(10));
        assertTrue(HALF == fromUint256(1) / fromUint256(2));
        assertTrue(POSITIVE_ONE_OVER_FOUR == fromUint256(1) / fromUint256(4));
        assertTrue(POSITIVE_EIGHT_OVER_NINE == fromUint256(8) / fromUint256(9));
        // TODO:
        // LOG1PBP
        // LOG1PPC
        // LAMBDA = 0.69314718055994530941723212145 (wikipedia)
        Quad denom = fromUint256(100000000000000000000000000000);
        Quad expected = fromUint256(69314718055994530941723212145) / denom;
        assertTrue((LAMBDA - expected).abs() <= fromUint256(1) / denom);
    }

    // precalulated values
    // Step 0:  0.9996616064962437
    // Step 1:  0.9993233275026507
    // Step 2:  0.9986471128909702
    // Step 3:  0.9972960560854701
    // Step 4:  0.9945994234836332
    // Step 5:  0.9892280131939755
    // Step 6:  0.9785720620877001
    // Step 7:  0.9576032806985737
    // Step 8:  0.9170040432046712
    // Step 9:  0.8408964152537145
    // Step 10: 0.7071067811865476
    // Step 11: 0.5
    // Step 12: 0.25

    function test_deflator_steps() public pure {
        Quad denom = fromUint256(10000000000000000);
        Quad epsilon = fromUint256(1) / denom;
        assertTrue(delta(getDeflatorStep(0), fromUint256(9996616064962437) / denom) <= epsilon);
        assertTrue(delta(getDeflatorStep(1), fromUint256(9993233275026507) / denom) <= epsilon);
        assertTrue(delta(getDeflatorStep(2), fromUint256(9986471128909702) / denom) <= epsilon);
        assertTrue(delta(getDeflatorStep(3), fromUint256(9972960560854701) / denom) <= epsilon);
        assertTrue(delta(getDeflatorStep(4), fromUint256(9945994234836332) / denom) <= epsilon);
        assertTrue(delta(getDeflatorStep(5), fromUint256(9892280131939755) / denom) <= epsilon);
        assertTrue(delta(getDeflatorStep(6), fromUint256(9785720620877001) / denom) <= epsilon);
        assertTrue(delta(getDeflatorStep(7), fromUint256(9576032806985737) / denom) <= epsilon);
        assertTrue(delta(getDeflatorStep(8), fromUint256(9170040432046712) / denom) <= epsilon);
        assertTrue(delta(getDeflatorStep(9), fromUint256(8408964152537145) / denom) <= epsilon);
        assertTrue(delta(getDeflatorStep(10), fromUint256(7071067811865476) / denom) <= epsilon);
        assertTrue(delta(getDeflatorStep(11), fromUint256(5000000000000000) / denom) <= epsilon);
        assertTrue(delta(getDeflatorStep(12), fromUint256(2500000000000000) / denom) <= epsilon);
    }
}
