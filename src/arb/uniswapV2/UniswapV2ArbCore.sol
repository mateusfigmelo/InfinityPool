// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {console2} from "forge-std/Test.sol"; // TODO: remove

import {IUniswapV2Callee} from "lib/uniswap/v2-core/contracts/interfaces/IUniswapV2Callee.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {IInfinityPool} from "src/interfaces/IInfinityPool.sol";
import {IInfinityPoolsPeriphery} from "src/periphery/interfaces/IInfinityPoolsPeriphery.sol";
import {Quad, LibOptQuad, fromUint256, fromInt256} from "src/types/ABDKMathQuad/Quad.sol";
import {Spot} from "src/libraries/external/Spot.sol";

// modified from https://github.com/Uniswap/v2-periphery/blob/master/contracts/examples/ExampleFlashSwap.sol
abstract contract UniswapV2ArbCore is IUniswapV2Callee {
    using LibOptQuad for LibOptQuad.Raw;

    IInfinityPoolsPeriphery immutable infinityPoolsPeriphery;
    Quad constant NaN = Quad.wrap(bytes16(0x7fff0000000000000000000000000001));

    constructor(address infinityPoolsPeripheryAddress) {
        infinityPoolsPeriphery = IInfinityPoolsPeriphery(infinityPoolsPeripheryAddress);
    }

    // needs to accept ETH from IP and WETH. ideally this could be enforced, as in the router,
    // but it's not possible because it requires a call to the v1 factory, which takes too much gas
    // receive() external payable {}

    // abstract; to be overridden in unit tests
    function getAmount1ToPutBackToUniV2(address token0, uint256 amount0, address token1) public view virtual returns (uint256);

    // abstract; to be overridden in unit tests
    function getAmount0ToPutBackToUniV2(address token0, address token1, uint256 amount1) public view virtual returns (uint256);

    // abstract; to be overridden in unit tests
    function getUniswapV2Tokens(address pairAddress) public view virtual returns (address, address);

    struct ArbContext {
        int256 splits;
        Quad limitPrice;
    }

    function makeArbContext(int256 splits, Quad limitPrice) public pure returns (ArbContext memory) {
        return ArbContext({splits: splits, limitPrice: limitPrice});
    }

    // gets token0 (token1) via a V2 flash swap, swaps for the token1 (token0) at IP, repays V2, and keeps the rest!
    /**
     * @param sender transaction sender
     * @param amount0 amount of token0 on loan
     * @param amount1 amount of token1 on loan
     * @param data ABI encoded ArbContext: (uint splits, Quad limitPrice)
     */
    function uniswapV2Call(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external override {
        _uniswapV2DirectCall(sender, amount0, amount1, data);
    }

    // for unit tests since we cannot pass calldata directly.
    function uniswapV2DirectCall(address sender, uint256 amount0, uint256 amount1, bytes memory data) external {
        _uniswapV2DirectCall(sender, amount0, amount1, data);
    }

    function _uniswapV2DirectCall(address sender, uint256 amount0, uint256 amount1, bytes memory data) internal {
        require(amount0 == 0 || amount1 == 0, "either amount0 or amount1 must be zero"); // this strategy is unidirectional
        IInfinityPool infinityPool;
        IERC20 tradeToken; // the token we borrowed from UniV2 and swapped at the IP.
        IERC20 targetToken; // the token we put back at uniV2 eventually
        Quad limitPrice;
        {
            // avoids stack too deep errors
            (address token0, address token1) = getUniswapV2Tokens(msg.sender);
            int256 splits;
            (splits, limitPrice) = abi.decode(data, (int256, Quad)); // splits can be a byte
            (address infinityPoolAddress, address _token0,) = infinityPoolsPeriphery.getPoolAddress(token0, token1, int256(splits));
            require(token0 == _token0, "uniswapV2 and InfinityPool have different ordering for token0 and token1");
            infinityPool = IInfinityPool(infinityPoolAddress);
            if (amount0 > 0) {
                // borrowing token0 from uniV2, swapping for token1 at IP;  we need to put
                // some token1 back, enough for borrowing amount0 token0. So we need to find out
                // the amount of token1 we need to put back in uniV2 that can give us amount0 token0.
                tradeToken = IERC20(token0);
                targetToken = IERC20(token1);
            } else {
                // borrowing token1 from uniV2, swapping for token0 at IP; we need to put
                // some token0 back, enough for borrowing amount1 token1. So we need to find out
                // the amount of token0 we need to put back in uniV2 that can give us amount1 token1.
                tradeToken = IERC20(token1);
                targetToken = IERC20(token0);
            }
        }

        // N.B. one of the amounts is zero
        console2.log("callback: self address = ", address(this));
        console2.log("callback: infinityPool = ", address(infinityPool));
        tradeToken.approve(address(infinityPool), amount0 + amount1);
        console2.log("callback: trade token balance = ", tradeToken.balanceOf(address(this)));
        console2.log("callback: trade token allowance at infinityPool = ", tradeToken.allowance(address(this), address(infinityPool)));
        console2.log("callback: target token balance = ", targetToken.balanceOf(address(this)));
        console2.log("callback: target token allowance at infinityPool = ", targetToken.allowance(address(this), address(infinityPool)));
        int256 transferredAmount0;
        int256 transferredAmount1;
        {
            // token: false for token0
            // sameTokenOrder == true: amount0 > 0 => token0 => false, so ! (amount0 > 0) == amount0 == 0
            // sameTokenOrder == false: amount0 > 0 => token0 in uniswapV2 but token1 in IP, so true
            Quad push = fromUint256(amount0 + amount1) / fromUint256(10 ** IERC20Metadata(address(tradeToken)).decimals());
            (transferredAmount0, transferredAmount1) = infinityPool.swap(
                Spot.SwapParams({
                    push: push, // Quad
                    token: amount0 == 0, // amount0 == 0 => token1 is the trade token (used in IP swap), token0 is the target
                    limitPrice: LibOptQuad.Raw(limitPrice)
                }),
                address(this), // recipient
                "" // calldata
            );
            // if (!sameTokenOrder) // swap the two received amounts to be in keeping with the uniswapV2's notion
        }

        if (amount0 > 0) {
            // swapping token0 for token1 at IP
            require(transferredAmount0 > 0, "user did not pay token0 at IP swap");
            require(uint256(transferredAmount0) <= amount0, "user paid excessive token0 at IP swap");
            require(transferredAmount1 < 0, "user did not receive token1 from IP swap");
            uint256 receivedAmount1 = uint256(-transferredAmount1);
            uint256 amount1ToPutBackToUniV2 = getAmount1ToPutBackToUniV2(address(tradeToken), uint256(transferredAmount0), address(targetToken));
            require(receivedAmount1 > amount1ToPutBackToUniV2, "insufficent token1 received from IP");
            assert(targetToken.transfer(msg.sender, amount1ToPutBackToUniV2)); // return token1 to V2 pair
            assert(targetToken.transfer(sender, receivedAmount1 - amount1ToPutBackToUniV2)); // keep the rest! (token1)
            if (amount0 > uint256(transferredAmount0)) assert(tradeToken.transfer(sender, amount0 - uint256(transferredAmount0))); // keep the rest! (token0)
        } else {
            // swapping token1 for token0 at IP
            require(transferredAmount1 > 0, "user did not pay token1 at IP swap");
            require(uint256(transferredAmount1) <= amount1, "user paid excessive token1 at IP swap");
            require(transferredAmount0 < 0, "user did not receive token0 from IP swap");
            uint256 receivedAmount0 = uint256(-transferredAmount0);
            uint256 amount0ToPutBackToUniV2 = getAmount0ToPutBackToUniV2(address(targetToken), address(tradeToken), uint256(transferredAmount1));
            require(receivedAmount0 > amount0ToPutBackToUniV2, "insufficent token0 received from IP");
            assert(targetToken.transfer(msg.sender, amount0ToPutBackToUniV2)); // return token0 to V2 pair
            assert(targetToken.transfer(sender, receivedAmount0 - amount0ToPutBackToUniV2)); // keep the rest! (token0)
            if (amount1 > uint256(transferredAmount1)) assert(tradeToken.transfer(sender, amount1 - uint256(transferredAmount1))); // keep the rest! (token0)
        }
    }
}
