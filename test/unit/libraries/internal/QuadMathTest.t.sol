// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {ABDKMathQuad} from "lib/abdk-libraries-solidity/ABDKMathQuad.sol";
import {TUBS} from "src/Constants.sol";
import {InfinityPoolsFactory} from "src/InfinityPoolsFactory.sol";
import {InfinityPool} from "src/InfinityPool.sol";
import {LP} from "src/libraries/external/LP.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {
    POSITIVE_ZERO,
    POSITIVE_ONE,
    fromInt256,
    fromUint256,
    NEGATIVE_ONE,
    NEGATIVE_ZERO,
    NEGATIVE_INFINITY,
    HALF,
    Quad,
    wrap
} from "src/types/ABDKMathQuad/Quad.sol";
import {pow, ceil, floor} from "src/types/ABDKMathQuad/Math.sol";
import {expm1, log1p} from "src/types/ABDKMathQuad/MathExtended.sol";
import {Token} from "src/mock/Token.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {EXP1MQ_THRESHOLD, EXP1MQ_MAXLOG} from "src/types/ABDKMathQuad/Constants.sol";
import {FloatBits, QuadPacker} from "src/libraries/internal/SparseFloat.sol";
import {Console} from "test/unit/utils/Debug.sol";

contract QuadMathTest is Test {
    Quad epsilon = fromUint256(1) / fromUint256(1 << 30); // 1 << 30 ≈ 1e30

    function setUp() public {}

    function assertQuadEqual(Quad actual, Quad expected) internal {
        console.log("expecting:");
        console.logBytes16(expected.unwrap());
        Console.log("expected:", expected);
        console.log("found:");
        console.logBytes16(actual.unwrap());
        Console.log("found:", actual);
        if (expected == POSITIVE_ZERO) {
            console.log("expecting zero");
            assertTrue(actual == POSITIVE_ZERO);
        } else {
            if (expected == NEGATIVE_ZERO) {
                console.log("expecting zero");
                assertTrue(actual == NEGATIVE_ZERO);
            } else {
                Quad rel = (actual - expected).abs() / expected;
                Console.log("relative:", rel, 3);
                console.log("relative:");
                console.logBytes16(rel.unwrap());
                assertTrue(rel < epsilon);
            }
        }
    }

    // return x * 10^decimals
    function fromDecimal(int256 x, int256 decimals) internal pure returns (Quad) {
        // The faster way is to use the binary representation of decimals
        // and possibly a small lookup table. But for tests, slow if fine.
        Quad y = fromInt256(x);
        if (decimals == 0) {
            return y;
        } else if (decimals > 0) {
            Quad ten = fromUint256(10);
            for (int256 i = 0; i < decimals; i++) {
                y = y * ten;
            }
            return y;
        } else {
            Quad ten = fromUint256(10);
            for (int256 i = 0; i < decimals; i++) {
                y = y / ten;
            }
            return y;
        }
    }

    function test1() internal {
        Quad pi = fromDecimal(314159, -5);
        //(result.token1, expectedToken1Amount);
    }

    function testExpm1qNegZero() public {
        Quad x = NEGATIVE_ZERO;
        Quad expected = x;
        Quad actual = log1p(expm1(x));
        assertQuadEqual(actual, expected);
    }

    function testExpm1AndLog1p(int256 _num, int256 _den) public {
        vm.assume(_den > 0);
        Quad num = fromInt256(_num);
        Quad den = fromInt256(_den);
        Quad x = num / den;
        vm.assume((x > NEGATIVE_ONE) && (x <= EXP1MQ_MAXLOG));
        Quad expected = x;
        Quad t1 = log1p(x);
        Quad actual = expm1(t1);
        assertQuadEqual(actual, expected);
    }

    function testLog1pShouldReturnNegInfinityForLessOrEqualToNegOne(uint256 _num, uint256 _den) public {
        _num = bound(_num, 2, uint256(type(int256).max));
        _den = bound(_den, 1, _num - 1);

        Quad num = fromInt256(-int256(_num));
        Quad den = fromUint256(_den);
        Quad x = num / den;
        //making sure that the input is always less than or equal to NEGATIVE_ONE
        assertTrue(x <= NEGATIVE_ONE);
        //testing to make sure log1p returns NEGATIVE_INFINITY
        assertTrue(log1p(x).unwrap() == NEGATIVE_INFINITY.unwrap());
    }

    function testRepack(int128 significand, int128 exponent) public {
        vm.assume((exponent >= -1e4) && (exponent <= 1e4));
        FloatBits.Info memory temp;
        temp.exponent = exponent;
        temp.significand = significand;
        Quad base = fromInt256(2);
        Quad actual = QuadPacker.repack(temp);
        Quad expected = fromInt256(temp.significand) * pow(base, (fromInt256(temp.exponent)));
        assertQuadEqual(actual, expected);
        Console.log("repacked = ", actual);
    }

    function test_ceil_positive_half() public {
        assertTrue(ceil(HALF) == 1);
    }

    function test_ceil_one_and_a_half() public {
        assertTrue(ceil(POSITIVE_ONE + HALF) == 2);
    }

    function test_ceil_one() public {
        assertTrue(ceil(POSITIVE_ONE) == 1);
    }

    function test_ceil_zero() public {
        assertTrue(ceil(POSITIVE_ZERO) == 0);
    }

    function test_ceil_negative_zero() public {
        assertTrue(ceil(NEGATIVE_ZERO) == 0);
    }

    function test_ceil_negative_one() public {
        assertTrue(ceil(NEGATIVE_ONE) == -1);
    }

    function test_ceil_negative_half() public {
        assertTrue(ceil(NEGATIVE_ONE * HALF) == 0);
    }

    function test_ceil_negative_one_and_a_half() public {
        assertTrue(ceil(NEGATIVE_ONE * (POSITIVE_ONE + HALF)) == -1);
    }

    function test_floor_positive_half() public {
        assertTrue(floor(HALF) == 0);
    }

    function test_floor_one_and_a_half() public {
        assertTrue(floor(POSITIVE_ONE + HALF) == 1);
    }

    function test_floor_one() public {
        assertTrue(floor(POSITIVE_ONE) == 1);
    }

    function test_floor_zero() public {
        assertTrue(floor(POSITIVE_ZERO) == 0);
    }

    function test_floor_negative_one() public {
        assertTrue(floor(NEGATIVE_ONE) == -1);
    }

    function test_floor_negative_half() public {
        assertTrue(floor(NEGATIVE_ONE * HALF) == -1);
    }

    function test_floor_negative_one_and_a_half() public {
        assertTrue(floor(NEGATIVE_ONE * (POSITIVE_ONE + HALF)) == -2);
    }
}
