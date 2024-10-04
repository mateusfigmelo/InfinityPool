// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {InfinityPoolsFactory} from "../InfinityPoolsFactory.sol";
import {InfinityPool} from "../InfinityPool.sol";
import {InternalTestInfinityPool} from "./InternalTestInfinityPool.sol";
import {ILogicalTimestampTranslator} from "./ILogicalTimestampTranslator.sol";
import {LogicalTimestampTranslator} from "./LogicalTimestampTranslator.sol";

contract InternalTestInfinityPoolFactory is InfinityPoolsFactory, LogicalTimestampTranslator {
    constructor() InfinityPoolsFactory() LogicalTimestampTranslator() {
        upgradeTo(address(new InternalTestInfinityPool()));
    }

    function setTimestampScalingFactor(uint256 f) public returns (TimestampScalingEpoch[] memory) {
        setTimestampScalingFactor(f, block.timestamp * 1000);
        return getTimestampScalingEpochs();
    }
}
