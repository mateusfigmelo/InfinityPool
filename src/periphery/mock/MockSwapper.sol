// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, POSITIVE_ZERO, NEGATIVE_ONE, POSITIVE_ONE, fromUint256, fromInt256, intoUint256, intoInt256} from "src/types/ABDKMathQuad/Quad.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {NewLoan} from "src/libraries/external/NewLoan.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {SwapperInternal} from "src/libraries/external/SwapperInternal.sol";
import {wrap} from "src/types/Optional/OptInt256.sol";

library MockSwapper1 {
    function unwind(SwapperInternal.Info storage, PoolState storage) external pure returns (UserPay.Info memory) {
        return UserPay.Info({token0: fromInt256(-100), token1: POSITIVE_ZERO});
    }
}

library MockSwapper2 {
    function unwind(SwapperInternal.Info storage, PoolState storage) external pure returns (UserPay.Info memory) {
        return UserPay.Info({token0: POSITIVE_ZERO, token1: fromInt256(-100)});
    }
}
