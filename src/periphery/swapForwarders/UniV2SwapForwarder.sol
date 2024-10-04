// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IUniswapV2Router02} from "src/periphery/interfaces/external/IUniswapV2Router02.sol";
import {ISwapForwarder} from "src/periphery/interfaces/ISwapForwarder.sol";

contract UniV2SwapForwarder is ISwapForwarder {
    using SafeERC20 for IERC20;

    IUniswapV2Router02 public immutable uniswapV2Router02;

    error InvalidPath();

    function exactOutputSupported() external pure returns (bool) {
        return true;
    }

    constructor(IUniswapV2Router02 _uniswapV2Router02) {
        uniswapV2Router02 = _uniswapV2Router02;
    }

    function swapExactInput(IERC20 tokenIn, address, uint256 tokenAmountIn, IERC20 tokenOut, uint256 minTokenAmountOut, address, bytes calldata data)
        external
        returns (uint256 tokenAmountOut)
    {
        tokenIn.forceApprove(address(uniswapV2Router02), tokenAmountIn);

        address[] memory path;
        //this in case user wants provide a custom path with more than 2 tokens
        if (data.length > 0) {
            path = abi.decode(data, (address[]));
            if (path[0] != address(tokenIn) || path[path.length - 1] != address(tokenOut)) revert InvalidPath();
        } else {
            path = new address[](2);
            path[0] = address(tokenIn);
            path[1] = address(tokenOut);
        }

        // here "to" is msg.sender, so the output token will be sent to the msg.sender.
        // minTokenAmountOut check is done in the router
        uint256[] memory amounts = uniswapV2Router02.swapExactTokensForTokens(tokenAmountIn, minTokenAmountOut, path, msg.sender, block.timestamp);
        tokenAmountOut = amounts[amounts.length - 1];

        tokenIn.forceApprove(address(uniswapV2Router02), 0);
    }

    function swapExactOutput(IERC20 tokenIn, address, uint256 maxTokenAmountIn, IERC20 tokenOut, uint256 tokenAmountOut, address, bytes calldata data)
        external
        returns (uint256 tokenInAmount)
    {
        tokenIn.forceApprove(address(uniswapV2Router02), maxTokenAmountIn);

        address[] memory path;
        //this in case user wants provide a custom path with more than 2 tokens
        if (data.length > 0) {
            path = abi.decode(data, (address[]));
            if (path[0] != address(tokenIn) || path[path.length - 1] != address(tokenOut)) revert InvalidPath();
        } else {
            path = new address[](2);
            path[0] = address(tokenIn);
            path[1] = address(tokenOut);
        }
        // here "to" is msg.sender, so the output token will be sent to the msg.sender.
        // maxTokenAmountIn check is done in the router
        uint256[] memory amounts = uniswapV2Router02.swapTokensForExactTokens(tokenAmountOut, maxTokenAmountIn, path, msg.sender, block.timestamp);

        tokenInAmount = amounts[0];
        uint256 tokenInAmountNotUsed = maxTokenAmountIn - tokenInAmount;
        if (tokenInAmountNotUsed > 0) tokenIn.safeTransfer(msg.sender, tokenInAmountNotUsed);
        tokenIn.forceApprove(address(uniswapV2Router02), 0);
    }
}
