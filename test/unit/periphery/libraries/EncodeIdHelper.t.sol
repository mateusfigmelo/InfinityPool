// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {EncodeIdHelper} from "src/periphery/libraries/EncodeIdHelper.sol";

contract EncodeIdHelperTest is Test {
    function testEncodeAndDecode(uint8 enumValue, address poolAddress, uint88 lpOrSwapperNumber) public {
        EncodeIdHelper.PositionType enumValue_ = (enumValue % 2 == 0) ? EncodeIdHelper.PositionType.LP : EncodeIdHelper.PositionType.Swapper;
        uint256 encodedId = EncodeIdHelper.encodeId(enumValue_, poolAddress, lpOrSwapperNumber);
        (EncodeIdHelper.PositionType decodedEnumValue, address decodedPoolAddress, uint256 decodedLpOrSwapperNumber) =
            EncodeIdHelper.decodeId(encodedId);
        assertEq(uint8(decodedEnumValue), uint8(enumValue_));
        assertEq(decodedPoolAddress, poolAddress);
        assertEq(decodedLpOrSwapperNumber, lpOrSwapperNumber);
    }
}
