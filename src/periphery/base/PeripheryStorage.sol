// SPDX-License-Identifier: UNLICENCED
pragma solidity ^0.8.20;

import {IPermit2} from "src/periphery/interfaces/external/IPermit2.sol";

contract PeripheryStorage {
    address public factory;
    address public WETH9;
    mapping(address swapForwarderAddress => bool) public swapForwarders;

    IPermit2 public permit2;
    //mapping of user address to token to amount
    mapping(address user => mapping(address token => uint256)) public deposits;

    //mapping of user address to token to an address with an amount for approvals
    mapping(address user => mapping(address token => mapping(address spender => uint256))) public allowance;

    //mapping of user address to token0 to token1 to an bool(false = Z = token0) represent the amount of collaterals
    mapping(address user => mapping(address token0 => mapping(address token1 => mapping(bool token => int256)))) public collaterals;
}
