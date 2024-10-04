// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {logQuad} from "test/unit/utils/QuadDebug.sol";
import {TUBS} from "src/Constants.sol";
import {InfinityPoolsFactory} from "src/InfinityPoolsFactory.sol";
import {InfinityPool} from "src/InfinityPool.sol";
import {LP} from "src/libraries/external/LP.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {
    POSITIVE_ZERO,
    NEGATIVE_ZERO,
    POSITIVE_ONE,
    NEGATIVE_ONE,
    fromInt256,
    fromUint256,
    Quad,
    wrap,
    intoInt256,
    intoUint256
} from "src/types/ABDKMathQuad/Quad.sol";
import {POSITIVE_TEN} from "src/types/ABDKMathQuad/Constants.sol";
import {Token} from "src/mock/Token.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {TestInfinityPoolWithPaymentCallback} from "src/mock/TestInfinityPoolWithPaymentCallback.sol";

import {PoolState} from "src/interfaces/IInfinityPoolState.sol";

contract MiniInfinityPool {
    using UserPay for UserPay.Info;

    PoolState pool;

    constructor(Token token0, Token token1) {
        pool.token0 = address(token0);
        pool.token1 = address(token1);
        pool.tenToPowerDecimals0 = fromUint256(10 ** IERC20Metadata(pool.token0).decimals());
        pool.tenToPowerDecimals1 = fromUint256(10 ** IERC20Metadata(pool.token1).decimals());
    }

    function makeUserPay(UserPay.Info memory amounts, address to, bytes calldata data) public returns (int256, int256) {
        return amounts.makeUserPay(pool, to, data);
    }
}

contract UserPayTest is Test {
    MiniInfinityPool pool;

    Token token0;
    Token token1;

    function setUp() public {
        token0 = new Token("Token0", "TOK0", 18);
        token1 = new Token("Token1", "TOK1", 18);

        pool = new MiniInfinityPool(token0, token1);

        token0.mint(address(this), 100 ether);
        token1.mint(address(this), 100 ether);

        token0.mint(address(pool), 100 ether);
        token1.mint(address(pool), 100 ether);
    }

    function testRound() public {
        assertEq(UserPay.round(POSITIVE_ZERO), 0);
        assertEq(UserPay.round(POSITIVE_ONE), 1);
        assertEq(UserPay.round(fromInt256(1) / fromInt256(10)), 1);
        assertEq(UserPay.round(fromInt256(11) / fromInt256(10)), 2);

        assertEq(UserPay.round(NEGATIVE_ZERO), 0);
        assertEq(UserPay.round(NEGATIVE_ONE), -1);
        assertEq(UserPay.round(fromInt256(-1) / fromInt256(10)), 0);
        assertEq(UserPay.round(fromInt256(-11) / fromInt256(10)), -1);
    }

    // positive
    function testMakeUserPayPositiveAmounts() public {
        UserPay.Info memory amounts = UserPay.Info({token0: fromUint256(10), token1: fromUint256(10)});

        uint256 userToken0BalanceBefore = token0.balanceOf(address(this));
        uint256 userToken1BalanceBefore = token1.balanceOf(address(this));

        uint256 poolToken0BalanceBefore = token0.balanceOf(address(pool));
        uint256 poolToken1BalanceBefore = token1.balanceOf(address(pool));

        token0.approve(address(pool), 10 ether);
        token1.approve(address(pool), 10 ether);

        (int256 amount0, int256 amount1) = pool.makeUserPay(amounts, address(this), "");

        assertEq(token0.balanceOf(address(this)), userToken0BalanceBefore - 10 ether);
        assertEq(token1.balanceOf(address(this)), userToken1BalanceBefore - 10 ether);

        assertEq(token0.balanceOf(address(pool)), poolToken0BalanceBefore + 10 ether);
        assertEq(token1.balanceOf(address(pool)), poolToken1BalanceBefore + 10 ether);

        assertEq(amount0, int256(intoUint256(amounts.token0) * (10 ** token0.decimals())));
        assertEq(amount1, int256(intoUint256(amounts.token1) * (10 ** token1.decimals())));
    }

    // negative
    function testMakeUserPayNegativeAmounts() public {
        UserPay.Info memory amounts = UserPay.Info({token0: fromInt256(-10), token1: fromInt256(-10)});

        uint256 userToken0BalanceBefore = token0.balanceOf(address(this));
        uint256 userToken1BalanceBefore = token1.balanceOf(address(this));

        uint256 poolToken0BalanceBefore = token0.balanceOf(address(pool));
        uint256 poolToken1BalanceBefore = token1.balanceOf(address(pool));

        (int256 amount0, int256 amount1) = pool.makeUserPay(amounts, address(this), "");

        assertEq(token0.balanceOf(address(this)), userToken0BalanceBefore + 10 ether);
        assertEq(token1.balanceOf(address(this)), userToken1BalanceBefore + 10 ether);

        assertEq(token0.balanceOf(address(pool)), poolToken0BalanceBefore - 10 ether);
        assertEq(token1.balanceOf(address(pool)), poolToken1BalanceBefore - 10 ether);

        assertEq(amount0, intoInt256(amounts.token0) * int256((10 ** token0.decimals())));
        assertEq(amount1, intoInt256(amounts.token1) * int256((10 ** token1.decimals())));
    }

    //with data
    //positive
    function testMakeUserPayWData() public {
        UserPay.Info memory amounts = UserPay.Info({token0: fromUint256(10), token1: fromUint256(10)});

        uint256 userToken0BalanceBefore = token0.balanceOf(address(this));
        uint256 userToken1BalanceBefore = token1.balanceOf(address(this));

        uint256 poolToken0BalanceBefore = token0.balanceOf(address(pool));
        uint256 poolToken1BalanceBefore = token1.balanceOf(address(pool));

        (int256 amount0, int256 amount1) = pool.makeUserPay(amounts, address(this), abi.encode(false));

        assertEq(token0.balanceOf(address(this)), userToken0BalanceBefore - 10 ether);
        assertEq(token1.balanceOf(address(this)), userToken1BalanceBefore - 10 ether);

        assertEq(token0.balanceOf(address(pool)), poolToken0BalanceBefore + 10 ether);
        assertEq(token1.balanceOf(address(pool)), poolToken1BalanceBefore + 10 ether);

        assertEq(amount0, int256(intoUint256(amounts.token0) * (10 ** token0.decimals())));
        assertEq(amount1, int256(intoUint256(amounts.token1) * (10 ** token1.decimals())));
    }

    function testMakeUserWDataUnderPayShouldRevert() public {
        UserPay.Info memory amounts = UserPay.Info({token0: fromUint256(10), token1: fromUint256(0)});

        //hack for matching only the selector of the error, not the entire custom error with argument
        try pool.makeUserPay(amounts, address(this), abi.encode(true)) {}
        catch (bytes memory reason) {
            //assert selector equality
            bytes4 expectedSelector = UserPay.UserPayToken0Mismatch.selector;
            bytes4 receivedSelector = bytes4(reason);
            assertEq(expectedSelector, receivedSelector);
        }

        amounts = UserPay.Info({token0: fromUint256(0), token1: fromUint256(10)});
        try pool.makeUserPay(amounts, address(this), abi.encode(true)) {}
        catch (bytes memory reason) {
            //assert selector equality
            bytes4 expectedSelector = UserPay.UserPayToken1Mismatch.selector;
            bytes4 receivedSelector = bytes4(reason);
            assertEq(expectedSelector, receivedSelector);
        }
    }

    //the callback
    function infinityPoolPaymentCallback(int256 amount0, int256 amount1, bytes calldata data) external {
        bool underPay = abi.decode(data, (bool));
        if (amount0 > 0) {
            if (underPay) token0.transfer(msg.sender, uint256(amount0 - 1));
            else token0.transfer(msg.sender, uint256(amount0));
        }
        if (amount1 > 0) {
            if (underPay) token1.transfer(msg.sender, uint256(amount1 - 1));
            else token1.transfer(msg.sender, uint256(amount1));
        }
    }
}
