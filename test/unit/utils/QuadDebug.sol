// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad} from "src/types/ABDKMathQuad/Quad.sol";
import {console} from "forge-std/console.sol";

function toHex16(bytes16 data) pure returns (bytes32 result) {
    result = bytes32(data) & 0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000
        | (bytes32(data) & 0x0000000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000) >> 64;
    result = result & 0xFFFFFFFF000000000000000000000000FFFFFFFF000000000000000000000000
        | (result & 0x00000000FFFFFFFF000000000000000000000000FFFFFFFF0000000000000000) >> 32;
    result = result & 0xFFFF000000000000FFFF000000000000FFFF000000000000FFFF000000000000
        | (result & 0x0000FFFF000000000000FFFF000000000000FFFF000000000000FFFF00000000) >> 16;
    result = result & 0xFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
        | (result & 0x00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000) >> 8;
    result = (result & 0xF000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000) >> 4
        | (result & 0x0F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F00) >> 8;
    result = bytes32(
        0x3030303030303030303030303030303030303030303030303030303030303030 + uint256(result)
            + (
                uint256(result) + 0x0606060606060606060606060606060606060606060606060606060606060606 >> 4
                    & 0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
            ) * 7
    );
}

function toHexString(Quad q) pure returns (string memory) {
    return string(abi.encodePacked(toHex16(q.unwrap())));
}

function logFunc(string memory name, Quad x, Quad result) view {
    string memory msg = string.concat(name, "(");
    msg = string.concat(msg, toHexString(x));
    msg = string.concat(msg, ") = ");
    msg = string.concat(msg, toHexString(result));
    console.log(msg);
}

function logQuad(string memory name, Quad x) view {
    string memory msg = string.concat(name, " = ");
    msg = string.concat(msg, toHexString(x));
    console.log(msg);
}
