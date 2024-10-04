// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2, stdError} from "forge-std/Test.sol";
import {InfinityPoolsFactory} from "src/InfinityPoolsFactory.sol";
import {Token} from "src/mock/Token.sol";
import {Quad, fromUint256} from "src/types/ABDKMathQuad/Quad.sol";
import {InfinityPool} from "src/InfinityPool.sol";
import {EPOCH} from "src/Constants.sol";

contract InfinityPoolsBase is Test {
    Token token0;
    Token token1;

    InfinityPoolsFactory infinityPoolsFactory;
    InfinityPool infinityPool;

    function setUp() public virtual {
        vm.warp(uint256(EPOCH) + 1 days);

        token0 = new Token("Token0", "TOK0", 18);
        token1 = new Token("Token1", "TOK1", 18);

        InfinityPoolsFactory factory = new InfinityPoolsFactory();
        factory.createPool(address(token0), address(token1), 15);
        address pool = factory.getPool(address(token0), address(token1), 15);
        assertTrue(pool != address(0));

        infinityPool = InfinityPool(pool);

        Quad startPrice = fromUint256(1);
        Quad quadVar = fromUint256(1);
        infinityPool.setInitialPriceAndVariance(startPrice, quadVar);
    }
}
