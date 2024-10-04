// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {int128ShiftRightUnsigned} from "src/libraries/internal/Utils.sol";

contract UtilsTest is Test {
    // 5's bits: (0...0)101

    function test_int128ShiftRightUnsigned_1_positive() public {
        // shifted to (0...0)10
        assertEq(int128ShiftRightUnsigned(5, 1), 2);
    }

    function test_int128ShiftRightUnsigned_2_positive() public {
        // shifted to (0...0)1
        assertEq(int128ShiftRightUnsigned(5, 2), 1);
    }

    function test_int128ShiftRightUnsigned_3_positive() public {
        // shifted to (0...0)
        assertEq(int128ShiftRightUnsigned(5, 3), 0);
    }

    function test_int128ShiftRightUnsigned_4_positive() public {
        // shifted to (0...0)
        assertEq(int128ShiftRightUnsigned(5, 4), 0);
    }

    function test_int128ShiftRightUnsigned_5_large_positive() public {
        assertEq(int128ShiftRightUnsigned(2 ** 127 - 1, 1), 2 ** 126 - 1);
    }

    function test_int128ShiftRightUnsigned_6_large_positive() public {
        assertEq(int128ShiftRightUnsigned(2 ** 126 - 1, 1), 2 ** 125 - 1);
        assertEq(int128ShiftRightUnsigned(2 ** 126, 1), 2 ** 125);
    }

    function test_int128ShiftRightUnsigned_7_large_positive() public {
        assertEq(int128ShiftRightUnsigned(2 ** 64 - 1, 1), 2 ** 63 - 1);
        assertEq(int128ShiftRightUnsigned(2 ** 64, 1), 2 ** 63);
    }

    //    // -5's bits: (1...1)011
    function test_int128ShiftRightUnsigned_1_negative() public {
        // shifted to 0(1...1)01
        int128 expected;
        for (uint256 i; i < 128; i++) {
            if (i == 0 || (i >= 2 && i <= 126)) expected += int128(2) ** i;
        }
        assertEq(int128ShiftRightUnsigned(-5, 1), expected);
    }

    function test_int128ShiftRightUnsigned_2_negative() public {
        // shifted to 00(1...1)0
        int128 expected;
        for (uint256 i; i < 128; i++) {
            if ((i >= 1 && i <= 125)) expected += int128(2) ** i;
        }
        assertEq(int128ShiftRightUnsigned(-5, 2), expected);
    }

    function test_int128ShiftRightUnsigned_3_negative() public {
        // shifted to 000(1...1)
        int128 expected;
        for (uint256 i; i < 128; i++) {
            if ((i >= 0 && i <= 124)) expected += int128(2) ** i;
        }
        assertEq(int128ShiftRightUnsigned(-5, 3), expected);
    }

    function test_int128ShiftRightUnsigned_4_negative() public {
        // shifted to 0000(1...1)
        int128 expected;
        for (uint256 i; i < 128; i++) {
            if ((i >= 0 && i <= 123)) expected += int128(2) ** i;
        }
        assertEq(int128ShiftRightUnsigned(-5, 4), expected);
    }

    function test_int128ShiftRightUnsigned_5_large_negative() public {
        //1(0...0)1 -> 01(0...0)
        assertEq(int128ShiftRightUnsigned(-1 * (2 ** 127 - 1), 1), int128(2) ** 126);
    }

    function test_int128ShiftRightUnsigned_6_large_negative() public {
        // shift to 011(0...0)
        int128 expected;
        for (uint256 i; i < 128; i++) {
            if ((i >= 125 && i <= 126)) expected += int128(2) ** i;
        }
        //11(0....0) -> 011(0...0)
        assertEq(int128ShiftRightUnsigned(-1 * (2 ** 126 - 1), 1), expected);
        //11(0...0)1 -> 011(0...0)
        assertEq(int128ShiftRightUnsigned(-1 * (2 ** 126), 1), expected);
    }

    function test_int128ShiftRightUnsigned_7_large_negative() public {
        //->0(1 x 64)(0 x 63)
        int128 expected;
        for (uint256 i; i < 128; i++) {
            if ((i >= 63 && i <= 126)) expected += int128(2) ** i;
        }

        //(1 x 64)(0 x 64) -> 0(1 x 64)(0 x 63)
        assertEq(int128ShiftRightUnsigned(-1 * ((2 ** 64) - 1), 1), expected);
        //(1 x 64)(0 x 63)1 -> 0(1 x 64)(0 x 63)
        assertEq(int128ShiftRightUnsigned(-1 * (2 ** 64), 1), expected);
    }

    function test_int128ShiftRightUnsigned_128_or_above() public {
        assertEq(int128ShiftRightUnsigned(1, 128), 0);
        assertEq(int128ShiftRightUnsigned(1, 129), 0);
        assertEq(int128ShiftRightUnsigned(1, 130), 0);

        assertEq(int128ShiftRightUnsigned(-1, 128), 0);
        assertEq(int128ShiftRightUnsigned(-1, 129), 0);
        assertEq(int128ShiftRightUnsigned(-1, 130), 0);

        assertEq(int128ShiftRightUnsigned(2 ** 127 - 1, 128), 0);
        assertEq(int128ShiftRightUnsigned(-1 * (2 ** 127), 128), 0);
    }

    function test_shift_0() public {
        assertEq(int128ShiftRightUnsigned(1, 0), 1);
        assertEq(int128ShiftRightUnsigned(2, 0), 2);
        assertEq(int128ShiftRightUnsigned(2 ** 127 - 1, 0), 2 ** 127 - 1);

        assertEq(int128ShiftRightUnsigned(-1, 0), -1);
        assertEq(int128ShiftRightUnsigned(-2, 0), -2);
        assertEq(int128ShiftRightUnsigned(-1 * (2 ** 127 - 1), 0), -1 * (2 ** 127 - 1));
        assertEq(int128ShiftRightUnsigned(-1 * (2 ** 127), 0), -1 * (2 ** 127));
    }

    function test_int128ShiftRightUnsigned_all_shift() public {
        assertEq(int128ShiftRightUnsigned(2 ** 127 - 1, 127), 0);
        for (uint256 i; i < 127; i++) {
            assertEq(int128ShiftRightUnsigned(2 ** 127 - 1, i), int256(2) ** (127 - i) - 1);
        }
    }
}
