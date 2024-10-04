// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IInfinityPoolFactory} from "src/interfaces/IInfinityPoolFactory.sol";

/// @notice Provides validation for callbacks from InfinityPool
library CallbackValidation {
    /// @notice Returns the address of a valid InfinityPool
    /// @param factory The contract address of the InfinityPoolsFactory
    /// @param tokenA The contract address of either token0 or token1
    /// @param tokenB The contract address of the other token
    /// @param splits The pool's split setting
    function verifyCallback(address factory, address tokenA, address tokenB, int256 splits) internal view {
        address poolAddress = IInfinityPoolFactory(factory).getPool(tokenA, tokenB, splits);
        require(msg.sender == poolAddress);
    }
}
