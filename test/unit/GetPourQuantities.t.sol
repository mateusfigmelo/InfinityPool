// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Quad, fromUint256} from "src/types/ABDKMathQuad/Quad.sol";
import {POSITIVE_ZERO, HALF, POSITIVE_INFINITY, fromInt256, fromUint256, intoUint256, Quad, wrap} from "src/types/ABDKMathQuad/Quad.sol";
import {InfinityPoolsFactory} from "src/InfinityPoolsFactory.sol";
import {InfinityPool} from "src/InfinityPool.sol";
import {Token} from "src/mock/Token.sol";
import {TUBS} from "src/Constants.sol";
import {OPT_INT256_NONE, OptInt256} from "src/types/Optional/OptInt256.sol";
import {NewLoan} from "src/libraries/external/NewLoan.sol";
import {logQuad} from "test/unit/utils/QuadDebug.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {TestInfinityPoolWithPaymentCallback} from "src/mock/TestInfinityPoolWithPaymentCallback.sol";
import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {InfinityPoolTestCore} from "./InfinityPoolTestCore.sol";

contract GetPourQuantitiesTest is InfinityPoolTestCore {
    function logInt256(string memory msg, int256 x) internal {
        if (x >= 0) console2.log(msg, uint256(x));
        else console2.log(string.concat(msg, "-"), uint256(-x));
    }

    function checkGetPourQuantitiesAgainstPour(int256 startTub, int256 stopTub, Quad liquidity) internal {
        int256 getToken0;
        int256 getToken1;
        (getToken0, getToken1) = infinityPool.getPourQuantities(startTub, stopTub, liquidity);
        uint256 lpNum;
        int256 pourToken0_1;
        int256 pourToken1_1;
        (lpNum, pourToken0_1, pourToken1_1,) = infinityPool.pour(startTub, stopTub, liquidity, "");
        int256 pourToken0_2;
        int256 pourToken1_2;
        (lpNum, pourToken0_2, pourToken1_2,) = infinityPool.pour(startTub, stopTub, liquidity, "");
        assertEq(getToken0, pourToken0_1);
        assertEq(getToken0, pourToken0_2);
        assertEq(getToken1, pourToken1_1);
        assertEq(getToken0, pourToken0_2);
    }

    // This test makes sure getPourQuantities gives the same answer as pour()
    // TODO: add newLoans to make the test more realistic.
    function test_GetPourQuantities() public {
        vm.warp(baseTimestamp + 1 minutes);
        checkGetPourQuantitiesAgainstPour(0, TUBS, fromUint256(1));
        checkGetPourQuantitiesAgainstPour(10, 11, fromUint256(666));
        vm.warp(baseTimestamp + 1 days);
        checkGetPourQuantitiesAgainstPour(1000, 2000, fromUint256(100));
        vm.warp(baseTimestamp + 3 days);
        checkGetPourQuantitiesAgainstPour(1000, 1001, fromUint256(1000));
    }

    struct OnePour {
        int256 startTub;
        int256 stopTub;
        Quad liquidity;
    }

    struct PourResult {
        int256 token0;
        int256 token1;
    }

    // run a series of pours with one getPourQuantities() after getPosition pours.
    function runPours(OnePour[] memory pours, int256 getPosition, OnePour memory getPour) internal returns (PourResult[] memory) {
        PourResult[] memory results = new PourResult[](pours.length);
        for (uint256 i; i < pours.length; i++) {
            if (getPosition >= 0 && uint256(getPosition) == i) infinityPool.getPourQuantities(getPour.startTub, getPour.stopTub, getPour.liquidity);
            uint256 lpNum;
            (lpNum, results[i].token0, results[i].token1,) = infinityPool.pour(pours[i].startTub, pours[i].stopTub, pours[i].liquidity, "");
        }
        return results;
    }

    // This test makes sure getPourQuantities leaves no material side effects.
    function testGetPourQuantitiesLeavesNoSideEffects() public {
        // The following does not work.
        // OnePour[] memory pours = [OnePour({startTub: 0, stopTub: TUBS, liquidity: fromUint256(100)})];
        OnePour[] memory pours = new OnePour[](9);
        uint256 i = 0;
        pours[i++] = OnePour({startTub: 0, stopTub: TUBS, liquidity: fromUint256(100)});
        pours[i++] = OnePour({startTub: 1, stopTub: 2, liquidity: fromUint256(10)});
        pours[i++] = OnePour({startTub: TUBS - 1, stopTub: TUBS, liquidity: fromUint256(10)});
        pours[i++] = OnePour({startTub: TUBS / 2 - 1, stopTub: TUBS / 2, liquidity: fromUint256(11)});
        pours[i++] = OnePour({startTub: TUBS / 2, stopTub: TUBS / 2 + 1, liquidity: fromUint256(12)});
        pours[i++] = OnePour({startTub: TUBS / 2 + 1, stopTub: TUBS / 2 + 2, liquidity: fromUint256(13)});
        pours[i++] = OnePour({startTub: 10, stopTub: TUBS - 10, liquidity: fromUint256(13)});
        pours[i++] = OnePour({startTub: TUBS / 4, stopTub: TUBS / 2, liquidity: fromUint256(13)});
        pours[i++] = OnePour({startTub: TUBS * 3 / 4, stopTub: TUBS, liquidity: fromUint256(13)});

        OnePour memory getPour = OnePour(0, TUBS, fromUint256(1000));

        initializeEverything();
        PourResult[] memory referenceResults = runPours(pours, -1, getPour);

        for (int256 i = 0; i < int256(pours.length); i++) {
            initializeEverything();
            PourResult[] memory results = runPours(pours, i, getPour);
            assertEq(results.length, referenceResults.length);
            for (uint256 j = 0; j < results.length; j++) {
                assertEq(results[j].token0, referenceResults[j].token0);
                assertEq(results[j].token1, referenceResults[j].token1);
            }
        }
    }
}
