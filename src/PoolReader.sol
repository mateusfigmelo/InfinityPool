// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Fees} from "src/libraries/internal/Fees.sol";
import {LP} from "src/libraries/external/LP.sol";
import {LPShed} from "src/libraries/external/LPShed.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {Quad} from "./types/ABDKMathQuad/Quad.sol";
import {Structs} from "src/libraries/external/Structs.sol";
import {tubLowEdge} from "src/libraries/helpers/PoolHelper.sol";
import {Quad, fromInt256, POSITIVE_ZERO} from "./types/ABDKMathQuad/Quad.sol";
import {subSplits} from "src/libraries/helpers/PoolHelper.sol";
import {JumpyFallback} from "src/libraries/internal/JumpyFallback.sol";
import {BoxcarTubFrame} from "src/libraries/internal/BoxcarTubFrame.sol";
import {TUBS} from "./Constants.sol";
import {GrowthSplitFrame} from "src/libraries/internal/GrowthSplitFrame.sol";

library PoolReader {
    using JumpyFallback for JumpyFallback.Info;
    using GrowthSplitFrame for GrowthSplitFrame.Info;

    error InvalidLPNumber();
    error InvalidLPStage();

    function getLiquidityPosition(PoolState storage pool, uint256 lpNum) public returns (Structs.LiquidityPosition memory lp) {
        if (lpNum >= pool.lpCount) revert InvalidLPNumber();
        lp.lpNum = lpNum;
        lp.token0 = pool.token0;
        lp.token1 = pool.token1;
        LP.Info storage info = pool.lps[lpNum];
        lp.lowerEdge = tubLowEdge(info.startTub);
        lp.upperEdge = tubLowEdge(info.stopTub);
        lp.earnEra = info.earnEra;
        (int256 startBin, int256 stopBin) = LP.bins(pool.splits, info.startTub, info.stopTub);
        (Quad lockedAmount0, Quad lockedAmount1) = LP.reserves(pool, info.startTub, info.stopTub, startBin, stopBin);
        (lp.lockedAmount0, lp.lockedAmount1) = Fees.translateFees(lockedAmount0 * info.liquidity, lockedAmount1 * info.liquidity, pool);
        if (info.stage == LP.Stage.Join) {
            lp.state = Structs.LP_STATE_OPENED;
            // we are done here
            return lp;
        }

        if (info.stage == LP.Stage.Earn) lp.state = Structs.LP_STATE_ACTIVE;
        else if (info.stage == LP.Stage.Exit) lp.state = Structs.LP_STATE_CLOSED;
        else revert InvalidLPStage();
        (Quad earned0, Quad earned1) = LP.earn(info, pool, false /* flush */ );
        (lp.unclaimedFees0, lp.unclaimedFees1) = Fees.translateFees(earned0, earned1, pool);
        if (info.stage == LP.Stage.Exit) {
            (Quad shed0, Quad shed1) = LPShed.shed(info, pool, false /* flush */ );
            (lp.availableAmount0, lp.availableAmount1) = Fees.translateFees(shed0, shed1, pool);
        } // else: the defaults are 0 anyway.
    }

    function getTubUtilization(PoolState storage pool, int256 tub) public returns (Quad) {
        int256 binsPerTub = int256(1 << uint256(subSplits(pool.splits)));
        int256 startBinOffset = tub * binsPerTub;
        Quad used = POSITIVE_ZERO;
        for (int256 binIndex = 0; binIndex < binsPerTub; binIndex++) {
            used = used + pool.used.nowAt(pool.era, pool.splits, startBinOffset + binIndex);
        }
        return used * pool.deflator / fromInt256(binsPerTub);
    }

    function getTubMinted(PoolState storage pool, int256 tub) public view returns (Quad) {
        return BoxcarTubFrame.apply_(pool.minted, tub);
    }

    function getLiquidityInfo(PoolState storage pool, int256 startTub, int256 stopTub) public returns (Structs.LiquidityInfo memory info) {
        require(startTub < stopTub && startTub >= 0 && stopTub <= TUBS, "invalid startTub and/or stopTub");

        Structs.TubLiquidityInfo[] memory infos = new Structs.TubLiquidityInfo[](uint256(stopTub - startTub));
        for (int256 tub = startTub; tub < stopTub; tub++) {
            uint256 index = uint256(tub - startTub);
            infos[index].tub = tub;
            infos[index].liquidity = getTubMinted(pool, tub);
            infos[index].utilization = getTubUtilization(pool, tub);
            infos[index].accrued0 = pool.fees[0].accruedRange(pool, tub, tub + 1);
            infos[index].accrued1 = pool.fees[1].accruedRange(pool, tub, tub + 1);
        }
        info.startTub = startTub;
        info.stopTub = stopTub;
        info.chainId = block.chainid;
        info.blockNumber = block.number;
        info.blockHash = blockhash(block.number);
        info.blockTimestamp = block.timestamp;
        info.splits = pool.splits;
        info.tickBin = pool.tickBin;
        info.binFrac = pool.binFrac;
        info.poolDate = pool.date;
        info.perTubInfos = infos;
    }
}
