// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad} from "src/types/ABDKMathQuad/ValueType.sol";
import {POSITIVE_ZERO, NEGATIVE_INFINITY, POSITIVE_INFINITY} from "src/types/ABDKMathQuad/Constants.sol";
import {mostSignificantBit} from "src/types/ABDKMathQuad/Helpers.sol";
import {WORD_SIZE} from "src/Constants.sol";
import {floorDiv, floorMod} from "../helpers/PoolHelper.sol";
import {int128ShiftRightUnsigned} from "src/libraries/internal/Utils.sol";

library FloatBits {
    error TruncateOverflow();

    struct Info {
        int128 exponent;
        int128 significand;
    }

    function add(Info memory self, Quad other) internal pure returns (Info memory result) {
        result.exponent = self.exponent;
        unchecked {
            result.significand = self.significand + truncate(other, self.exponent);
        }
    }

    function truncate(Quad quad, int128 newExponent) internal pure returns (int128 resultSignificand) {
        FloatBits.Info memory bits = QuadPacker.unpack(quad);
        int128 shift = bits.exponent - newExponent;
        if (shift <= 0) {
            if (-shift < WORD_SIZE) resultSignificand = int128ShiftRightUnsigned(bits.significand, uint128(-shift));
            else resultSignificand = 0;
        } else {
            //the shift cannot be greater than 256 or this(uint256(256-shift)) fails silently with underflow
            if (!(int128ShiftRightUnsigned(bits.significand, ((WORD_SIZE - shift) > 0 ? uint128(WORD_SIZE - shift) : 0)) == 0)) {
                revert TruncateOverflow();
            }
            resultSignificand = bits.significand << uint128(shift);
        }
    }

    function _apply(int128 exponent, int128 significand) internal pure returns (Info memory result) {
        return Info(exponent, significand);
    }
}

library QuadPacker {
    error UnpackInvalidFloat();

    function unpack(Quad quad) internal pure returns (FloatBits.Info memory) {
        if (quad < POSITIVE_ZERO || quad == POSITIVE_INFINITY || quad == NEGATIVE_INFINITY) revert UnpackInvalidFloat();
        int128 float = int128(uint128(quad.unwrap()));

        int128 exponent = int128ShiftRightUnsigned(float, 112);

        if (exponent == 0) {
            int128 val = type(int128).max;
            int128 temp = int128ShiftRightUnsigned(val, 15);
            return FloatBits.Info(-16382 - 112, int128((float & temp)));
        } else {
            int128 t2 = float << 15 | type(int128).min;
            int128 significand = int128ShiftRightUnsigned(t2, 15);

            return FloatBits.Info(exponent - 16383 - 112, significand);
        }
    }

    function repack(FloatBits.Info memory bits) internal pure returns (Quad quad) {
        if (bits.significand == 0) return POSITIVE_ZERO;

        int128 intHighestBit = int128(int256(mostSignificantBit(uint256(uint128(bits.significand)))));
        int128 realTopBit = bits.exponent + intHighestBit;
        if (realTopBit <= -16383) {
            return POSITIVE_ZERO;
        } else if (realTopBit > 16383) {
            return POSITIVE_INFINITY;
        } else {
            uint128 bitmask = uint128(~(1 << uint128(intHighestBit)));
            uint128 significand = uint128(bits.significand) & bitmask;
            uint128 t1 = significand << uint128(128 - intHighestBit);
            int128 t2 = int128(t1 >> 16);
            return Quad.wrap(bytes16(uint128((realTopBit + 16383))) << 112 | bytes16(uint128(t2)));
        }
    }
}

library SparseFloat {
    struct Info {
        mapping(int128 => int128) blocks;
    }

    function add(Info storage self, Quad summand) internal {
        FloatBits.Info memory bits = QuadPacker.unpack(summand);
        int128 lowBlock = int128(floorDiv(bits.exponent, WORD_SIZE));
        int128 shift = int128(floorMod(bits.exponent, WORD_SIZE));

        int128 shift1 = WORD_SIZE - shift;
        int128 base1 = bits.significand;
        int128 t1 = int128ShiftRightUnsigned(base1, uint128(shift1));
        int128 highPart = shift == 0 ? int128(0) : t1;
        //if shift is negative then below casting would be dangerous
        int128 lowPart = bits.significand << uint128((shift));

        bool carry;
        {
            int128 oldLow = self.blocks[lowBlock];
            int128 newLow;
            unchecked {
                newLow = oldLow + lowPart;
            }
            self.blocks[lowBlock] = newLow;

            carry = oldLow < 0 == lowPart < 0 ? oldLow < 0 : !(newLow < 0);
        }

        int128 blockNum = lowBlock + 1;
        int128 oldHigh = self.blocks[blockNum];
        int128 newHigh;
        unchecked {
            newHigh = oldHigh + highPart + (carry ? int128(1) : int128(0));
        }
        self.blocks[blockNum] = newHigh;
        carry = oldHigh < 0 == highPart < 0 ? oldHigh < 0 : !(newHigh < 0);

        while (carry) {
            blockNum += 1;
            int128 newBlock;
            unchecked {
                newBlock = self.blocks[blockNum] + 1;
            }
            carry = newBlock == 0;
            self.blocks[blockNum] = newBlock;
        }
    }

    function read(Info storage self, int128 exponent) internal view returns (FloatBits.Info memory) {
        int128 lowBlock = int128(floorDiv(exponent, WORD_SIZE));
        int128 shift = int128(floorMod(exponent, WORD_SIZE));

        int128 t1 = self.blocks[lowBlock];
        uint128 t2 = uint128(shift);
        int128 lowPart = int128ShiftRightUnsigned(t1, t2);

        if (shift != 0) {
            int128 highPart = self.blocks[lowBlock + 1] << uint128(WORD_SIZE - shift);
            return FloatBits.Info(exponent, highPart | lowPart);
        } else {
            return FloatBits.Info(exponent, lowPart);
        }
    }

    function growth(Info storage self, FloatBits.Info memory sinceLevel) internal view returns (Quad) {
        FloatBits.Info memory endValue = read(self, sinceLevel.exponent);
        int128 significand;
        unchecked {
            significand = endValue.significand - sinceLevel.significand;
        }
        return QuadPacker.repack(FloatBits.Info(endValue.exponent, significand));
    }
}
