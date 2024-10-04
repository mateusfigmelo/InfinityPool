// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {EraFaberTotals} from "../internal/EraFaberTotals.sol";
import {EraBoxcarMidSum} from "../internal/EraBoxcarMidSum.sol";
import {GrowthSplitFrame} from "../internal/GrowthSplitFrame.sol";
import {JumpyAnchorFaber} from "../internal/JumpyAnchorFaber.sol";
import {UserPay} from "../internal/UserPay.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {
    Quad, POSITIVE_TWO, POSITIVE_FOUR, POSITIVE_EIGHT, fromUint256, fromInt256, LibOptQuad, POSITIVE_ZERO
} from "src/types/ABDKMathQuad/Quad.sol";

import {expm1} from "src/types/ABDKMathQuad/MathExtended.sol";
import {logBin, exFee, timestampDate, dateEra, fracBin, tickBin, BINS} from "src/libraries/helpers/PoolHelper.sol";
import {BucketRolling} from "../internal/BucketRolling.sol";
import {TWAP_SPREAD_DEFAULT} from "src/Constants.sol";

library PoolConstructor {
    using UserPay for UserPay.Info;
    using EraFaberTotals for EraFaberTotals.Info;
    using EraBoxcarMidSum for EraBoxcarMidSum.Info;
    using GrowthSplitFrame for GrowthSplitFrame.Info;
    using JumpyAnchorFaber for JumpyAnchorFaber.Info;

    error InvalidTickBin(int256 tickBin);

    error PoolAlreadyInitialized();

    function constructPool(PoolState storage pool, uint256 currentTimestamp) external {
        pool.tenToPowerDecimals0 = fromUint256(10 ** IERC20Metadata(pool.token0).decimals());
        pool.tenToPowerDecimals1 = fromUint256(10 ** IERC20Metadata(pool.token1).decimals());

        Quad poolLogBin = logBin(pool.splits);

        pool.epsilon = expm1(poolLogBin / POSITIVE_FOUR) - expm1(-poolLogBin / POSITIVE_FOUR);
        pool.fee = -expm1(-poolLogBin / POSITIVE_TWO);

        pool.move2Var =
            POSITIVE_EIGHT * pool.fee / exFee(pool.fee) * pool.epsilon / ((poolLogBin / POSITIVE_FOUR).exp() + (-poolLogBin / POSITIVE_FOUR).exp());

        pool.date = timestampDate(currentTimestamp);
        pool.era = int32(dateEra(pool.date));
        pool.deflator = (-pool.date).exp2();
        pool.entryDeflator = pool.deflator;

        pool.lentEnd[0].eraFaberTotals.init(false);
        pool.lentEnd[1].eraFaberTotals.init(true);

        pool.flowDot[0][0].init(false);
        pool.flowDot[0][1].init(true);
        pool.flowDot[1][0].init(false);
        pool.flowDot[1][1].init(true);
    }
    // Quadvar doesn't have any checks. Need to add it before enabling permissionless pool creation.

    function setInitialPriceAndVariance(PoolState storage pool, Quad startPrice, Quad quadVar0) external {
        if (pool.isPoolInitialized) revert PoolAlreadyInitialized();
        pool.isPoolInitialized = true;

        Quad fracBin = fracBin(pool.splits, startPrice);
        pool.tickBin = int32(tickBin(fracBin));
        if (pool.tickBin >= ((BINS(pool.splits) - 1)) || pool.tickBin <= 0) revert InvalidTickBin(pool.tickBin);

        pool.binFrac = fracBin - fromInt256(pool.tickBin);

        BucketRolling.init(pool.dayMove, pool, quadVar0 / pool.move2Var);

        pool.fees[0].init(pool, pool.tickBin, false);
        pool.fees[1].init(pool, pool.tickBin, true);

        pool.flowHat[0].init(pool.tickBin, false);
        pool.flowHat[1].init(pool.tickBin, true);

        pool.twapSpread = TWAP_SPREAD_DEFAULT;
    }
}
