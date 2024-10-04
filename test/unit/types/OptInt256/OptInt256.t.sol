// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {OptInt256, OPT_INT256_NONE, wrap} from "src/types/Optional/OptInt256.sol";

contract OptInt256Test is Test {
    function testInequalityOperator() public pure {
        assertTrue(wrap(1) != wrap(2));
        assertTrue(wrap(1) != wrap(OPT_INT256_NONE));
        assertTrue(wrap(OPT_INT256_NONE) != wrap(1));
        assertFalse(wrap(1) != wrap(1));
        assertFalse(wrap(OPT_INT256_NONE) != wrap(OPT_INT256_NONE));
    }
}
