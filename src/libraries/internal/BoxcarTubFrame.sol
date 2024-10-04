// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad} from "src/types/ABDKMathQuad/Quad.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {DeadlineJumps, DeadlineSet, PiecewiseCurve} from "src/libraries/internal/DeadlineJumps.sol";
import {OptInt256, wrap} from "src/types/Optional/OptInt256.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {subSplits} from "src/libraries/helpers/PoolHelper.sol";

import {MIN_SPLITS} from "src/Constants.sol";

library BoxcarTubFrame {
    using SafeCast for int256;

    error OffsetOutOfRange();
    error StartIdOrStopIdOutOfRange();

    struct Info {
        Quad[2 << MIN_SPLITS] coef;
    }

    function coefAt(Info storage self, int256 node) internal view returns (Quad) {
        return self.coef[node.toUint256()];
    }

    function coefAdd(Info storage self, int256 node, Quad amount) internal {
        self.coef[node.toUint256()] = self.coef[node.toUint256()] + amount;
    }

    function apply_(Info storage self, int256 offset) internal view returns (Quad) {
        if (((offset < 0) || (offset >= int256(1 << int256(MIN_SPLITS).toUint256())))) revert OffsetOutOfRange();
        Quad total = coefAt(self, 1);
        int256 node = (int256(1 << int256(MIN_SPLITS).toUint256()) + offset);
        while ((node > 1)) {
            total = (total + coefAt(self, node));
            node = (node >> 1);
        }
        return total;
    }

    function active(Info storage self, int256 splits, int256 tickBin) internal view returns (Quad) {
        return apply_(self, tickBin >> uint256(subSplits(splits)));
    }

    function addRange(Info storage self, int256 startIdx, int256 stopIdx, Quad change) internal {
        int256 length = int256(1 << int256(MIN_SPLITS).toUint256());
        if ((((startIdx < 0) || (startIdx > stopIdx)) || (stopIdx > length))) revert StartIdOrStopIdOutOfRange();
        int256 start = (length + startIdx);

        int256 stop = (length + stopIdx);
        while ((start != stop)) {
            if (((start & 1) != 0)) {
                coefAdd(self, start, change);
                start = (start + 1);
            }
            if (((stop & 1) != 0)) {
                stop = (stop - 1);
                coefAdd(self, stop, change);
            }
            start = (start >> 1);
            stop = (stop >> 1);
        }
    }
}
