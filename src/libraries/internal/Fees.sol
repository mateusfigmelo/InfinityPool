// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad} from "src/types/ABDKMathQuad/Quad.sol";
import {floor} from "src/types/ABDKMathQuad/Math.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";

library Fees {
    function translateFees(Quad f0, Quad f1, PoolState storage pool) internal view returns (int256, int256) {
        Quad amount0 = f0 * pool.tenToPowerDecimals0; // in wei
        Quad amount1 = f1 * pool.tenToPowerDecimals1; // in wei
        return (floor(amount0), floor(amount1));
    }
}
