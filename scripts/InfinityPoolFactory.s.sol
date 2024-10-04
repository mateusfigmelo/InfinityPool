// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "src/InfinityPoolsFactory.sol";
import {Quad, fromUint256} from "src/types/ABDKMathQuad/Quad.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {Upgrades} from "lib/openzeppelin-foundry-upgrades/src/Upgrades.sol";
import {IPermit2, InfinityPoolsPeriphery} from "src/periphery/InfinityPoolsPeriphery.sol";
import "forge-std/console.sol";

contract InfinityPoolFactoryScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        InfinityPoolsFactory factory = new InfinityPoolsFactory();
        address weth9 = address(0);
        address permit2 = address(0);

        address infinitypoolsPeripheryProxy = Upgrades.deployUUPSProxy(
            "InfinityPoolsPeriphery.sol", abi.encodeCall(InfinityPoolsPeriphery.initialize, (address(factory), weth9, IPermit2(permit2)))
        );

        vm.stopBroadcast();
    }
}
