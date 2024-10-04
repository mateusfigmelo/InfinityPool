// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad, POSITIVE_ZERO, NEGATIVE_ONE, POSITIVE_ONE, fromUint256, fromInt256, intoUint256, intoInt256} from "src/types/ABDKMathQuad/Quad.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {NewLoan} from "src/libraries/external/NewLoan.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {Swapper} from "src/libraries/external/Swapper.sol";
import {SwapperInternal} from "src/libraries/external/SwapperInternal.sol";
import {wrap} from "src/types/Optional/OptInt256.sol";

//Mock to perform test case
library MockNewLoan1 {
    //TODO: add deadEra, twapUntill when types are ready
    //TODO: Add State and Immutable state to signature when ready

    function newLoan(PoolState storage pool, NewLoan.NewLoanParams memory) public returns (UserPay.Info memory) {
        pool.swappers.push(
            SwapperInternal.Info({
                owner: address(0),
                startBin: 0,
                strikeBin: 0,
                tokenMix: POSITIVE_ZERO,
                unlockDate: POSITIVE_ZERO,
                deadEra: wrap(0),
                token: false,
                twapUntil: wrap(0),
                owed: new Quad[](0),
                lent: new Quad[](0),
                minted: new Quad[](0),
                oweLimit: POSITIVE_ZERO,
                lentCapacity0: POSITIVE_ZERO,
                lentCapacity1: POSITIVE_ZERO
            })
        );
        return UserPay.Info({token0: POSITIVE_ONE, token1: NEGATIVE_ONE});
    }
}

library MockNewLoan2 {
    function newLoan(PoolState storage pool, NewLoan.NewLoanParams memory) public returns (UserPay.Info memory) {
        pool.swappers.push(
            SwapperInternal.Info({
                owner: address(0),
                startBin: 0,
                strikeBin: 0,
                tokenMix: POSITIVE_ZERO,
                unlockDate: POSITIVE_ZERO,
                deadEra: wrap(0),
                token: false,
                twapUntil: wrap(0),
                owed: new Quad[](0),
                lent: new Quad[](0),
                minted: new Quad[](0),
                oweLimit: POSITIVE_ZERO,
                lentCapacity0: POSITIVE_ZERO,
                lentCapacity1: POSITIVE_ZERO
            })
        );
        return UserPay.Info({token0: POSITIVE_ONE, token1: POSITIVE_ZERO});
    }
}

library MockNewLoan3 {
    function newLoan(PoolState storage pool, NewLoan.NewLoanParams memory) public returns (UserPay.Info memory) {
        pool.swappers.push(
            SwapperInternal.Info({
                owner: address(0),
                startBin: 0,
                strikeBin: 0,
                tokenMix: POSITIVE_ZERO,
                unlockDate: POSITIVE_ZERO,
                deadEra: wrap(0),
                token: false,
                twapUntil: wrap(0),
                owed: new Quad[](0),
                lent: new Quad[](0),
                minted: new Quad[](0),
                oweLimit: POSITIVE_ZERO,
                lentCapacity0: POSITIVE_ZERO,
                lentCapacity1: POSITIVE_ZERO
            })
        );
        return UserPay.Info({token0: POSITIVE_ONE, token1: POSITIVE_ONE});
    }
}

library MockNewLoan4 {
    function newLoan(PoolState storage pool, NewLoan.NewLoanParams memory) public returns (UserPay.Info memory) {
        pool.swappers.push(
            SwapperInternal.Info({
                owner: address(0),
                startBin: 0,
                strikeBin: 0,
                tokenMix: POSITIVE_ZERO,
                unlockDate: POSITIVE_ZERO,
                deadEra: wrap(0),
                token: false,
                twapUntil: wrap(0),
                owed: new Quad[](0),
                lent: new Quad[](0),
                minted: new Quad[](0),
                oweLimit: POSITIVE_ZERO,
                lentCapacity0: POSITIVE_ZERO,
                lentCapacity1: POSITIVE_ZERO
            })
        );
        return UserPay.Info({token0: POSITIVE_ONE, token1: fromInt256(-500)});
    }
}

library MockNewLoan5 {
    function newLoan(PoolState storage pool, NewLoan.NewLoanParams memory) public returns (UserPay.Info memory) {
        pool.swappers.push(
            SwapperInternal.Info({
                owner: address(0),
                startBin: 0,
                strikeBin: 0,
                tokenMix: POSITIVE_ZERO,
                unlockDate: POSITIVE_ZERO,
                deadEra: wrap(0),
                token: false,
                twapUntil: wrap(0),
                owed: new Quad[](0),
                lent: new Quad[](0),
                minted: new Quad[](0),
                oweLimit: POSITIVE_ZERO,
                lentCapacity0: POSITIVE_ZERO,
                lentCapacity1: POSITIVE_ZERO
            })
        );
        return UserPay.Info({token0: NEGATIVE_ONE, token1: fromInt256(500)});
    }
}

library MockNewLoan6 {
    function newLoan(PoolState storage pool, NewLoan.NewLoanParams memory) public returns (UserPay.Info memory) {
        pool.swappers.push(
            SwapperInternal.Info({
                owner: address(0),
                startBin: 0,
                strikeBin: 0,
                tokenMix: POSITIVE_ZERO,
                unlockDate: POSITIVE_ZERO,
                deadEra: wrap(0),
                token: false,
                twapUntil: wrap(0),
                owed: new Quad[](0),
                lent: new Quad[](0),
                minted: new Quad[](0),
                oweLimit: POSITIVE_ZERO,
                lentCapacity0: POSITIVE_ZERO,
                lentCapacity1: POSITIVE_ZERO
            })
        );
        return UserPay.Info({token0: POSITIVE_ZERO, token1: POSITIVE_ONE});
    }
}

library MockNewLoan7 {
    function newLoan(PoolState storage pool, NewLoan.NewLoanParams memory) public returns (UserPay.Info memory) {
        pool.swappers.push(
            SwapperInternal.Info({
                owner: address(0),
                startBin: 0,
                strikeBin: 0,
                tokenMix: POSITIVE_ZERO,
                unlockDate: POSITIVE_ZERO,
                deadEra: wrap(0),
                token: false,
                twapUntil: wrap(0),
                owed: new Quad[](0),
                lent: new Quad[](0),
                minted: new Quad[](0),
                oweLimit: POSITIVE_ZERO,
                lentCapacity0: POSITIVE_ZERO,
                lentCapacity1: POSITIVE_ZERO
            })
        );
        return UserPay.Info({token0: POSITIVE_ONE, token1: fromInt256(-200)});
    }
}

library MockNewLoan8 {
    function newLoan(PoolState storage pool, NewLoan.NewLoanParams memory) public returns (UserPay.Info memory) {
        pool.swappers.push(
            SwapperInternal.Info({
                owner: address(0),
                startBin: 0,
                strikeBin: 0,
                tokenMix: POSITIVE_ZERO,
                unlockDate: POSITIVE_ZERO,
                deadEra: wrap(0),
                token: false,
                twapUntil: wrap(0),
                owed: new Quad[](0),
                lent: new Quad[](0),
                minted: new Quad[](0),
                oweLimit: POSITIVE_ZERO,
                lentCapacity0: POSITIVE_ZERO,
                lentCapacity1: POSITIVE_ZERO
            })
        );
        return UserPay.Info({token0: NEGATIVE_ONE, token1: fromInt256(600)});
    }
}
