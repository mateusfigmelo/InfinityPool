// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {Quad} from "src/types/ABDKMathQuad/Quad.sol";
import {BoxcarTubFrame} from "src/libraries/internal/BoxcarTubFrame.sol";
import {JumpyFallback} from "src/libraries/internal/JumpyFallback.sol";

library TestInfinityPoolHelper {
    using JumpyFallback for JumpyFallback.Info;

    function getMintedAtOffset(PoolState storage pool, int256 offset) public view returns (Quad) {
        return BoxcarTubFrame.apply_(pool.minted, offset);
    }

    function getUsed(PoolState storage pool, int256 startBin, int256 stopBin) external returns (Quad[] memory used) {
        require(startBin >= 0 && stopBin > startBin, "BAD bins");
        used = new Quad[](uint256(stopBin - startBin));
        for (int256 bin = startBin; bin < stopBin; bin++) {
            used[uint256(bin - startBin)] = pool.used.nowAt(pool.era, pool.splits, bin);
        }
    }

    function getMinted(PoolState storage pool, int256 startTub, int256 stopTub) external view returns (Quad[] memory) {
        require(startTub >= 0 && stopTub > startTub, "BAD tubs");
        Quad[] memory minted = new Quad[](uint256(stopTub - startTub));
        for (int256 tub = startTub; tub < stopTub; tub++) {
            minted[uint256(tub - startTub)] = BoxcarTubFrame.apply_(pool.minted, tub);
        }
        return minted;
    }
}
