// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Quad, fromUint256} from "src/types/ABDKMathQuad/Quad.sol";
import {POSITIVE_ZERO, HALF, POSITIVE_INFINITY, fromInt256, fromUint256, intoUint256, Quad, wrap} from "src/types/ABDKMathQuad/Quad.sol";
import {InfinityPoolsFactory} from "src/InfinityPoolsFactory.sol";
import {InfinityPool} from "src/InfinityPool.sol";
import {Token} from "src/mock/Token.sol";
import {TUBS} from "src/Constants.sol";
import {OPT_INT256_NONE, OptInt256} from "src/types/Optional/OptInt256.sol";
import {NewLoan} from "src/libraries/external/NewLoan.sol";
import {logQuad} from "test/unit/utils/QuadDebug.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {TestInfinityPool} from "src/mock/TestInfinityPool.sol";
import {TestInfinityPoolFactory} from "src/mock/TestInfinityPoolFactory.sol";
import {TestInfinityPoolWithPaymentCallback} from "src/mock/TestInfinityPoolWithPaymentCallback.sol";
import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract InfinityPoolTestCore is Test {
    TestInfinityPool infinityPool;
    TestInfinityPoolFactory factory;
    Token token0;
    Token token1;
    // necessary for the timestamp to be greater than 1735740000 as that is the "start time" of the pool
    uint256 baseTimestamp = 1735740000 + 2 days;

    function setUp() public {
        initializeEverything();
    }

    function initializeEverything() public {
        vm.warp(baseTimestamp);
        token0 = new Token("Token0", "TOK0", 18);
        token1 = new Token("Token1", "TOK1", 18);

        token0.mint(address(this), 100 ether);
        token1.mint(address(this), 100 ether);

        factory = new TestInfinityPoolFactory();
        factory.createPool(address(token0), address(token1), 15);
        address pool = factory.getPool(address(token0), address(token1), 15);
        assertTrue(pool != address(0));

        infinityPool = TestInfinityPool(pool);

        token0.mint(address(infinityPool), 100 ether);
        token1.mint(address(infinityPool), 100 ether);

        Quad startPrice = fromUint256(1);
        Quad quadVar = fromUint256(1) / fromUint256(100);
        infinityPool.setInitialPriceAndVariance(startPrice, quadVar);
        // logQuad("infinityPool.date", infinityPool.date());

        token0.approve(address(infinityPool), 1000 ether);
        token1.approve(address(infinityPool), 1000 ether);
    }

    function advanceTo(uint256 timestampDeltaSinceStart) internal {
        vm.warp(baseTimestamp + timestampDeltaSinceStart);
        infinityPool.advance();
    }
}
