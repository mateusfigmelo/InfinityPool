// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, POSITIVE_ZERO} from "src/types/ABDKMathQuad/Quad.sol";
import {wrap} from "src/types/Optional/OptInt256.sol";
import {MIN_SPLITS, MAX_SPLITS, DEADERA_NONE} from "src/Constants.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {SignedMath} from "@openzeppelin/contracts/utils/math/SignedMath.sol";
import {JumpyAnchorFaber} from "src/libraries/internal/JumpyAnchorFaber.sol";
import {JumpyFallback} from "src/libraries/internal/JumpyFallback.sol";
import {DailyJumps} from "src/libraries/internal/DailyJumps.sol";
import {GrowthSplitFrame} from "src/libraries/internal/GrowthSplitFrame.sol";
import {sqrtStrike, dayEra, eraDay} from "src/libraries/helpers/PoolHelper.sol";

library Gap {
    struct Info {
        int32 start;
        int32 stop;
    }

    function meet(Info storage self, Info memory other) internal {
        self.start = int32(SignedMath.max(self.start, other.start));
        self.stop = int32(SignedMath.min(self.stop, other.stop));
    }

    function top(Info storage self) internal {
        self.start = type(int32).min;
        self.stop = type(int32).max;
    }
}

library GapStagedFrame {
    using DailyJumps for DailyJumps.Info;
    using Gap for Gap.Info;
    using JumpyAnchorFaber for JumpyAnchorFaber.Info;
    using JumpyFallback for JumpyFallback.Info;
    using GrowthSplitFrame for GrowthSplitFrame.Info;
    using SafeCast for int256;
    using SafeCast for uint256;

    int256 constant neverAgo = -1 << 30;

    struct Info {
        DailyJumps.Info[2 << MAX_SPLITS] frame;
        Gap.Info latest;
        Gap.Info[2] gaps;
        int32 gapDay;
    }

    error InvalidNowtReaderApplyArguments();
    error InvalidStageArguments();
    error InvalidLiftReaderApplyArguments();
    error InvalidAddRangeArguments();
    error InavalidStageState();

    function coefAdd(Info storage self, PoolState storage pool, int256 node, Quad amount, int256 tailDay) public {
        self.frame[node.toUint256()].defer(pool, amount, tailDay);
    }

    function nowReader_coefAt(Info storage self, PoolState storage pool, int256 node) public returns (Quad) {
        DailyJumps.Info storage temp = self.frame[node.toUint256()];
        return temp.now(pool);
    }

    function nowReader_Apply(Info storage self, PoolState storage pool, int256 scale, int256 offset) public returns (Quad) {
        if (((offset & (-1 << scale.toUint256())) != 0)) revert InvalidNowtReaderApplyArguments();

        Quad total = nowReader_coefAt(self, pool, 1);

        int256 node = ((1 << scale.toUint256()).toInt256() + offset);

        while ((node > 1)) {
            total = (total + nowReader_coefAt(self, pool, node));
            node = (node >> 1);
        }

        return total;
    }

    function fresh(Info storage self, PoolState storage pool) public {
        int256 temp = (eraDay(pool.era) - self.gapDay);

        if ((temp == 0)) {
            return;
        } else {
            if ((temp == 1)) {
                int256 idx1 = (eraDay(pool.era) & 1);

                Gap.Info storage idx2 = self.gaps[idx1.toUint256()];

                self.latest.meet(idx2);
                idx2.top();
            } else {
                if ((self.gapDay != neverAgo)) {
                    Gap.Info storage idx0 = self.gaps[0];

                    Gap.Info storage idx1 = self.gaps[1];

                    self.latest.meet(idx0);
                    self.latest.meet(idx1);

                    idx0.top();
                    idx1.top();
                }
            }
        }
        self.gapDay = int32(eraDay(pool.era));
    }

    function liftReader_coefAt(Info storage self, int256 node, int256 day) public view returns (Quad) {
        DailyJumps.Info storage temp = self.frame[node.toUint256()];

        return temp.liftAt(day);
    }

    function _apply(Info storage self, PoolState storage pool, int256 bin) public view returns (DailyJumps.Info storage) {
        int256 idx = ((1 << int256(pool.splits).toUint256()).toInt256() + bin);

        return self.frame[idx.toUint256()];
    }

    function stage(Info storage self, PoolState storage pool, int256 startBin, int256 stopBin, Quad change) public {
        if ((startBin >= stopBin)) revert InvalidStageArguments();

        int256 tailDay = (eraDay(pool.era) + 2);

        fresh(self, pool);
        int256 idx = (eraDay(pool.era) & 1);

        Gap.Info storage gap = self.gaps[idx.toUint256()];

        if ((startBin >= pool.tickBin)) {
            int256 startStaged;
            if ((startBin == pool.tickBin)) startStaged = (pool.tickBin + 1);
            else startStaged = startBin;

            addRange(self, pool, pool.splits, startStaged, stopBin, change, tailDay);
            gap.stop = int32(SignedMath.min(gap.stop, startStaged));
        } else {
            if ((stopBin <= (pool.tickBin + 1))) {
                int256 stopStaged;
                if ((stopBin == (pool.tickBin + 1))) stopStaged = pool.tickBin;
                else stopStaged = stopBin;

                addRange(self, pool, pool.splits, startBin, stopStaged, change, tailDay);
                gap.start = int32(SignedMath.max(gap.start, stopStaged));
            } else {
                addRange(self, pool, pool.splits, startBin, pool.tickBin, change, tailDay);
                gap.start = pool.tickBin;
                addRange(self, pool, pool.splits, (pool.tickBin + 1), stopBin, change, tailDay);
                gap.stop = (pool.tickBin + 1);
            }
        }
        if (gap.start > pool.tickBin || gap.stop <= pool.tickBin) revert InavalidStageState();
    }

    function addRange(Info storage self, PoolState storage pool, int256 scale, int256 startIdx, int256 stopIdx, Quad change, int256 tailDay) public {
        int256 length = (1 << scale.toUint256()).toInt256();

        if ((((startIdx < 0) || (startIdx > stopIdx)) || (stopIdx > length))) revert InvalidAddRangeArguments();

        int256 start = (length + startIdx);

        int256 stop = (length + stopIdx);

        while ((start != stop)) {
            int256 temp = (start & 1);

            if ((temp != 0)) {
                coefAdd(self, pool, start, change, tailDay);
                start = (start + 1);
            }

            if (((stop & 1) != 0)) {
                stop = (stop - 1);
                coefAdd(self, pool, stop, change, tailDay);
            }

            start = (start >> 1);
            stop = (stop >> 1);
        }
    }

    function flush(Info storage self, PoolState storage pool, int256 bin) public {
        fresh(self, pool);
        GrowthSplitFrame.Info storage fees0 = pool.fees[0];

        GrowthSplitFrame.Info storage fees1 = pool.fees[1];

        Quad yieldFlow0 = (fees0.tailAt(pool, bin) / pool.epsilon);

        Quad yieldFlow1 = (fees1.tailAt(pool, bin) / pool.epsilon);

        Quad yieldRatio = (yieldFlow0 * sqrtStrike(pool.splits, bin));

        if (((bin < self.latest.start) || (bin >= self.latest.stop))) {
            Quad staged = nowReader_Apply(self, pool, pool.splits, bin);

            JumpyAnchorFaber.Info storage flowHat0 = pool.flowHat[0];

            JumpyAnchorFaber.Info storage flowHat1 = pool.flowHat[1];

            flowHat0.lateCreate(pool.era, (yieldFlow0.neg() * staged), pool.splits, bin, wrap((DEADERA_NONE)));
            flowHat1.lateCreate(pool.era, (yieldFlow1.neg() * staged), pool.splits, bin, wrap((DEADERA_NONE)));
            pool.owed.createOne(pool.era, pool.splits, (yieldRatio * staged), bin, wrap((DEADERA_NONE)));
            DailyJumps.Info storage temp = _apply(self, pool, bin);

            temp.begin(pool, staged.neg());
            if ((bin == self.latest.stop)) self.latest.stop = int32(bin + 1);
            else if ((bin + 1 == (self.latest.start))) self.latest.start = int32(bin);
        }

        for (int256 i = 0; (i < 2); i = (i + 1)) {
            flushAtGapIndex(
                self, pool, FlushAtGapIndexParams({i: i, bin: bin, yieldFlow0: yieldFlow0, yieldFlow1: yieldFlow1, yieldRatio: yieldRatio})
            );
        }
    }

    struct FlushAtGapIndexParams {
        int256 i;
        int256 bin;
        Quad yieldFlow0;
        Quad yieldFlow1;
        Quad yieldRatio;
    }

    function flushAtGapIndex(Info storage self, PoolState storage pool, FlushAtGapIndexParams memory params) public {
        int256 deadDay = (eraDay(pool.era) + (2 - params.i));

        Gap.Info storage gap = self.gaps[(deadDay & 1).toUint256()];

        if (((params.bin < gap.start) || (params.bin >= gap.stop))) {
            int256 deadEra = dayEra(deadDay);

            Quad staged = liftReader_Apply(self, deadDay, pool.splits, params.bin);

            JumpyAnchorFaber.Info storage flowHat0 = pool.flowHat[0];

            JumpyAnchorFaber.Info storage flowHat1 = pool.flowHat[1];

            flowHat0.lateExpire(pool.era, (params.yieldFlow0 * staged), pool.splits, params.bin, deadEra);
            flowHat1.lateExpire(pool.era, (params.yieldFlow1 * staged), pool.splits, params.bin, deadEra);
            pool.owed.expireOne(pool.era, pool.splits, (params.yieldRatio.neg() * staged), params.bin, deadEra);
            DailyJumps.Info storage temp = _apply(self, pool, params.bin);

            temp.defer(pool, staged.neg(), deadDay);
            if ((params.bin == gap.stop)) gap.stop = int32(params.bin + 1);
            else if ((params.bin + 1 == (gap.start))) gap.start = int32(params.bin);
        }
    }

    function liftReader_Apply(Info storage self, int256 day, int256 scale, int256 offset) public view returns (Quad) {
        if (((offset & (-1 << scale.toUint256())) != 0)) revert InvalidLiftReaderApplyArguments();

        Quad total = liftReader_coefAt(self, 1, day);

        int256 node = ((1 << scale.toUint256()).toInt256() + offset);

        while ((node > 1)) {
            total = (total + liftReader_coefAt(self, node, day));
            node = (node >> 1);
        }

        return total;
    }
}
