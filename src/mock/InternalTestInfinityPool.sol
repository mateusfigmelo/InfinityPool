// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {TestInfinityPool} from "./TestInfinityPool.sol";
import {Quad, POSITIVE_ONE, POSITIVE_ZERO, intoInt256, intoUint256, fromInt256, fromUint256} from "src/types/ABDKMathQuad/Quad.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {NewLoan} from "src/libraries/external/NewLoan.sol";
import {Advance} from "src/libraries/external/Advance.sol";
import {LP} from "src/libraries/external/LP.sol";
import {Test} from "forge-std/Test.sol";

contract InternalTestInfinityPool is TestInfinityPool {
    constructor() TestInfinityPool() {}

    function pourOnly(int256 startTub, int256 stopTub, Quad liquidity) public returns (UserPay.Info memory) {
        advance();
        return LP.pour(pool, startTub, stopTub, liquidity);
    }

    function newLoanOnly(NewLoan.NewLoanParams memory params) public returns (UserPay.Info memory) {
        return NewLoan.newLoan(pool, params);
    }

    function IS_TEST() public {}
}
