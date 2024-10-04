// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

function int128ShiftRightUnsigned(int128 value, uint256 shift) pure returns (int128) {
    if (shift < 128) return (value >> shift) & int128(int256((1 << (128 - shift)) - 1));
    return 0;
}

function max(int32 a, int32 b) pure returns (int32) {
    return a > b ? a : b;
}
