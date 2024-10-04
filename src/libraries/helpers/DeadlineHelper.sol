pragma solidity ^0.8.20;

import {JUMPS, JUMP_NONE} from "src/Constants.sol";

error InvalidJumpIndex();

function jumpBitLength(int256 num) pure returns (int8) {
    int256 lowerBound = 0;

    int256 bitsLeft = num;

    int256 checkBits = (bitsLeft >> 8);

    if ((checkBits != 0)) {
        lowerBound = (lowerBound + 8);
        bitsLeft = checkBits;
    }

    checkBits = (bitsLeft >> 4);
    if ((checkBits != 0)) {
        lowerBound = (lowerBound + 4);
        bitsLeft = checkBits;
    }

    checkBits = (bitsLeft >> 2);
    if ((checkBits != 0)) {
        lowerBound = (lowerBound + 2);
        bitsLeft = (checkBits & 3);
    }

    lowerBound += (bitsLeft < 2) ? bitsLeft : int256(2);
    return lowerBound < JUMPS ? int8(lowerBound) : JUMPS;
}

function maybeJump(int256 fromEra, int256 deadline) pure returns (int8) {
    return jumpBitLength(((deadline - fromEra) - 1));
}

function jumpIndex(int256 fromEra, int256 deadline) pure returns (int8) {
    int8 maybeIndex = maybeJump(fromEra, deadline);

    if ((maybeIndex != JUMPS) && ((maybeIndex <= 1) || ((deadline & ~((-1 << uint256(int256(maybeIndex - 1))))) == 0))) return maybeIndex;
    else return JUMP_NONE;
}

function isJumpDefined(int8 jumpIndex) pure returns (bool) {
    return jumpIndex != JUMP_NONE;
}

function validDeadline(int256 poolEra, int256 deadEra) pure returns (bool) {
    return jumpIndex(poolEra, deadEra) != JUMP_NONE;
}

function deadEra(int256 baseEra, int8 jumpIndex) pure returns (int256) {
    if (jumpIndex < 0 || jumpIndex >= JUMPS) revert InvalidJumpIndex();
    if (jumpIndex == 0) return (baseEra + 1);
    else return (((baseEra >> (uint256(int256(jumpIndex - 1)))) + 2) << uint256(int256(jumpIndex - 1)));
}
