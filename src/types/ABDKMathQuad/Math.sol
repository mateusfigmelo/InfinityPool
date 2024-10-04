// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ABDKMathQuad} from "../../../lib/abdk-libraries-solidity/ABDKMathQuad.sol";
import {wrap} from "./Helpers.sol";
import {Quad} from "./ValueType.sol";
import {fromUint256, fromInt256, intoUint256, intoInt256} from "./Casting.sol";
import {POSITIVE_ONE, NEGATIVE_ONE, POSITIVE_ZERO, HALF, POSITIVE_TWO, NEGATIVE_ZERO, POSITIVE_INFINITY, NEGATIVE_INFINITY} from "./Constants.sol";

function ceil(Quad x) pure returns (int256 res) {
    res = intoInt256(x);
    if (x > fromInt256(res)) res = res + 1;
}

function sqrt(Quad x) pure returns (Quad) {
    return wrap(ABDKMathQuad.sqrt(x.unwrap()));
}

function exp2(Quad x) pure returns (Quad) {
    return wrap(ABDKMathQuad.pow_2(x.unwrap()));
}

function exp(Quad x) pure returns (Quad) {
    return wrap(ABDKMathQuad.exp(x.unwrap()));
}

function log2(Quad x) pure returns (Quad res) {
    res = wrap(ABDKMathQuad.log_2(x.unwrap()));
}

function log(Quad x) pure returns (Quad res) {
    res = wrap(ABDKMathQuad.ln(x.unwrap()));
}

function abs(Quad x) pure returns (Quad res) {
    res = wrap(ABDKMathQuad.abs(x.unwrap()));
}

function max(Quad x, Quad y) pure returns (Quad res) {
    res = (x >= y) ? x : y;
}

function min(Quad x, Quad y) pure returns (Quad res) {
    res = (x <= y) ? x : y;
}

function pow(Quad b, Quad e) pure returns (Quad res) {
    res = exp(e * log(b));
}

function floor(Quad x) pure returns (int256 res) {
    if (x == POSITIVE_ZERO || x == NEGATIVE_ZERO) {
        res = 0; // the code below gives the wrong answer for -0
    } else {
        res = intoInt256(x);
        if (x < fromInt256(res)) res = res - 1;
    }
}
