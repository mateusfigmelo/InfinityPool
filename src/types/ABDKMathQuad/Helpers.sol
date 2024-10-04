// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ABDKMathQuad} from "../../../lib/abdk-libraries-solidity/ABDKMathQuad.sol";
import {Quad} from "./ValueType.sol";
import {wrap} from "./Casting.sol";

function add(Quad x, Quad y) pure returns (Quad) {
    return wrap(ABDKMathQuad.add(x.unwrap(), y.unwrap()));
}

function sub(Quad x, Quad y) pure returns (Quad) {
    return wrap(ABDKMathQuad.sub(x.unwrap(), y.unwrap()));
}

function mul(Quad x, Quad y) pure returns (Quad) {
    return wrap(ABDKMathQuad.mul(x.unwrap(), y.unwrap()));
}

function div(Quad x, Quad y) pure returns (Quad) {
    return wrap(ABDKMathQuad.div(x.unwrap(), y.unwrap()));
}

function eq(Quad x, Quad y) pure returns (bool) {
    return ABDKMathQuad.eq(x.unwrap(), y.unwrap());
}

function neq(Quad x, Quad y) pure returns (bool) {
    return !eq(x, y);
}

function lt(Quad x, Quad y) pure returns (bool) {
    return ABDKMathQuad.cmp(x.unwrap(), y.unwrap()) < 0;
}

function lte(Quad x, Quad y) pure returns (bool) {
    return ABDKMathQuad.cmp(x.unwrap(), y.unwrap()) <= 0;
}

function gt(Quad x, Quad y) pure returns (bool) {
    return ABDKMathQuad.cmp(x.unwrap(), y.unwrap()) > 0;
}

function gte(Quad x, Quad y) pure returns (bool) {
    return ABDKMathQuad.cmp(x.unwrap(), y.unwrap()) >= 0;
}

function neg(Quad x) pure returns (Quad) {
    return wrap(ABDKMathQuad.neg(x.unwrap()));
}

function abs(Quad x) pure returns (Quad) {
    return wrap(ABDKMathQuad.abs(x.unwrap()));
}

function isNaN(Quad x) pure returns (bool) {
    return ABDKMathQuad.isNaN(x.unwrap());
}

function isInfinity(Quad x) pure returns (bool) {
    return ABDKMathQuad.isInfinity(x.unwrap());
}

function mostSignificantBit(uint256 x) pure returns (uint256) {
    unchecked {
        require(x > 0);

        uint256 result = 0;

        if (x >= 0x100000000000000000000000000000000) {
            x >>= 128;
            result += 128;
        }
        if (x >= 0x10000000000000000) {
            x >>= 64;
            result += 64;
        }
        if (x >= 0x100000000) {
            x >>= 32;
            result += 32;
        }
        if (x >= 0x10000) {
            x >>= 16;
            result += 16;
        }
        if (x >= 0x100) {
            x >>= 8;
            result += 8;
        }
        if (x >= 0x10) {
            x >>= 4;
            result += 4;
        }
        if (x >= 0x4) {
            x >>= 2;
            result += 2;
        }
        if (x >= 0x2) result += 1; // No need to shift x anymore

        return result;
    }
}
