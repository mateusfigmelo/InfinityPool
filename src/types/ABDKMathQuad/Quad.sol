// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./ValueType.sol";
import "./Constants.sol";
import "./Casting.sol";

function isZero(Quad x) pure returns (bool) {
    return x == POSITIVE_ZERO || x == NEGATIVE_ZERO;
}

function isPositive(Quad x) pure returns (bool) {
    return x > POSITIVE_ZERO;
}

function isNonnegative(Quad x) pure returns (bool) {
    return x >= NEGATIVE_ZERO;
}

function isNegative(Quad x) pure returns (bool) {
    return x < NEGATIVE_ZERO;
}
