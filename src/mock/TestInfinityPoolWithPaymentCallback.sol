// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IInfinityPoolFactory} from "src/interfaces/IInfinityPoolFactory.sol";
import {NewLoan} from "src/libraries/external/NewLoan.sol";
import {InfinityPool} from "../InfinityPool.sol";
import {IInfinityPoolPaymentCallback} from "src/interfaces/IInfinityPoolPaymentCallback.sol";
import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

//Testing only
contract TestInfinityPoolWithPaymentCallback is IInfinityPoolPaymentCallback {
    struct CallbackData {
        address token0;
        address token1;
        address from;
        address to;
    }

    function newLoan(address poolAddress, NewLoan.NewLoanParams calldata params) public returns (int256, int256) {
        InfinityPool infPool = InfinityPool(poolAddress);
        (address token0, address token1,) = infPool.getPoolInfo();
        CallbackData memory callbackData = CallbackData({token0: token0, token1: token1, from: msg.sender, to: poolAddress});
        (uint256 swapperNum, int256 amount0, int256 amount1) = infPool.newLoan(params, abi.encode(callbackData));
        return (amount0, amount1);
    }

    function infinityPoolPaymentCallback(int256 amount0, int256 amount1, bytes calldata _data) external {
        //callack being called from pool
        CallbackData memory data = abi.decode(_data, (CallbackData));

        if (amount0 < 0) SafeERC20.safeTransferFrom(IERC20(data.token0), data.to, data.from, uint256(-amount0));
        else SafeERC20.safeTransferFrom(IERC20(data.token0), data.from, data.to, uint256(amount0));

        if (amount1 < 0) SafeERC20.safeTransferFrom(IERC20(data.token1), data.to, data.from, uint256(-amount1));
        else SafeERC20.safeTransferFrom(IERC20(data.token1), data.from, data.to, uint256(amount1));
    }
}
