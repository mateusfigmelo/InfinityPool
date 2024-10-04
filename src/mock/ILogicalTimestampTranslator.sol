// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

interface ILogicalTimestampTranslator {
    function toLogicalMillis(uint256 utcTimestampMillis) external view returns (uint256);
    function fromLogicalMillis(uint256 utcLogicalTimestampMillis) external view returns (uint256);
}
