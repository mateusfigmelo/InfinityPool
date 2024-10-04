// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, isZero, intoInt256, fromInt256, fromUint256} from "src/types/ABDKMathQuad/Quad.sol";
import {toHexString} from "./QuadDebug.sol";
import {ABDKMathQuad} from "../../../lib/abdk-libraries-solidity/ABDKMathQuad.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

uint8 constant DEBUG = 1;

import "forge-std/Test.sol";

library Console {
    struct Info {
        uint8 DebugLevel;
    }

    function log(string memory s) internal {
        if (DEBUG == 1) console.log(s);
    }

    function log(string memory s, uint256 x) internal {
        if (DEBUG == 1) console.log(s, x);
    }

    function log(string memory s, int256 x) internal {
        if (DEBUG == 1) {
            if (x >= 0) console.log(s, uint256(x));
            else console.log(s, string.concat("-", Strings.toString(uint256(-x))));
        }
    }

    function log(string memory s, Quad x) internal {
        if (DEBUG == 1) {
            if (ABDKMathQuad.isInfinity(Quad.unwrap(x))) console.log(s, "inf");
            else if (isZero(x)) console.log(s, "0");
            else console.log(s, toHexString(x));
        }
    }

    function log(string memory s, Quad x, int256 decimals) internal {
        if (DEBUG == 1) {
            if (decimals >= 0) Console.log(s, intoInt256(x * fromUint256(10 ** uint256(decimals))));
            else Console.log(s, intoInt256(x / fromUint256(10 ** uint256(-decimals))));
            Console.log("Decimals: ", decimals);
            Console.log("--- ");
        }
    }

    function log(string memory s, bool x) internal {
        if (DEBUG == 1) console.log(s, x ? "true" : "false");
    }
}
