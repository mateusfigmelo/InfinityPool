// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {TWAP_SPREAD_DEFAULT, TUBS} from "./Constants.sol";
import {BoxcarTubFrame} from "src/libraries/internal/BoxcarTubFrame.sol";
import {Quad, fromInt256, POSITIVE_ZERO, intoInt256} from "./types/ABDKMathQuad/Quad.sol";
import {PoolState} from "src/interfaces/IInfinityPoolState.sol";
import {IInfinityPool} from "src/interfaces/IInfinityPool.sol";
import {InfinityPoolState} from "./InfinityPoolState.sol";
import {timestampDate, fracBin, tickBin} from "src/libraries/helpers/PoolHelper.sol";
import {BucketRolling} from "src/libraries/internal/BucketRolling.sol";
import {Spot} from "src/libraries/external/Spot.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {NewLoan} from "src/libraries/external/NewLoan.sol";
import {OptInt256} from "./types/Optional/OptInt256.sol";
import {Advance} from "src/libraries/external/Advance.sol";
import {LP} from "src/libraries/external/LP.sol";
import {Swapper} from "src/libraries/external/Swapper.sol";
import {SwapperInternal} from "src/libraries/external/SwapperInternal.sol";
import {GrowthSplitFrame} from "src/libraries/internal/GrowthSplitFrame.sol";
import {JumpyAnchorFaber} from "src/libraries/internal/JumpyAnchorFaber.sol";
import {NettingGrowth} from "src/libraries/external/Swapper.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {IInfinityPoolFactory} from "src/interfaces/IInfinityPoolFactory.sol";
import {Structs} from "src/libraries/external/Structs.sol";
import {PoolReader} from "./PoolReader.sol";
import {PoolConstructor} from "src/libraries/external/PoolConstructor.sol";
import {CollectNetted} from "src/libraries/external/CollectNetted.sol";

contract InfinityPool is IInfinityPool, InfinityPoolState, Initializable, ReentrancyGuardUpgradeable {
    using UserPay for UserPay.Info;
    using NettingGrowth for NettingGrowth.Info;

    //for init functions
    using JumpyAnchorFaber for JumpyAnchorFaber.Info;

    constructor() initializer {}

    function initialize(address factory, address token0, address token1, int32 splits) public virtual initializer {
        __ReentrancyGuard_init();
        pool.factory = factory;
        pool.token0 = token0;
        pool.token1 = token1;
        pool.splits = splits;
        PoolConstructor.constructPool(pool, blockTimestamp());
    }

    /**
     * @notice Sets the pool initial price and variance
     * @dev Initializes internal data structures depending on the pool price and variance
     * @param startPrice Initial Pool Price
     * @param quadVar0 Initial Pool Variance
     */
    function setInitialPriceAndVariance(Quad startPrice, Quad quadVar0) external {
        PoolConstructor.setInitialPriceAndVariance(pool, startPrice, quadVar0);
        emit PoolInitialized(startPrice, quadVar0, pool.twapSpread, pool.date);
    }

    /**
     * @notice Executes a token swap based on the provided parameters.
     * @dev This function handles the swapping of tokens based on specified input and output parameters.
     *      The `data` parameter can be used to pass arbitrary data to the function.
     * @param params A `SwapParams` struct containing:
     *      - `push`: Amount of input token.
     *      - `token`: Defines the tokenIn for the swap. False --> token0, True --> token1
     *      - `limitPrice`: A `LibOptQuad.Raw` struct containing
     *          - `val`: Value of the limit price for slippage protection.
     *      - `recipient`: Address where the `tokenOut` tokens should be sent.
     * @param data Arbitrary bytes data, used for callback.
     * @return amount0 The amount of token0 transferred in the swap. The convention is amount > 0 => user pays, amount < 0 => user receives.
     * @return amount1 The amount of token1 transferred in the swap. The convention is amount > 0 => user pays, amount < 0 => user receives.
     */
    function swap(Spot.SwapParams memory params, address receiver, bytes calldata data)
        external
        nonReentrant
        returns (int256 amount0, int256 amount1)
    {
        // advance() generates an event. We need the one after swap is done.
        // The backend can use the last event in a transaction but we want
        // to avoid unnecessary gas expenditure.
        // So we call Advance.advance directly instead.
        Advance.advance(pool, timestampDate(blockTimestamp()), false);
        UserPay.Info memory userPay = Spot.swap(pool, params);
        emit Advance.PoolPriceUpdated(Structs.PoolPriceInfo(pool.splits, pool.tickBin, pool.binFrac, NewLoan.quadVar(pool), pool.date));
        return userPay.makeUserPay(pool, receiver, data);
    }

    /**
     * @notice Executes a new loan based on the provided parameters
     * @dev This function handles the creation of a new loan based on the provided parameters.
     * @param params A `NewLoanParams` struct containing:
     *     - `recipient`: Address where the borrowed tokens are sent.
     *     - `owedPotential`: Array representing, for each bin involved in the loan, the target amount of liquidity the borrower owes to the protocol. The liquidity lent out is computed from that.
     *     - `startBin`: The leftmost lowest bin (the bin whose strike price is the lowest among the selected ones) for the loan. The end bin is determined by the owedPotential array length.
     *     - `strikeBin`: The strike bin for the loan. It determines the fixed price at which the borrowed liquidity can be swapped between token0 and token1. It has to be set to one of the bins chosen for the loan, usually it set to the middle bin.
     *     - `tokenMix`: has two different interpretations depending on whether TWAP is enabled. If TWAP is enabled, it is the fixed exposure level which the swapper will maintain (while TWAP is in effect), in token units - of whichever token the exposure is fixed for (as specified by the `token` argument). Without TWAP, tokenMix is the proportion of token 0 and 1 backing the swapper - a number between 0 and 1, where 0 means fully backed by token 0, and 1 fully backed by token 1.
     *     - `lockinEnd`: is the amount of time (in days) the periodic loan has to be held before being able to abandon it (so =0 for revolving loan, and =+Inf for fixed term loan). NOTE: This param is used in the `unwind()` function that is out of the audit scope.
     *     - `deadEra`: It define when the loan expires, if None, the loan is "perpetual" meaning it decays exponentially until numerically it becomes dust. Consequently, it is also the era up to which collateral will be provided to cover upcoming interest payments (None representing for all time up to +Inf).
     *     - `token`: Only used if TWAP is enabled, it defines the token to get exposure to according to `tokenMix` argument. False --> token0, True --> token1
     *     - `twapUntil`: A `OptInt256` struct representing an optional int256 that
     *         - if None, the TWAP is not active
     *         - if Some, the TWAP is active and the value represents the era at which the TWAP will be disabled.
     * @param data Arbitrary bytes data, used for callback.
     * @return swapperNum The number of the swapper created.
     * @return amount0 The amount of token0 transferred in the loan. The convention is amount > 0 => user pays, amount < 0 => user receives.
     * @return amount1 The amount of token0 transferred in the loan. The convention is amount > 0 => user pays, amount < 0 => user receives.
     */
    function newLoan(NewLoan.NewLoanParams memory params, bytes calldata data)
        external
        nonReentrant
        returns (uint256 swapperNum, int256 amount0, int256 amount1)
    {
        advance();
        NewLoan.NewLoanParams memory _params = params;
        UserPay.Info memory userPay = NewLoan.newLoan(pool, _params);

        swapperNum = pool.swappers.length - 1;
        (amount0, amount1) = userPay.makeUserPay(pool, data);
        emit Borrowed(
            msg.sender,
            swapperNum,
            _params.owedPotential,
            _params.startBin,
            _params.strikeBin,
            _params.tokenMix,
            _params.lockinEnd,
            _params.deadEra,
            _params.token,
            _params.twapUntil
        );
        emit SwapperCreated(swapperNum, pool.date, _params.tokenMix, pool.swappers[swapperNum]);
    }

    function unwind(uint256 swapperId, address receiver, bytes calldata data) external nonReentrant returns (int256 amount0, int256 amount1) {
        advance();
        UserPay.Info memory userPay = Swapper.unwind(pool.swappers[swapperId], pool);
        emit SwapperUnwind(swapperId, receiver, pool.date);
        return userPay.makeUserPay(pool, receiver, data);
    }

    /**
     * @notice Allows the trader to modify the exposure to tokens and to activate or deactivate the TWAP
     * @dev This function allows the trader to modify the desired exposure to tokens and performs quite significant changes into the internal accounting of the pool.
     * @param swapperId The Id of the swapper i.e. the leveraged position to modify.
     * @param tokenMix has two different interpretations depending on whether TWAP is enabled. If TWAP is enabled, it is the fixed exposure level which the swapper will maintain (while TWAP is in effect), in token units - of whichever token the exposure is fixed for (as specified by the `fixedToken` argument). Without TWAP, tokenMix is the proportion of token 0 and 1 backing the swapper - a number between 0 and 1, where 0 means fully backed by token 0, and 1 fully backed by token 1.
     * @param fixedToken Only used if TWAP is enabled, it defines the token to get exposure to according to `tokenMix` argument. False --> token0, True --> token1
     * @param twapUntil An optional int256 that
     *         - if None, the TWAP is not active
     *         - if Some, the TWAP is active and the value represents the era at which the TWAP will be disabled.
     * @param data Arbitrary bytes data, used for callback.
     * @return amount0 The amount of token0 transferred in the unwind. The convention is amount > 0 => user pays, amount < 0 => user receives.
     */
    function reflow(uint256 swapperId, Quad tokenMix, bool fixedToken, OptInt256 twapUntil, address receiver, bytes calldata data)
        external
        nonReentrant
        returns (int256, int256)
    {
        advance();
        UserPay.Info memory userPay = Swapper.reflow(pool.swappers[swapperId], pool, tokenMix, fixedToken, twapUntil);
        (int256 amount0, int256 amount1) = userPay.makeUserPay(pool, receiver, data);
        emit SwapperReflow(swapperId, tokenMix, fixedToken, twapUntil, receiver, amount0, amount1, pool.date);
        return (amount0, amount1);
    }

    /**
     * @notice Resets a swapper based on the provided parameters
     * @dev This function resets a swapper based on the provided parameters.
     * @param swapperId The number of the swapper to reset.
     * @param deadEra The era at which the swapper expires.
     * @param tokenMix has two different interpretations depending on whether TWAP is enabled. If TWAP is enabled, it is the fixed exposure level which the swapper will maintain (while TWAP is in effect), in token units - of whichever token the exposure is fixed for (as specified by the `fixedToken` argument). Without TWAP, tokenMix is the proportion of token 0 and 1 backing the swapper - a number between 0 and 1, where 0 means fully backed by token 0, and 1 fully backed by token 1.
     * @param fixedToken Only used if TWAP is enabled, it defines the token to get exposure to according to `tokenMix` argument. False --> token0, True --> token1
     * @param twapUntil An optional int256 that
     *         - if None, the TWAP is not active
     *         - if Some, the TWAP is active and the value represents the era at which the TWAP will be disabled.
     */
    function reset(uint256 swapperId, OptInt256 deadEra, Quad tokenMix, bool fixedToken, OptInt256 twapUntil, address receiver, bytes calldata data)
        external
        nonReentrant
        returns (int256, int256)
    {
        advance();
        UserPay.Info memory userPay = Swapper.reset(pool.swappers[swapperId], pool, deadEra, tokenMix, fixedToken, twapUntil);
        (int256 amount0, int256 amount1) = userPay.makeUserPay(pool, receiver, data);
        emit SwapperReset(swapperId, deadEra, tokenMix, fixedToken, twapUntil, receiver, amount0, amount1, pool.date);
        return (amount0, amount1);
    }

    /**
     *  This is a not view function. It updates some internal lazy data structures
     *  but does not materially change anything (i.e., liquidity, loans, etc).
     *  Therefore this function does not introduce any security risks.
     *  To save gas, one should call this function using callStatic.
     */
    function getPourQuantities(int256 startTub, int256 stopTub, Quad liquidity) external returns (int256, int256) {
        advance();
        UserPay.Info memory userPay = LP.getPourQuantities(pool, startTub, stopTub, liquidity);
        return UserPay.translateQuantities(userPay, pool);
    }

    /**
     * @notice Allows LPing to the pool
     * @dev This function handles the creation of a new non fungible LP position, not tokenized, based on the provided parameters.
     * @param startTub The starting tub of the range.
     * @param stopTub The ending tub of the range.
     * @param liquidity The amount of liquidity to be added to the pool.
     * @param data Arbitrary bytes data, used for callback.
     * @return lpNum The number of the LP position created.
     * @return token0 The amount of token0 transferred in the LP. The convention is amount > 0 => user pays, amount < 0 => user receives.
     * @return token1 The amount of token1 transferred in the LP. The convention is amount > 0 => user pays, amount < 0 => user receives.
     */
    function pour(int256 startTub, int256 stopTub, Quad liquidity, bytes calldata data)
        external
        nonReentrant
        returns (uint256 lpNum, int256 token0, int256 token1, int256 earnEra)
    {
        advance();
        UserPay.Info memory userPay = LP.pour(pool, startTub, stopTub, liquidity);
        (token0, token1) = userPay.makeUserPay(pool, data);
        lpNum = pool.lpCount - 1;
        emit LiquidityAdded(pool.lps[lpNum].owner, startTub, stopTub, liquidity, lpNum, token0, token1, pool.lps[lpNum].earnEra, pool.date);
        return (lpNum, token0, token1, pool.lps[lpNum].earnEra);
    }

    /**
     * @notice Gets the detail of an LP position.
     * @dev This function advances the pool to the current timestamp
     * @param lpNum The LP position number; it starts at 1.
     * @return lp the struct Structs.LiquidityPosition
     */
    function getLiquidityPosition(uint256 lpNum) public override returns (Structs.LiquidityPosition memory lp) {
        if (lpNum >= pool.lpCount) revert InvalidLPNumber();
        advance();
        return PoolReader.getLiquidityPosition(pool, lpNum);
    }

    /**
     * @notice Gets the count of LP positions.
     * @dev This function does NOT advance the pool to the current timestamp
     * @return count the number of LP positions.
     */
    function getLpCount() public view override returns (uint256) {
        return pool.lpCount;
    }

    /**
     * @notice Allows LPers to drain their LP position, removing liquidity from the pool
     * @dev This function allows LPers to drain their LP position, removing liquidity from the pool, but it is not an instantaneous process, it takes some time and during the draining time the LPers can call `collect()` to get the money that's made available.
     * @param lpNum The number of the LP position to drain.
     * @param receiver The address where the LP tokens will be sent.
     * @param data Arbitrary bytes data, used for callback.
     * @return amount0 The amount of token0 transferred in the drain. The convention is amount > 0 => user pays, amount < 0 => user receives.
     * @return amount1 The amount of token1 transferred in the drain. The convention is amount > 0 => user pays, amount < 0 => user receives.
     */
    function drain(uint256 lpNum, address receiver, bytes calldata data) external nonReentrant returns (int256 amount0, int256 amount1) {
        advance();
        UserPay.Info memory userPay = LP.drain(pool, lpNum);
        (amount0, amount1) = userPay.makeUserPay(pool, receiver, data);
        emit LiquidityDrained(lpNum, receiver, amount0, amount1, pool.date);
    }

    /**
     * @notice Allows LPs to collect the interests accrued from their LP positions and to drain it in case that process has started
     * @dev This function allows LPs to collect the interests accrued from their LP positions and in case the position is draining (see `drain()`) it also allows to collect the portion of liquidity made availably by that time.
     * @param lpNum The number of the LP position to collect.
     * @param receiver The address where the LP tokens will be sent.
     * @param data Arbitrary bytes data, used for callback.
     * @return amount0 The amount of token0 transferred in the collect. The convention is amount > 0 => user pays, amount < 0 => user receives.
     * @return amount1 The amount of token1 transferred in the collect. The convention is amount > 0 => user pays, amount < 0 => user receives.
     */
    function collect(uint256 lpNum, address receiver, bytes calldata data) external nonReentrant returns (int256 amount0, int256 amount1) {
        advance();
        UserPay.Info memory userPay = LP.collect(pool, lpNum);
        (amount0, amount1) = userPay.makeUserPay(pool, receiver, data);
        emit LiquidityCollected(lpNum, receiver, -amount0, -amount1, pool.date);
    }

    /**
     * @notice Allows LPers to tap their LP position to make interests available over time for the LPer to collect them
     * @dev This function is the one that makes the interests available over time for withdrawal with the `collect()` function.
     * @param lpNum The number of the LP position to tap.
     */
    function tap(uint256 lpNum) external {
        advance();
        LP.tap(pool, lpNum);
        emit LiquidityTapped(lpNum, pool.date);
    }

    /**
     * @notice Advances the pool accounting to the current timestamp
     * @dev This function advances the pool to the current timestamp
     */
    function advance() public {
        Advance.advance(pool, timestampDate(blockTimestamp()), true);
    }

    function collectNetted(address to, bytes memory data) public returns (int256 amount0, int256 amount1) {
        return CollectNetted.collectNetted(pool, to, data);
    }

    function getTubMinted(int256 tub) internal view returns (Quad) {
        return PoolReader.getTubMinted(pool, tub);
    }

    function getTubUtilization(int256 tub) internal returns (Quad) {
        return PoolReader.getTubUtilization(pool, tub);
    }

    function getSwappersCount() public view returns (uint256) {
        return pool.swappers.length;
    }

    /**
     * @dev This is to support getMarketLiquidity API.
     * @param startTub The starting tub [0, 4096)
     * @param stopTub The stopping tub (0, 4096]
     * @return info The Structs.LiquidityInfo struct that includes an array of Structs.TubLiquidityInfo
     */
    function getLiquidityInfo(int256 startTub, int256 stopTub) public returns (Structs.LiquidityInfo memory info) {
        advance();
        return PoolReader.getLiquidityInfo(pool, startTub, stopTub);
    }

    function blockTimestamp() internal view virtual returns (uint256) {
        return block.timestamp;
    }

    function getPoolInfo() public view returns (address, address, int256) {
        return (pool.token0, pool.token1, pool.splits);
    }

    function getPoolPriceInfo() public override returns (Structs.PoolPriceInfo memory) {
        advance();
        return Structs.PoolPriceInfo(pool.splits, pool.tickBin, pool.binFrac, NewLoan.quadVar(pool), pool.date);
    }

    function getSwapper(uint256 swapperId) public view returns (SwapperInternal.Info memory) {
        return pool.swappers[swapperId];
    }

    function doActions(Action[] calldata actions, bytes[] calldata actionDatas, address receiver, bytes calldata data)
        external
        returns (int256 amount0, int256 amount1)
    {
        advance();
        UserPay.Info memory finalUserPay;
        for (uint8 i; i < actions.length; i++) {
            Action action = actions[i];
            bytes memory actionData = actionDatas[i];
            UserPay.Info memory userPay;
            if (action == Action.SWAP) {
                Spot.SwapParams memory params = abi.decode(actionData, (Spot.SwapParams));
                userPay = Spot.swap(pool, params);
                emit Advance.PoolPriceUpdated(Structs.PoolPriceInfo(pool.splits, pool.tickBin, pool.binFrac, NewLoan.quadVar(pool), pool.date));
            } else if (action == Action.NEW_LOAN) {
                NewLoan.NewLoanParams memory params = abi.decode(actionData, (NewLoan.NewLoanParams));
                userPay = NewLoan.newLoan(pool, params);
                uint256 swapperNum = pool.swappers.length - 1;
                emit Borrowed(
                    msg.sender,
                    swapperNum,
                    params.owedPotential,
                    params.startBin,
                    params.strikeBin,
                    params.tokenMix,
                    params.lockinEnd,
                    params.deadEra,
                    params.token,
                    params.twapUntil
                );
                emit SwapperCreated(swapperNum, pool.date, params.tokenMix, pool.swappers[swapperNum]);
            } else if (action == Action.UNWIND) {
                uint256 swapperId = abi.decode(actionData, (uint256));
                userPay = Swapper.unwind(pool.swappers[swapperId], pool);
                emit SwapperUnwind(swapperId, msg.sender, pool.date);
            } else if (action == Action.REFLOW) {
                (uint256 swapperId, Quad tokenMix, bool fixedToken, OptInt256 twapUntil) = abi.decode(actionData, (uint256, Quad, bool, OptInt256));
                userPay = Swapper.reflow(pool.swappers[swapperId], pool, tokenMix, fixedToken, twapUntil);
                emit SwapperReflow(
                    swapperId, tokenMix, fixedToken, twapUntil, msg.sender, intoInt256(userPay.token0), intoInt256(userPay.token1), pool.date
                );
            } else if (action == Action.RESET) {
                (uint256 swapperId, OptInt256 deadEra, Quad tokenMix, bool fixedToken, OptInt256 twapUntil) =
                    abi.decode(actionData, (uint256, OptInt256, Quad, bool, OptInt256));
                userPay = Swapper.reset(pool.swappers[swapperId], pool, deadEra, tokenMix, fixedToken, twapUntil);
                emit SwapperReset(
                    swapperId, deadEra, tokenMix, fixedToken, twapUntil, msg.sender, intoInt256(userPay.token0), intoInt256(userPay.token1), pool.date
                );
            } else if (action == Action.POUR) {
                (int256 startTub, int256 stopTub, Quad liquidity) = abi.decode(actionData, (int256, int256, Quad));
                userPay = LP.pour(pool, startTub, stopTub, liquidity);

                uint256 lpNum = pool.lpCount - 1;
                emit LiquidityAdded(
                    pool.lps[lpNum].owner,
                    startTub,
                    stopTub,
                    liquidity,
                    lpNum,
                    intoInt256(userPay.token0),
                    intoInt256(userPay.token1),
                    pool.lps[lpNum].earnEra,
                    pool.date
                );
            } else if (action == Action.DRAIN) {
                uint256 lpNum = abi.decode(actionData, (uint256));
                userPay = LP.drain(pool, lpNum);
                emit LiquidityDrained(lpNum, msg.sender, intoInt256(userPay.token0), intoInt256(userPay.token1), pool.date);
            } else if (action == Action.COLLECT) {
                uint256 lpNum = abi.decode(actionData, (uint256));
                userPay = LP.collect(pool, lpNum);
                emit LiquidityCollected(lpNum, msg.sender, intoInt256(-userPay.token0), intoInt256(-userPay.token1), pool.date);
            } else if (action == Action.TAP) {
                uint256 lpNum = abi.decode(actionData, (uint256));
                LP.tap(pool, lpNum);
                emit LiquidityTapped(lpNum, pool.date);
            }

            finalUserPay.token0 = finalUserPay.token0 + userPay.token0;
            finalUserPay.token1 = finalUserPay.token1 + userPay.token1;
        }
        (amount0, amount1) = finalUserPay.makeUserPay(pool, receiver, data);
    }
}
