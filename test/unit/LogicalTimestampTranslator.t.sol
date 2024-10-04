// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {logQuad} from "test/unit/utils/QuadDebug.sol";
import {LogicalTimestampTranslator} from "src/mock/LogicalTimestampTranslator.sol";

contract LogicalTimestampTranslatorTest is Test {
    LogicalTimestampTranslator translator;

    function setUp() public {
        translator = new LogicalTimestampTranslator();
    }

    function makeEpoch(uint256 start, uint256 startLogical, uint256 factor)
        internal
        pure
        returns (LogicalTimestampTranslator.TimestampScalingEpoch memory)
    {
        return LogicalTimestampTranslator.TimestampScalingEpoch(start, startLogical, factor);
    }

    function assertEq(LogicalTimestampTranslator.TimestampScalingEpoch memory epoch0, LogicalTimestampTranslator.TimestampScalingEpoch memory epoch1)
        internal
    {
        assertEq(epoch0.startLogicalTimeMillis, epoch1.startLogicalTimeMillis);
        assertEq(epoch0.startTimeMillis, epoch1.startTimeMillis);
        assertEq(epoch0.scalingFactor, epoch1.scalingFactor);
    }

    function test_translator_sans_scaling() public {
        LogicalTimestampTranslator.TimestampScalingEpoch[] memory epochs = translator.getTimestampScalingEpochs();
        assertEq(1, epochs.length);
        assertEq(makeEpoch(0, 0, 1), epochs[0]);
        assertEq(0, translator.toLogicalMillis(0));
        assertEq(1, translator.toLogicalMillis(1));
        assertEq(100, translator.toLogicalMillis(100));
        assertEq(0, translator.fromLogicalMillis(0));
        assertEq(1, translator.fromLogicalMillis(1));
        assertEq(100, translator.fromLogicalMillis(100));
        // independent of the block timestamp
        vm.warp(block.timestamp + 2 seconds);
        assertEq(0, translator.toLogicalMillis(0));
        assertEq(1, translator.toLogicalMillis(1));
        assertEq(100, translator.toLogicalMillis(100));
        assertEq(0, translator.fromLogicalMillis(0));
        assertEq(1, translator.fromLogicalMillis(1));
        assertEq(100, translator.fromLogicalMillis(100));
    }

    function test_translator_with_one_scaling_epoch() public {
        LogicalTimestampTranslator.TimestampScalingEpoch[] memory epochs = translator.getTimestampScalingEpochs();
        assertEq(1, epochs.length);
        assertEq(makeEpoch(0, 0, 1), epochs[0]);
        assertEq(0, translator.toLogicalMillis(0));
        assertEq(1, translator.toLogicalMillis(1));
        assertEq(100, translator.toLogicalMillis(100));
        assertEq(101, translator.toLogicalMillis(101));
        assertEq(200, translator.toLogicalMillis(200));
        assertEq(0, translator.fromLogicalMillis(0));
        assertEq(1, translator.fromLogicalMillis(1));
        assertEq(100, translator.fromLogicalMillis(100));
        assertEq(102, translator.fromLogicalMillis(102));
        assertEq(300, translator.fromLogicalMillis(300));

        translator.setTimestampScalingFactor(2, 100);
        epochs = translator.getTimestampScalingEpochs();
        assertEq(2, epochs.length);
        assertEq(makeEpoch(0, 0, 1), epochs[0]);
        assertEq(makeEpoch(100, 100, 2), epochs[1]);
        assertEq(0, translator.toLogicalMillis(0));
        assertEq(1, translator.toLogicalMillis(1));
        assertEq(100, translator.toLogicalMillis(100));
        assertEq(102, translator.toLogicalMillis(101));
        assertEq(300, translator.toLogicalMillis(200));
        assertEq(0, translator.fromLogicalMillis(0));
        assertEq(1, translator.fromLogicalMillis(1));
        assertEq(100, translator.fromLogicalMillis(100));
        assertEq(101, translator.fromLogicalMillis(102));
        assertEq(200, translator.fromLogicalMillis(300));
    }

    function test_translator_with_two_scaling_epochs() public {
        LogicalTimestampTranslator.TimestampScalingEpoch[] memory epochs = translator.getTimestampScalingEpochs();
        assertEq(1, epochs.length);
        assertEq(makeEpoch(0, 0, 1), epochs[0]);
        assertEq(0, translator.toLogicalMillis(0)); // epoch 0
        assertEq(100, translator.toLogicalMillis(100)); // epoch 0
        assertEq(101, translator.toLogicalMillis(101)); // epoch 1
        assertEq(1000, translator.toLogicalMillis(1000)); // epoch 1
        assertEq(1001, translator.toLogicalMillis(1001)); // epoch 2
        assertEq(2000, translator.toLogicalMillis(2000)); // epoch 2
        assertEq(0, translator.fromLogicalMillis(0)); // epoch 0
        assertEq(100, translator.fromLogicalMillis(100)); // epoch 0
        assertEq(101, translator.fromLogicalMillis(101)); // epoch 1
        assertEq(1000, translator.fromLogicalMillis(1000)); // epoch 1
        assertEq(1001, translator.fromLogicalMillis(1001)); // epoch 2
        assertEq(2000, translator.fromLogicalMillis(2000)); // epoch 2

        translator.setTimestampScalingFactor(2, 100);
        epochs = translator.getTimestampScalingEpochs();
        assertEq(2, epochs.length);
        assertEq(makeEpoch(0, 0, 1), epochs[0]);
        assertEq(makeEpoch(100, 100, 2), epochs[1]);
        assertEq(0, translator.toLogicalMillis(0)); // epoch 0
        assertEq(100, translator.toLogicalMillis(100)); // epoch 0
        assertEq(102, translator.toLogicalMillis(101)); // epoch 1
        assertEq(1900, translator.toLogicalMillis(1000)); // epoch 1
        assertEq(1902, translator.toLogicalMillis(1001)); // epoch 1
        assertEq(3900, translator.toLogicalMillis(2000)); // epoch 1
        assertEq(0, translator.fromLogicalMillis(0)); // epoch 0
        assertEq(100, translator.fromLogicalMillis(100)); // epoch 0
        assertEq(101, translator.fromLogicalMillis(102)); // epoch 1
        assertEq(1000, translator.fromLogicalMillis(1900)); // epoch 1
        assertEq(1001, translator.fromLogicalMillis(1902)); // epoch 1
        assertEq(2000, translator.fromLogicalMillis(3900)); // epoch 1

        translator.setTimestampScalingFactor(3, 1000); // starts at 1900 virtual
        epochs = translator.getTimestampScalingEpochs();
        assertEq(3, epochs.length);
        assertEq(makeEpoch(0, 0, 1), epochs[0]);
        assertEq(makeEpoch(100, 100, 2), epochs[1]);
        assertEq(makeEpoch(1000, 1900, 3), epochs[2]);
        assertEq(0, translator.toLogicalMillis(0)); // epoch 0
        assertEq(100, translator.toLogicalMillis(100)); // epoch 0
        assertEq(102, translator.toLogicalMillis(101)); // epoch 1
        assertEq(1900, translator.toLogicalMillis(1000)); // epoch 1
        assertEq(1903, translator.toLogicalMillis(1001)); // epoch 2
        assertEq(4900, translator.toLogicalMillis(2000)); // epoch 2
        assertEq(0, translator.fromLogicalMillis(0)); // epoch 0
        assertEq(100, translator.fromLogicalMillis(100)); // epoch 0
        assertEq(101, translator.fromLogicalMillis(102)); // epoch 1
        assertEq(1000, translator.fromLogicalMillis(1900)); // epoch 1
        assertEq(1000, translator.fromLogicalMillis(1902)); // epoch 2: (1902-1900)/3 + 1000
        assertEq(1666, translator.fromLogicalMillis(3900)); // epoch 2: (3900-1900)/3 + 1000
    }
}
