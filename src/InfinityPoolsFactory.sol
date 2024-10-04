// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IInfinityPoolFactory} from "src/interfaces/IInfinityPoolFactory.sol";
import {InfinityPool} from "./InfinityPool.sol";
import {MIN_SPLITS, MAX_SPLITS} from "./Constants.sol";
import {UpgradeableBeacon, Ownable} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

contract InfinityPoolsFactory is IInfinityPoolFactory, UpgradeableBeacon {
    mapping(address => mapping(address => mapping(int256 => address))) public override getPool;
    bool public permissionlessCreation;

    error PoolAlreadyExists();
    error InvalidTokens();
    error InvalidSplits();

    function _infinityPoolImplementation() internal virtual returns (address) {
        return address(new InfinityPool());
    }

    constructor() UpgradeableBeacon(_infinityPoolImplementation(), msg.sender) {}

    function deployPool(address factory, address token0, address token1, int256 splits) internal returns (address pool) {
        pool = address(new BeaconProxy(address(this), abi.encodeWithSelector(InfinityPool.initialize.selector, factory, token0, token1, splits)));
    }

    function owner() public view override(IInfinityPoolFactory, Ownable) returns (address) {
        return Ownable.owner();
    }

    function allowPermissionlessCreation() external onlyOwner {
        permissionlessCreation = true;
    }

    function createPool(address tokenA, address tokenB, int256 splits) external override returns (address pool) {
        if (!permissionlessCreation) _checkOwner();
        if (tokenA == tokenB) revert InvalidTokens();
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        if (token0 == address(0)) revert InvalidTokens();
        if (splits > int256(MAX_SPLITS) || splits < int256(MIN_SPLITS)) revert InvalidSplits();
        if (getPool[token0][token1][splits] != address(0)) revert PoolAlreadyExists();
        pool = deployPool(address(this), token0, token1, splits);
        getPool[token0][token1][splits] = pool;
        // populate mapping in the reverse direction, deliberate choice to avoid the cost of comparing addresses
        getPool[token1][token0][splits] = pool;
        emit PoolCreated(token0, token1, splits, pool);
    }
}
