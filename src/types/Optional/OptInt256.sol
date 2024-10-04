// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

type OptInt256 is int256;

using {isDefined, get} for OptInt256 global;

using {neq as !=} for OptInt256 global;

error OptInt256ValueIsUndefined();

int256 constant OPT_INT256_NONE = type(int256).min;

function isDefined(OptInt256 x) pure returns (bool) {
    return OptInt256.unwrap(x) != OPT_INT256_NONE;
}

function neq(OptInt256 x, OptInt256 y) pure returns (bool) {
    return OptInt256.unwrap(x) != OptInt256.unwrap(y);
}

function get(OptInt256 x) pure returns (int256 result) {
    if (!isDefined(x)) revert OptInt256ValueIsUndefined();
    result = OptInt256.unwrap(x);
}

function wrap(int256 x) pure returns (OptInt256 result) {
    result = OptInt256.wrap(x);
}
