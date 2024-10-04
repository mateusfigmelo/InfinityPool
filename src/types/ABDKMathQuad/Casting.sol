// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad} from "./ValueType.sol";
import {ABDKMathQuad} from "../../../lib/abdk-libraries-solidity/ABDKMathQuad.sol";

function intoInt256(Quad x) pure returns (int256 result) {
    result = ABDKMathQuad.toInt(x.unwrap());
}

function intoUint256(Quad x) pure returns (uint256 result) {
    result = ABDKMathQuad.toUInt(x.unwrap());
}

function fromInt256(int256 x) pure returns (Quad result) {
    result = Quad.wrap(ABDKMathQuad.fromInt(x));
}

function fromUint256(uint256 x) pure returns (Quad result) {
    result = Quad.wrap(ABDKMathQuad.fromUInt(x));
}

function unwrap(Quad x) pure returns (bytes16 result) {
    result = Quad.unwrap(x);
}

function wrap(bytes16 x) pure returns (Quad result) {
    result = Quad.wrap(x);
}
