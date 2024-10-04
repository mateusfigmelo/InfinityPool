// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ILogicalTimestampTranslator} from "./ILogicalTimestampTranslator.sol";

contract LogicalTimestampTranslator is ILogicalTimestampTranslator {
    struct TimestampScalingEpoch {
        uint256 startTimeMillis;
        uint256 startLogicalTimeMillis;
        uint256 scalingFactor;
    }

    error ShouldNotBeHere();

    TimestampScalingEpoch[] public epochs;

    constructor() {
        epochs.push(TimestampScalingEpoch(0, 0, 1));
    }

    function setTimestampScalingFactor(uint256 f, uint256 startingTimestampMillis) public {
        uint256 startingLogicalTimeMillis = toLogicalMillis(startingTimestampMillis);
        epochs.push(TimestampScalingEpoch(startingTimestampMillis, startingLogicalTimeMillis, f));
    }

    function getTimestampScalingEpochs() public view returns (TimestampScalingEpoch[] memory) {
        TimestampScalingEpoch[] memory result = new TimestampScalingEpoch[](epochs.length);
        for (uint256 i; i < epochs.length; i++) {
            result[i] = epochs[i];
        }
        return result;
    }

    function toLogicalMillis(uint256 utcTimestampMillis) public view returns (uint256) {
        // we expect epochs.length to be small; so linear search instead of binary search.
        for (uint256 j = epochs.length; j > 0; j--) {
            uint256 i = j - 1;
            if (utcTimestampMillis >= epochs[i].startTimeMillis) {
                uint256 deltaMillis = utcTimestampMillis - epochs[i].startTimeMillis;
                return epochs[i].startLogicalTimeMillis + deltaMillis * epochs[i].scalingFactor;
            }
        }
        revert ShouldNotBeHere();
    }

    function fromLogicalMillis(uint256 utcLogicalTimestampMillis) public view returns (uint256) {
        // we expect epochs.length to be small; so linear search instead of binary search.
        for (uint256 j = epochs.length; j > 0; j--) {
            uint256 i = j - 1;
            if (utcLogicalTimestampMillis >= epochs[i].startLogicalTimeMillis) {
                uint256 deltaLogicalMillis = utcLogicalTimestampMillis - epochs[i].startLogicalTimeMillis;
                return epochs[i].startTimeMillis + deltaLogicalMillis / epochs[i].scalingFactor;
            }
        }
        revert ShouldNotBeHere();
    }
}
