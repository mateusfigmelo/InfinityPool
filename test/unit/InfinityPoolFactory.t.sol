// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {InfinityPoolsFactory} from "src/InfinityPoolsFactory.sol";
import {Token} from "src/mock/Token.sol";
import {Quad, fromUint256} from "src/types/ABDKMathQuad/Quad.sol";
import {TestInfinityPool} from "src/mock/TestInfinityPool.sol";

contract InfinityPoolFactoryTest is Test {
    Token token0;
    Token token1;

    function setUp() public {
        //necessary for the timestamp to be greater than 1735740000 as that is the "start time" of the pool
        vm.warp(1735740000 + 2 days);
        token0 = new Token("Token0", "TOK0", 18);
        token1 = new Token("Token1", "TOK1", 18);
    }

    function testCreateInfinityPool() public {
        InfinityPoolsFactory factory = new InfinityPoolsFactory();
        factory.createPool(address(token0), address(token1), 15);
        address pool = factory.getPool(address(token0), address(token1), 15);
        assertTrue(pool != address(0));
    }

    function testUpgradeableBeacon() public {
        address mainToken = address(new Token("Token0", "TOK0", 18));
        address[] memory tokens = new address[](5);

        address[] memory pools = new address[](5);

        //create pool for token0 with all the other tokens
        InfinityPoolsFactory factory = new InfinityPoolsFactory();

        for (uint256 i; i < 5; i++) {
            address token = address(new Token("Token", "TOK", 18));
            tokens[i] = address(token);
            pools[i] = factory.createPool(mainToken, token, 15);
        }

        //expect that calling getMintedRaw fails on each pool as it is not implemented
        // for (uint256 i; i < 5; i++) {
        // vm.expectRevert();
        // TestInfinityPool(pools[i]).getMintedRaw();
        // }

        //after upgrading from InfinityPool to TestInfinityPool, calling getMintedRaw should work
        // factory.upgradeTo(address(new TestInfinityPool()));

        // for (uint256 i; i < 5; i++) {
        // TestInfinityPool(pools[i]).getMintedRaw();
        // }
    }

    function testPermissionlessCreation() public {
        InfinityPoolsFactory factory = new InfinityPoolsFactory();

        vm.expectRevert();
        vm.prank(address(1));
        factory.createPool(address(token0), address(token1), 15);

        factory.allowPermissionlessCreation();

        vm.prank(address(1));
        factory.createPool(address(token0), address(token1), 15);

        address pool = factory.getPool(address(token0), address(token1), 15);
        assertTrue(pool != address(0));
    }
}
