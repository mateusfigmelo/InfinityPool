// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {InfinityPool} from "../InfinityPool.sol";
import {Quad} from "src/types/ABDKMathQuad/Quad.sol";
import {BoxcarTubFrame} from "src/libraries/internal/BoxcarTubFrame.sol";
import {JumpyFallback} from "src/libraries/internal/JumpyFallback.sol";
import {fluidAt} from "src/libraries/helpers/PoolHelper.sol";
import {ILogicalTimestampTranslator} from "./ILogicalTimestampTranslator.sol";
import {TestInfinityPoolHelper} from "src/libraries/external/Test/TestInfinityPoolHelper.sol";

contract TestInfinityPool is InfinityPool {
    int256 nextBlockTimestamp;
    uint256 timestampScalingFactor;
    uint256 public poolCreationTimestamp; // N.B. pool.date advances.

    using JumpyFallback for JumpyFallback.Info;

    constructor() InfinityPool() {}

    function initialize(address factory, address token0, address token1, int32 splits) public override {
        poolCreationTimestamp = block.timestamp;
        nextBlockTimestamp = -1;
        timestampScalingFactor = 1;

        super.initialize(factory, token0, token1, splits);
    }

    // TODO: remove this after the backend is updated to uing to/fromLogicalMillis.
    function getBlockTimestampScalingParameters() public view returns (uint256, uint256) {
        return (poolCreationTimestamp, timestampScalingFactor);
    }

    function toLogicalMillis(uint256 utcTimestampMillis) public view returns (uint256) {
        return ILogicalTimestampTranslator(pool.factory).toLogicalMillis(utcTimestampMillis);
    }

    function fromLogicalMillis(uint256 utcLogicalTimestampMillis) public view returns (uint256) {
        return ILogicalTimestampTranslator(pool.factory).fromLogicalMillis(utcLogicalTimestampMillis);
    }

    function currentLogicalSeconds() public view returns (uint256) {
        return blockTimestamp();
    }

    function blockTimestamp() internal view override returns (uint256) {
        if (nextBlockTimestamp > 0) return uint256(nextBlockTimestamp);
        return toLogicalMillis(block.timestamp * 1000) / 1000;
    }

    function setNextBlockTimestamp(int256 _nextBlockTimestamp) public {
        nextBlockTimestamp = _nextBlockTimestamp;
    }

    /*
    function getFluidAtBin(int256 bin) public view returns (Quad) {
        return fluidAt(pool.minted, bin, pool.splits);
    }
    */

    function getUsed(int256 startBin, int256 stopBin) external returns (Quad[] memory used) {
        advance();
        return TestInfinityPoolHelper.getUsed(pool, startBin, stopBin);
    }

    function getMintedAtOffset(int256 offset) public view returns (Quad) {
        return TestInfinityPoolHelper.getMintedAtOffset(pool, offset);
    }

    /*
    function getMintedAtScaleOffset(int256 scale, int256 offset) public view returns (Quad) {
        return BoxcarTubFrame.apply_(pool.minted, scale, offset);
    }
    */

    function getMinted(int256 startTub, int256 stopTub) public view returns (Quad[] memory) {
        return TestInfinityPoolHelper.getMinted(pool, startTub, stopTub);
    }

    /*
    function getMintedRaw() public view returns (Quad[] memory) {
        uint256 count = pool.minted.coef.length;
        Quad[] memory minted = new Quad[](count);
        for (uint256 i; i < count; i++) {
            minted[i] = pool.minted.coef[i];
        }
        return minted;
    }
    */
}
