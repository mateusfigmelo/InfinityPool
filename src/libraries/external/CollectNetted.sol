// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {IInfinityPoolFactory} from "src/interfaces/IInfinityPoolFactory.sol";
import {Quad, fromInt256, POSITIVE_ZERO, intoInt256} from "src/types/ABDKMathQuad/Quad.sol";
import {Advance} from "src/libraries/external/Advance.sol";
import {timestampDate} from "src/libraries/helpers/PoolHelper.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {NettingGrowth} from "src/libraries/external/Swapper.sol";

library CollectNetted {
    using UserPay for UserPay.Info;
    using NettingGrowth for NettingGrowth.Info;

    error OnlyFactoryOwnerIsAllowedToCollectFees();

    function collectNetted(PoolState storage pool, address to, bytes memory data) external returns (int256 amount0, int256 amount1) {
        if (msg.sender != IInfinityPoolFactory(pool.factory).owner()) revert OnlyFactoryOwnerIsAllowedToCollectFees();
        Advance.advance(pool, timestampDate(block.timestamp), true);

        Quad held0 = pool.surplus0 + pool.netting[0].now(pool);
        Quad held1 = pool.surplus1 + pool.netting[1].now(pool);

        pool.surplus0 = POSITIVE_ZERO;
        pool.surplus1 = POSITIVE_ZERO;
        pool.netting[0].accrued = POSITIVE_ZERO;
        pool.netting[1].accrued = POSITIVE_ZERO;

        UserPay.Info memory userPay = UserPay.Info({token0: -held0, token1: -held1});
        return userPay.makeUserPay(pool, to, data);
    }
}
