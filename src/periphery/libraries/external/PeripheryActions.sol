// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {IInfinityPoolFactory} from "src/interfaces/IInfinityPoolFactory.sol";
import {IInfinityPool} from "src/interfaces/IInfinityPool.sol";
import {lowEdgeTub} from "src/libraries/helpers/PoolHelper.sol";
import {Quad, fromUint256, fromInt256, POSITIVE_ONE, POSITIVE_ZERO} from "src/types/ABDKMathQuad/Quad.sol";
import {min} from "src/types/ABDKMathQuad/Math.sol";
import {EncodeIdHelper} from "src/periphery/libraries/EncodeIdHelper.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {IInfinityPoolsPeriphery} from "src/periphery/interfaces/IInfinityPoolsPeriphery.sol";

//Added this in preparation to solve the contract size issue. Most of the logic will be delegated to this library
library PeripheryActions {
    using SafeCast for int256;

    event LiquidityAdded(address indexed user, address indexed pool, uint256 indexed lpNum, int256 amount0, int256 amount1, int256 earnEra);

    // Custom Errors
    error IdenticalTokens();
    error TokenOrderInvalid();
    error NoTokensProvided();
    error PoolDoesNotExist();
    error NoTokensRequired();
    error NoLiquidity();
    error PriceSlippageAmount0();
    error PriceSlippageAmount1();

    function addLiquidity(address factory, IInfinityPoolsPeriphery.AddLiquidityParams memory params) external returns (uint256 tokenIdToMint) {
        if (params.token0 == params.token1) revert IdenticalTokens();
        if (params.token0 >= params.token1) revert TokenOrderInvalid();
        if (params.amount0Desired == 0 && params.amount1Desired == 0) revert NoTokensProvided();

        address poolAddress = IInfinityPoolFactory(factory).getPool(params.token0, params.token1, params.splits);
        if (poolAddress == address(0)) revert PoolDoesNotExist();

        IInfinityPool infPool = IInfinityPool(poolAddress);

        int256 startTub = lowEdgeTub(params.startEdge);
        int256 stopTub = lowEdgeTub(params.stopEdge);

        Quad liquidity;
        {
            (int256 amount0PerLiq, int256 amount1PerLiq) = infPool.getPourQuantities(startTub, stopTub, POSITIVE_ONE);
            if (amount0PerLiq <= 0 && amount1PerLiq <= 0) revert NoTokensRequired();

            if (amount0PerLiq == 0) {
                liquidity = fromUint256(params.amount1Desired) / fromInt256(amount1PerLiq);
            } else if (amount1PerLiq == 0) {
                liquidity = fromUint256(params.amount0Desired) / fromInt256(amount0PerLiq);
            } else {
                Quad liq0 = fromUint256(params.amount0Desired) / fromInt256(amount0PerLiq);
                Quad liq1 = fromUint256(params.amount1Desired) / fromInt256(amount1PerLiq);
                liquidity = min(liq0, liq1);
            }
        }
        if (liquidity <= POSITIVE_ZERO) revert NoLiquidity();

        uint256 lpNum;
        int256 amount0;
        int256 amount1;
        int256 earnEra;

        {
            IInfinityPoolsPeriphery.CallbackData memory callbackData = IInfinityPoolsPeriphery.CallbackData({
                token0: params.token0,
                token1: params.token1,
                splits: params.splits,
                caller: msg.sender,
                payer: msg.sender, // msg.sender of this function = user = payer,
                paymentType: IInfinityPoolsPeriphery.PaymentType.WALLET,
                extraData: ""
            });

            (lpNum, amount0, amount1, earnEra) = infPool.pour(startTub, stopTub, liquidity, abi.encode(callbackData));
        }

        tokenIdToMint = EncodeIdHelper.encodeId(EncodeIdHelper.PositionType.LP, poolAddress, uint88(lpNum));
        if (amount0.toUint256() < params.amount0Min) revert PriceSlippageAmount0();
        if (amount1.toUint256() < params.amount1Min) revert PriceSlippageAmount1();

        emit LiquidityAdded(msg.sender, poolAddress, lpNum, amount0, amount1, earnEra);
    }
}
