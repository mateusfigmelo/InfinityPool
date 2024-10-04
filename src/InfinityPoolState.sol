// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, fromUint256, fromInt256} from "./types/ABDKMathQuad/Quad.sol";

import {PoolState} from "src/interfaces/IInfinityPoolState.sol";

contract InfinityPoolState {
    PoolState internal pool;
}
