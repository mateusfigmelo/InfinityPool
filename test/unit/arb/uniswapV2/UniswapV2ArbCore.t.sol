// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {POSITIVE_ONE, NEGATIVE_ONE, POSITIVE_ZERO, NEGATIVE_ZERO} from "src/types/ABDKMathQuad/Constants.sol";
import {Quad, LibOptQuad, fromInt256, fromUint256} from "src/types/ABDKMathQuad/Quad.sol";
import {max, min} from "src/types/ABDKMathQuad/Math.sol";
import {InfinityPoolsFactory} from "src/InfinityPoolsFactory.sol";
import {InfinityPool} from "src/InfinityPool.sol";
import {InfinityPoolsPeriphery} from "src/periphery/InfinityPoolsPeriphery.sol";
import {Token} from "src/mock/Token.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {TUBS} from "src/Constants.sol";
import {Spot} from "src/libraries/external/Spot.sol";
import {Structs} from "src/libraries/external/Structs.sol";
import {IPermit2, InfinityPoolsPeriphery} from "src/periphery/InfinityPoolsPeriphery.sol";
import {UniswapV2ArbTestHelper} from "test/unit/arb/uniswapV2/UniswapV2ArbTestHelper.sol";
import {fracPrice} from "src/libraries/helpers/PoolHelper.sol";

contract UniswapV2ArbCoreTest is Test {
    InfinityPool infinityPool;
    InfinityPoolsPeriphery periphery;
    UniswapV2ArbTestHelper arb;

    int256 splits = 15;
    Quad startPrice = fromUint256(100);
    Quad quadVar = fromUint256(1);
    Token tokenA = new Token("TokenA", "TOK0", 8);
    Token tokenB = new Token("TokenB", "TOK1", 6);
    Token token0 = address(tokenA) < address(tokenB) ? tokenA : tokenB;
    Token token1 = address(tokenA) < address(tokenB) ? tokenB : tokenA;

    function makeFactoryAndPool() internal returns (InfinityPoolsFactory, InfinityPool) {
        InfinityPoolsFactory factory = new InfinityPoolsFactory();
        factory.createPool(address(token0), address(token1), splits);
        address poolAddress = factory.getPool(address(token0), address(token1), splits);
        assertTrue(poolAddress != address(0));
        InfinityPool pool = InfinityPool(poolAddress);
        pool.setInitialPriceAndVariance(startPrice, quadVar);
        token0.approve(address(pool), 100000 ether);
        token1.approve(address(pool), 100000 ether);

        return (factory, pool);
    }

    function setUp() public {
        //necessary for the timestamp to be greater than 1735740000 as that is the "start time" of the pool
        vm.warp(1735740000 + 2 days);
        token0.mint(address(this), 100000000 ether);
        token1.mint(address(this), 100000000 ether);

        InfinityPoolsFactory factory;
        (factory, infinityPool) = makeFactoryAndPool();

        periphery = new InfinityPoolsPeriphery();
        periphery.initialize(address(factory), address(0), IPermit2(address(0)));
        arb = new UniswapV2ArbTestHelper(address(periphery));
    }

    function test_uniswapV2_token0_to_token1_5percent_spread() public {
        uniswapV2CallTestCore(
            fromInt256(-5) / fromUint256(100), // make uniswapV2Price 5% lower
            0 // tradeToken == token0
        );
    }

    function test_uniswapV2_token0_to_token1_2percent_spread() public {
        uniswapV2CallTestCore(
            fromInt256(-2) / fromUint256(100), // make uniswapV2Price 2% lower
            0 // tradeToken == token0
        );
    }

    function test_uniswapV2_token0_to_token1_1percent_spread() public {
        uniswapV2CallTestCore(
            fromInt256(-1) / fromUint256(100), // make uniswapV2Price 1% lower
            0 // tradeToken == token0
        );
    }

    function test_uniswapV2_token1_to_token0_5percent_spread() public {
        uniswapV2CallTestCore(
            fromUint256(5) / fromUint256(100), // make uniswapV2Price 5% higher
            1 // tradeToken == token1
        );
    }

    function test_uniswapV2_token1_to_token0_2percent_spread() public {
        uniswapV2CallTestCore(
            fromUint256(2) / fromUint256(100), // make uniswapV2Price 2% higher
            1 // tradeToken == token1
        );
    }

    function test_uniswapV2_token1_to_token0_1percent_spread() public {
        uniswapV2CallTestCore(
            fromUint256(1) / fromUint256(100), // make uniswapV2Price 1% higher
            1 // tradeToken == token1
        );
    }

    function getPoolPrice(InfinityPool pool) internal returns (Quad) {
        Structs.PoolPriceInfo memory poolPriceInfo = pool.getPoolPriceInfo();
        return fracPrice(poolPriceInfo.splits, poolPriceInfo.tickBin, poolPriceInfo.binFrac);
    }

    function uniswapV2CallTestCore(Quad uniswapPriceSpread, int256 tradeToken) internal {
        if (tradeToken == 0) {
            require(
                uniswapPriceSpread < NEGATIVE_ZERO && uniswapPriceSpread > NEGATIVE_ONE, "uniswapPriceSpread must be in (-1, 0) for token0->token1"
            );
        } else {
            require(
                uniswapPriceSpread > POSITIVE_ZERO && uniswapPriceSpread < POSITIVE_ONE, "uniswapPriceSpread must be in (0, +1) for token1->token0"
            );
        }
        // for simulating the static call
        (, InfinityPool tmpPool) = makeFactoryAndPool();

        vm.warp(block.timestamp + 1 minutes);
        infinityPool.pour(0, TUBS, fromUint256(1000), "");
        tmpPool.pour(0, TUBS, fromUint256(1000), "");

        Quad poolPrice = getPoolPrice(infinityPool);

        Quad uniswapV2Price = poolPrice * (POSITIVE_ONE + uniswapPriceSpread);

        // make limitPrice 1% lower
        Quad limitPrice = tradeToken == 0
            ? max(poolPrice * fromUint256(99) / fromUint256(100), uniswapV2Price)
            : min(poolPrice * fromUint256(101) / fromUint256(100), uniswapV2Price);

        // We borrow token0 at UniswapV2 and swap it for token1 at InfinityPool
        Spot.SwapParams memory swapParams =
            Spot.SwapParams({push: fromUint256(100000000), token: tradeToken == 0 ? false : true, limitPrice: LibOptQuad.Raw({val: limitPrice})});

        // simulating the static call using a temporary pool with the same setup and liquidity.
        (int256 amount0, int256 amount1) = tmpPool.swap(swapParams, address(this), "");
        if (tradeToken == 0) {
            assertTrue(amount0 > 0);
            assertTrue(amount1 < 0);
            console2.log("amount0 =", uint256(amount0));
            console2.log("amount1 = -", uint256(-amount1));
        } else {
            assertTrue(amount0 < 0);
            assertTrue(amount1 > 0);
            console2.log("amount0 = -", uint256(-amount0));
            console2.log("amount1 = ", uint256(amount1));
        }

        // we are pretending to be a UniswapV2 pool
        arb.setUniswapV2Tokens(address(this), address(token0), address(token1));
        arb.setUniswapPrice(address(token0), address(token1), uniswapV2Price);

        // https://book.getfoundry.sh/reference/forge-std/make-addr-and-key
        (address sender, uint256 senderPrivateKey) = makeAddrAndKey("sender");
        bytes memory data = abi.encode(arb.makeArbContext(splits, limitPrice));

        // simulate the uniswap, we deposit some tokens to arb contract
        if (tradeToken == 0) assert(token0.transfer(address(arb), uint256(amount0)));
        else assert(token1.transfer(address(arb), uint256(amount1)));
        assertTrue(token0.balanceOf(sender) == 0);
        assertTrue(token1.balanceOf(sender) == 0);
        uint256 uniswapBalance0 = token0.balanceOf(address(this));
        uint256 uniswapBalance1 = token1.balanceOf(address(this));
        uint256 ipBalance0 = token0.balanceOf(address(infinityPool));
        uint256 ipBalance1 = token1.balanceOf(address(infinityPool));
        if (tradeToken == 0) {
            assertTrue(token0.balanceOf(address(arb)) == uint256(amount0));
            assertTrue(token1.balanceOf(address(arb)) == 0);
            arb.uniswapV2DirectCall(sender, uint256(amount0), 0, data);
        } else {
            assertTrue(token0.balanceOf(address(arb)) == 0);
            assertTrue(token1.balanceOf(address(arb)) == uint256(amount1));
            arb.uniswapV2DirectCall(sender, 0, uint256(amount1), data);
        }

        // we were given some (amount0) token0, we send some to InfinityPool for some token1.
        // we return some token1 to the uniswap and keep the rest to us (sender).
        assertTrue(token0.balanceOf(address(arb)) == 0);
        assertTrue(token1.balanceOf(address(arb)) == 0);

        if (tradeToken == 0) {
            assertTrue(token0.balanceOf(sender) == 0);
            assertTrue(token1.balanceOf(sender) > 0);
            assertTrue(token0.balanceOf(address(this)) >= uniswapBalance0); // we may return a fraction back to uniswap
            assertTrue(token1.balanceOf(address(this)) > uniswapBalance1);
            assertTrue(token0.balanceOf(address(infinityPool)) > ipBalance0);
            assertTrue(token1.balanceOf(address(infinityPool)) < ipBalance1);
            // conservation of token0: some of uint(amount0) was moved to the pool and some sent back to uniswap
            assertTrue(token0.balanceOf(address(infinityPool)) + token0.balanceOf(address(this)) == ipBalance0 + uniswapBalance0 + uint256(amount0));
            assertTrue(
                token1.balanceOf(address(infinityPool)) + token1.balanceOf(address(this)) + token1.balanceOf(sender) == ipBalance1 + uniswapBalance1
            );
        } else {
            assertTrue(token0.balanceOf(sender) > 0);
            assertTrue(token1.balanceOf(sender) == 0);
            assertTrue(token0.balanceOf(address(this)) > uniswapBalance0);
            assertTrue(token1.balanceOf(address(this)) >= uniswapBalance1);
            assertTrue(token0.balanceOf(address(infinityPool)) < ipBalance0);
            assertTrue(token1.balanceOf(address(infinityPool)) > ipBalance1);
            // conservation of token1: some of uint(amount1) was moved to the pool and some sent back to uniswap
            assertTrue(token1.balanceOf(address(infinityPool)) + token1.balanceOf(address(this)) == ipBalance1 + uniswapBalance1 + uint256(amount1));
            assertTrue(
                token0.balanceOf(address(infinityPool)) + token0.balanceOf(address(this)) + token0.balanceOf(sender) == ipBalance0 + uniswapBalance0
            );
        }
    }
}
