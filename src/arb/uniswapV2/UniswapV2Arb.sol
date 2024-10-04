// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "lib/uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {UniswapV2ArbCore} from "./UniswapV2ArbCore.sol";
import {UniswapV2Library} from "src/arb/uniswapV2/libraries/UniswapV2Library.sol";
import {IInfinityPool} from "src/interfaces/IInfinityPool.sol";
import {IInfinityPoolsPeriphery} from "src/periphery/interfaces/IInfinityPoolsPeriphery.sol";
import {Spot} from "src/libraries/external/Spot.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UniswapV2Arb is UniswapV2ArbCore {
    address immutable uniswapV2factoryAddress;

    constructor(address _uniswapV2factoryAddress, address infinityPoolsPeripheryAddress) UniswapV2ArbCore(infinityPoolsPeripheryAddress) {
        uniswapV2factoryAddress = _uniswapV2factoryAddress;
    }

    /**
     *	We borrowed amount0 token0 to swap for token1 at InfinityPool.
     *  We pay back the flash loan using some token1 that would result
     *  in a swap output of amount0 token0.
     */
    function getAmount1ToPutBackToUniV2(address token0, uint256 amount0, address token1) public view override returns (uint256) {
        // x token1 -> amount0 token0; solve for x.
        address[] memory path = new address[](2);
        path[0] = address(token1);
        path[1] = address(token0);
        return UniswapV2Library.getAmountsIn(uniswapV2factoryAddress, amount0, path)[0];
    }

    /**
     *	We borrowed amount1 token1 to swap for token0 at InfinityPool.
     *  We pay back the flash loan using some token0 that would result
     *  in a swap output of amount1 token1.
     */
    function getAmount0ToPutBackToUniV2(address token0, address token1, uint256 amount1) public view override returns (uint256) {
        // y token0 -> amount1 token1; solve for y.
        address[] memory path = new address[](2);
        path[0] = address(token0);
        path[1] = address(token1);
        return UniswapV2Library.getAmountsIn(uniswapV2factoryAddress, amount1, path)[0];
    }

    function getUniswapV2Tokens(address pairAddress) public view override returns (address, address) {
        require(pairAddress != address(this), "WEIRD: getUniswapV2Tokens(this)");
        IUniswapV2Pair pair = IUniswapV2Pair(pairAddress);
        address token0 = pair.token0();
        address token1 = pair.token1();
        // ensure that msg.sender is actually a V2 pair
        require(msg.sender == UniswapV2Library.pairFor(uniswapV2factoryAddress, token0, token1), "wrong sender");
        return (token0, token1);
    }
}
