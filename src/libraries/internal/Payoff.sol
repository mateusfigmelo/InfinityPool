// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {Quad} from "src/types/ABDKMathQuad/Quad.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {OptInt256, wrap} from "src/types/Optional/OptInt256.sol";
import {DeadlineFlag} from "src/libraries/internal/DeadlineFlag.sol";
import {sqrtStrike} from "src/libraries/helpers/PoolHelper.sol";
import {Z, I} from "src/Constants.sol";
import {EraBoxcarMidSum} from "src/libraries/internal/EraBoxcarMidSum.sol";

library AnyPayoff {
    using DeadlineFlag for DeadlineFlag.Info;
    using EraBoxcarMidSum for EraBoxcarMidSum.Info;

    function payoffCreate(PoolState storage pool, bool token, Quad liquidity, int256 bin, OptInt256 deadEra) public {
        int256 scale = pool.splits;
        int256 offset = bin;
        pool.resets.assign(pool.era, true, deadEra);
        Quad sqrtStrike = sqrtStrike(pool.splits, bin);

        if ((token == Z)) {
            pool.flowDot[0][1].create(pool, liquidity * sqrtStrike, scale, offset, deadEra);
            pool.flowDot[0][0].create(pool, liquidity / sqrtStrike, scale, offset, deadEra);
        } else {
            pool.flowDot[1][0].create(pool, liquidity / sqrtStrike, scale, offset, deadEra);
            pool.flowDot[1][1].create(pool, liquidity * sqrtStrike, scale, offset, deadEra);
        }
    }

    function payoffExtend(PoolState storage pool, bool token, Quad liquidity, int256 bin, OptInt256 oldDeadEra, OptInt256 newDeadEra) public {
        int256 scale = pool.splits;
        int256 offset = bin;
        pool.resets.assign(pool.era, true, newDeadEra);
        Quad sqrtStrike = sqrtStrike(pool.splits, bin);

        if ((token == Z)) {
            pool.flowDot[0][1].extend(pool, liquidity * sqrtStrike, scale, offset, oldDeadEra, newDeadEra);
            pool.flowDot[0][0].extend(pool, liquidity / sqrtStrike, scale, offset, oldDeadEra, newDeadEra);
        } else {
            pool.flowDot[1][0].extend(pool, liquidity / sqrtStrike, scale, offset, oldDeadEra, newDeadEra);
            pool.flowDot[1][1].extend(pool, liquidity * sqrtStrike, scale, offset, oldDeadEra, newDeadEra);
        }
    }
}
