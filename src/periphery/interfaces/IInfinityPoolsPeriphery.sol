// SPDX-License-Identifier: UNLICENCED
pragma solidity ^0.8.20;

interface IInfinityPoolsPeriphery {
    struct AddLiquidityParams {
        address token0;
        address token1;
        int256 splits;
        int256 startEdge;
        int256 stopEdge;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
    }

    enum PaymentType {
        WALLET,
        COLLATERAL_SWAP
    }

    struct CallbackData {
        address token0;
        address token1;
        int256 splits;
        address caller;
        address payer; // wallet that token is taken from when extraData is empty, or wallet record in Vault that credit from and refund when extraData is NewLoan
        PaymentType paymentType;
        bytes extraData; // currently having extraData simply means it is a newLoan call, refactor while there is more requirement
    }

    error TokenOrderInvalid();
    error NoTokensProvided();
    error PoolDoesNotExist();
    error NoTokensRequired();
    error NoLiquidity();
    error PriceSlippageAmount0();
    error PriceSlippageAmount1();

    /*
     * @param tokenA address of tokenA
     * @param tokenB address of tokenB
     * @param splits the splits
     * @return (poolAddress, token0, token1)
     */

    function getPoolAddress(address tokenA, address tokenB, int256 splits) external view returns (address, address, address);
}
