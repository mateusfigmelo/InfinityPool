// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {InfinityPoolsBase} from "test/cantina/InfinityPoolsBase.t.sol";

contract POC is InfinityPoolsBase {
    function setUp() public override {
        //mint yourself tokens using token.mint function
        super.setUp();
    }

    function test_POC() external {}
}
