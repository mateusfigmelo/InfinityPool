// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {logQuad} from "test/unit/utils/QuadDebug.sol";
import {TUBS} from "src/Constants.sol";
import {InternalTestInfinityPoolFactory} from "src/mock/InternalTestInfinityPoolFactory.sol";
import {InternalTestInfinityPool} from "src/mock/InternalTestInfinityPool.sol";
import {LP} from "src/libraries/external/LP.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {POSITIVE_ZERO, POSITIVE_ONE, fromUint256, Quad, wrap} from "src/types/ABDKMathQuad/Quad.sol";
import {POSITIVE_TEN} from "src/types/ABDKMathQuad/Constants.sol";
import {Token} from "src/mock/Token.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";

contract LPTestCore is Test {
    InternalTestInfinityPool pool;
    Token token0;
    Token token1;
    Quad thousand = fromUint256(1000);
    Quad million = thousand * thousand;
    Quad billion = million * thousand;
    Quad tenbillion = billion * POSITIVE_TEN; // 10^10
    Quad lpTestEpsilon = fromUint256(1) / (tenbillion * tenbillion * tenbillion);

    function setUp() public {
        token0 = new Token("Token0", "TOK0", 18);
        token1 = new Token("Token1", "TOK1", 18);
        token0.mint(address(this), 100 ether);
        token1.mint(address(this), 100 ether);
        // vm.warp(1735740000 + 2 days);
        vm.warp(1710421340);
    }

    function initPool(int256 splits, Quad startPrice, Quad quadVar) internal {
        InternalTestInfinityPoolFactory factory = new InternalTestInfinityPoolFactory();
        factory.createPool(address(token0), address(token1), splits);
        address poolAddress = factory.getPool(address(token0), address(token1), splits);
        assertTrue(poolAddress != address(0));
        pool = InternalTestInfinityPool(poolAddress);
        pool.setInitialPriceAndVariance(startPrice, quadVar);
        token0.approve(address(pool), token0.balanceOf(msg.sender));
        token1.approve(address(pool), token1.balanceOf(msg.sender));
    }

    function assertTubDepth(int256 tub, Quad depth) internal {
        if (tub >= 0 && tub < TUBS) assertTrue(pool.getMintedAtOffset(tub) == depth);
    }

    function assertTokenAmount(Quad actual, Quad expected) internal {
        assertTokenAmount(actual, expected, lpTestEpsilon);
    }

    function assertTokenAmount(Quad actual, Quad expected, Quad epsilon) internal {
        logQuad("expecting token amount ", expected);
        logQuad("found token amount ", actual);
        if (expected == POSITIVE_ZERO) {
            console.log("expecting zero");
            assertTrue(actual.abs() < epsilon);
            assertTrue(actual == POSITIVE_ZERO);
        } else {
            Quad dif = (actual - expected).abs();
            logQuad("absolute error = ", dif);
            if (expected.abs() < POSITIVE_ONE) {
                assertTrue(dif < epsilon);
            } else {
                Quad rel = dif / expected;
                logQuad("relative error = ", rel);
                assertTrue(rel < epsilon);
            }
        }
    }

    function testLimitedRangePour(
        Quad price,
        Quad quadVar,
        int256 startingTub,
        int256 stoppingTub,
        Quad liquidity,
        Quad expectedToken0Amount,
        Quad expectedToken1Amount,
        bool checkEverything
    ) internal {
        assertTrue(startingTub < stoppingTub && startingTub >= 0 && stoppingTub <= TUBS);
        initPool(15, price, quadVar);
        if (checkEverything) {
            for (int256 i = startingTub - 1; i <= stoppingTub; i++) {
                assertTubDepth(i, POSITIVE_ZERO);
            }
        }
        UserPay.Info memory result = pool.pourOnly(startingTub, stoppingTub, liquidity);
        if (checkEverything) {
            for (int256 i = startingTub; i < stoppingTub; i++) {
                assertTubDepth(i, liquidity);
            }
        }
        assertTubDepth(startingTub - 1, POSITIVE_ZERO);
        assertTubDepth(stoppingTub, POSITIVE_ZERO);
        console.log("checking token0");
        assertTokenAmount(result.token0, expectedToken0Amount);
        console.log("checking token1");
        assertTokenAmount(result.token1, expectedToken1Amount);
    }

    function testWholeRangePour(Quad price, Quad quadVar, Quad liquidity, Quad expectedToken0Amount, Quad expectedToken1Amount, bool checkEverything)
        internal
    {
        initPool(15, price, quadVar);
        if (checkEverything) {
            for (int256 i = 0; i < TUBS; i++) {
                assertTubDepth(i, POSITIVE_ZERO);
            }
        }
        UserPay.Info memory result = pool.pourOnly(0, TUBS, liquidity);
        if (checkEverything) {
            for (int256 i = 0; i < TUBS; i++) {
                assertTubDepth(i, liquidity);
            }
        }
        assertTokenAmount(result.token0, expectedToken0Amount);
        assertTokenAmount(result.token1, expectedToken1Amount);
    }
}
