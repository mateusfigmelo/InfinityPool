// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {OptInt256} from "src/types/Optional/OptInt256.sol";
import {Quad, POSITIVE_ZERO} from "src/types/ABDKMathQuad/Quad.sol";
import {MIN_SPLITS} from "src/Constants.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {DropsGroup, DeadlineSet} from "src/libraries/internal/DeadlineJumps.sol";
import {EraFaberTotals} from "src/libraries/internal/EraFaberTotals.sol";

library DropFaberTotals {
    using DropsGroup for DeadlineSet.Info;
    using SafeCast for int256;
    using SafeCast for uint256;

    struct Info {
        EraFaberTotals.Info eraFaberTotals;
    }

    error InvalidAddArguments();

    function expire(Info storage self, int256 poolEra, Quad[] memory amounts, int256 scale, int256 start, OptInt256 deadEra) internal {
        if (deadEra.isDefined()) {
            int256 aDeadEra = deadEra.get();
            add(self, poolEra, scale, start, amounts, aDeadEra);
        }
    }

    function add(Info storage self, int256 poolEra, int256 scale, int256 start, Quad[] memory areas, int256 aDeadEra) internal {
        if (!((scale.toUint256() >= MIN_SPLITS && ((start >= 0)) && ((start.toUint256() + areas.length) <= (1 << scale.toUint256()))))) {
            revert InvalidAddArguments();
        }

        Quad[] memory carry = new Quad[](scale.toUint256());

        int256 first = ((1 << scale.toUint256()) + start.toUint256()).toInt256();

        int256 node = 0;

        int256 depth = 0;

        Quad change = POSITIVE_ZERO;

        for (int256 index = 0; (index.toUint256() < areas.length); index = (index + 1)) {
            node = (first + index);
            change = areas[index.toUint256()];
            depth = (scale - 1);
            while ((depth.toUint256() >= MIN_SPLITS)) {
                bool leftChild = ((node & 1) == 0);

                node = (node >> 1);
                if (leftChild) {
                    carry[depth.toUint256()] = change;
                    break;
                } else {
                    smallAdd(self, poolEra, node, (carry[depth.toUint256()] - change), aDeadEra);
                    change = (change + carry[depth.toUint256()]);
                }
                depth = (depth - 1);
            }

            if ((depth.toUint256() < MIN_SPLITS)) {
                largeAdd(self, poolEra, node, change, MIN_SPLITS.toInt256(), aDeadEra);
                while (true) {
                    bool leftChild = ((node & 1) == 0);

                    node = (node >> 1);
                    if (leftChild) {
                        carry[depth.toUint256()] = change;
                        break;
                    } else {
                        change = (change + carry[depth.toUint256()]);
                        if ((node <= 1)) break;

                        largeAdd(self, poolEra, node, change, depth, aDeadEra);
                    }
                    depth = (depth - 1);
                }
            }
        }

        if ((depth.toUint256() >= MIN_SPLITS)) {
            smallAdd(self, poolEra, node, change, aDeadEra);
            while ((depth.toUint256() > MIN_SPLITS)) {
                depth = (depth - 1);
                bool leftChild = ((node & 1) == 0);

                node = (node >> 1);
                if (leftChild) {
                    smallAdd(self, poolEra, node, change, aDeadEra);
                } else {
                    smallAdd(self, poolEra, node, (carry[depth.toUint256()] - change), aDeadEra);
                    change = (change + carry[depth.toUint256()]);
                }
            }
        }

        while ((node > 1)) {
            largeAdd(self, poolEra, node, change, depth, aDeadEra);
            depth = (depth - 1);
            if (((node & 1) != 0)) change = (change + carry[depth.toUint256()]);

            node = (node >> 1);
        }

        largeAdd(self, poolEra, 1, change, 0, aDeadEra);
    }

    function smallAdd(Info storage self, int256 poolEra, int256 node, Quad amount, int256 aDeadEra) internal {
        DeadlineSet.Info storage temp = self.eraFaberTotals.small[node.toUint256()];
        temp.expire(poolEra, amount, aDeadEra);
    }

    function largeAdd(Info storage self, int256 poolEra, int256 node, Quad amount, int256, int256 aDeadEra) internal {
        DeadlineSet.Info storage temp = self.eraFaberTotals.large[node.toUint256()];
        temp.expire(poolEra, amount, aDeadEra);
    }
}
