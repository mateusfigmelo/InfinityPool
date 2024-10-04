// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {InfinityPoolsFactory} from "../InfinityPoolsFactory.sol";
import {TestInfinityPool} from "./TestInfinityPool.sol";
import {ILogicalTimestampTranslator} from "./ILogicalTimestampTranslator.sol";
import {LogicalTimestampTranslator} from "./LogicalTimestampTranslator.sol";

contract TestInfinityPoolFactory is InfinityPoolsFactory, LogicalTimestampTranslator {
    function _infinityPoolImplementation() internal override returns (address) {
        return address(new TestInfinityPool());
    }

    constructor() InfinityPoolsFactory() LogicalTimestampTranslator() {}

    function setTimestampScalingFactor(uint256 f) public returns (TimestampScalingEpoch[] memory) {
        setTimestampScalingFactor(f, block.timestamp * 1000);
        return getTimestampScalingEpochs();
    }
}
