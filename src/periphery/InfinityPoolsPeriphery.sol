// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {IInfinityPoolFactory} from "src/interfaces/IInfinityPoolFactory.sol";
import {TUBS} from "src/Constants.sol";
import {IInfinityPoolsPeriphery} from "src/periphery/interfaces/IInfinityPoolsPeriphery.sol";
import {IInfinityPool} from "src/interfaces/IInfinityPool.sol";
import {Quad, fromUint256, fromInt256, POSITIVE_ONE, POSITIVE_ZERO} from "src/types/ABDKMathQuad/Quad.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {min} from "src/types/ABDKMathQuad/Math.sol";
import {lowEdgeTub} from "src/libraries/helpers/PoolHelper.sol";
import {Structs} from "src/libraries/external/Structs.sol";
import {IInfinityPoolPaymentCallback} from "src/interfaces/IInfinityPoolPaymentCallback.sol";
import {CallbackValidation} from "./libraries/CallbackValidation.sol";
import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {NewLoan} from "src/libraries/external/NewLoan.sol";
import {IPermit2} from "src/periphery/interfaces/external/IPermit2.sol";
import {GeneralSwapForwarder} from "src/periphery/swapForwarders/GeneralSwapForwarder.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";
import {EncodeIdHelper} from "./libraries/EncodeIdHelper.sol";
import {OptInt256} from "src/types/Optional/OptInt256.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {PeripheryActions} from "src/periphery/libraries/external/PeripheryActions.sol";
import {IInfinityPoolFactory} from "src/interfaces/IInfinityPoolFactory.sol";
import {ISwapForwarder} from "src/periphery/interfaces/ISwapForwarder.sol";

import {PeripheryPayment} from "src/periphery/PeripheryPayment.sol";

contract InfinityPoolsPeriphery is UUPSUpgradeable, ERC721Upgradeable, PeripheryPayment, IInfinityPoolsPeriphery, IInfinityPoolPaymentCallback {
    using SafeCast for int256;

    error InvalidFundsSpent();
    error Unauthorized();
    error IdenticalTokens();
    error InvalidPoolAddress();
    error InvalidTokenAddress();
    error NotEnoughCollateral(int256 net0, int256 net1);
    error InvalidID();
    error InvalidTokenOrder();
    error CallerNotApproved();
    error InvalidPaymentType();
    error PoolAddressIsNotTheSame();
    error OwnerIsNotTheSame();
    error PositionTypeIsNotTheSame();
    error InvalidSwapForwarder();

    /**
     * EVENTS *
     */
    // N.B. poolDate not needed here. We already emit one in IInfinityPool.LiquidityAdded
    event LiquidityAdded(address indexed user, address indexed pool, uint256 indexed lpNum, int256 amount0, int256 amount1, int256 earnEra);

    event SpotSwap(
        address fromToken, uint256 fromTokenAmount, uint256 fromTokenReceived, address toToken, uint256 toTokenAmount, uint256 toTokenReceived
    );

    GeneralSwapForwarder public immutable generalSwapForwarder = new GeneralSwapForwarder();

    function _authorizeUpgrade(address) internal view override {
        if (msg.sender != IInfinityPoolFactory(factory).owner()) revert Unauthorized();
    }

    function initialize(address _factory, address _WETH9, IPermit2 permit2) public initializer {
        factory = _factory;
        WETH9 = _WETH9;
        __Vault_init(permit2);
        __ERC721_init("InfinityPoolsPeriphery", "IPP");

        swapForwarders[address(generalSwapForwarder)] = true;
    }

    function addOrRemoveSwapForwarder(address swapForwarder, bool addOrRemove) external {
        if (msg.sender != IInfinityPoolFactory(factory).owner()) revert Unauthorized();
        swapForwarders[swapForwarder] = addOrRemove;
    }

    /*
     * @param tokenA address of tokenA
     * @param tokenB address of tokenB
     * @param splits the splits
     * @return (poolAddress, token0, token1)
     */
    function getPoolAddress(address tokenA, address tokenB, int256 splits) public view override returns (address, address, address) {
        if (tokenA == tokenB) revert IdenticalTokens();
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        if (token0 == address(0)) revert InvalidTokenAddress();
        address poolAddress = IInfinityPoolFactory(factory).getPool(token0, token1, splits);
        if (poolAddress == address(0)) revert InvalidPoolAddress();
        return (poolAddress, token0, token1);
    }

    //TODO: change pour userPay to callback style so that it is not taking token from periphery contract
    /**
     *  requires token0 < token1
     */
    function addLiquidity(IInfinityPoolsPeriphery.AddLiquidityParams memory params) external payable {
        /// @custom:oz-upgrades-unsafe-allow external-library-linking
        uint256 tokenIdToMint = PeripheryActions.addLiquidity(factory, params);
        _mint(msg.sender, tokenIdToMint);
    }

    function handleSwap(
        IERC20 fromToken,
        uint256 fromTokenAmount,
        IERC20 toToken,
        uint256 toTokenAmount,
        bool shouldExactOutput,
        SwapInfo memory swapInfo
    ) internal returns (uint256 fromTokenReceived, uint256 toTokenReceived) {
        if (swapInfo.swapForwarder != address(0)) {
            if (!swapForwarders[swapInfo.swapForwarder]) revert InvalidSwapForwarder();

            SafeERC20.safeTransfer(fromToken, swapInfo.swapForwarder, fromTokenAmount);

            uint256 fromTokenBalanceBefore = fromToken.balanceOf(address(this));
            uint256 toTokenBalanceBefore = toToken.balanceOf(address(this));

            if (shouldExactOutput && ISwapForwarder(swapInfo.swapForwarder).exactOutputSupported()) {
                ISwapForwarder(swapInfo.swapForwarder).swapExactOutput(
                    fromToken, swapInfo.tokenInSpender, fromTokenAmount, toToken, toTokenAmount, swapInfo.to, swapInfo.data
                );
            } else {
                ISwapForwarder(swapInfo.swapForwarder).swapExactInput(
                    fromToken, swapInfo.tokenInSpender, fromTokenAmount, toToken, toTokenAmount, swapInfo.to, swapInfo.data
                );
            }
            fromTokenReceived = fromToken.balanceOf(address(this)) - fromTokenBalanceBefore;
            toTokenReceived = toToken.balanceOf(address(this)) - toTokenBalanceBefore;
            emit SpotSwap(address(fromToken), fromTokenAmount, fromTokenReceived, address(toToken), toTokenAmount, toTokenReceived);
        }
    }

    function infinityPoolPaymentCallback(int256 amount0, int256 amount1, bytes calldata _data) external {
        CallbackData memory data = abi.decode(_data, (CallbackData));
        //msg.sender = pool contract
        CallbackValidation.verifyCallback(factory, data.token0, data.token1, data.splits);

        if (data.paymentType == PaymentType.COLLATERAL_SWAP) {
            int256 collateral0 = collaterals[data.payer][data.token0][data.token1][false];
            int256 collateral1 = collaterals[data.payer][data.token0][data.token1][true];

            int256 net0 = collateral0 - amount0;
            int256 net1 = collateral1 - amount1;

            if (net0 < 0) {
                // token1 to token0
                if (net1 <= 0) revert NotEnoughCollateral(net0, net1);
                SwapInfo memory swap = abi.decode(data.extraData, (SwapInfo));
                (uint256 token1Received, uint256 token0Received) =
                    handleSwap(IERC20(data.token1), uint256(net1), IERC20(data.token0), uint256(-net0), true, swap);
                net0 += int256(token0Received);
                net1 = int256(token1Received); //direct assignment since all net1 to taken to handleSwap so it is 0 + token1Received
            } else if (net1 < 0) {
                // token0 to token1
                if (net0 <= 0) revert NotEnoughCollateral(net0, net1);
                SwapInfo memory swap = abi.decode(data.extraData, (SwapInfo));
                (uint256 token0Received, uint256 token1Received) =
                    handleSwap(IERC20(data.token0), uint256(net0), IERC20(data.token1), uint256(-net1), true, swap);
                net0 = int256(token0Received); //direct assignment since all net0 to taken to handleSwap so it is 0 + token0Received
                net1 += int256(token1Received);
            }

            if (net0 < 0 || net1 < 0) revert InvalidFundsSpent();

            int256 collateralUsed0 = collateral0 - net0;
            int256 collateralUsed1 = collateral1 - net1;

            if (collateralUsed0 > 0) {
                if (data.caller != data.payer) if (!isApprovedForAll(data.payer, data.caller)) revert CallerNotApproved();
                _decreaseCollateral(data.token0, data.token1, IERC20(data.token0), data.payer, uint256(collateralUsed0));
            } else if (collateralUsed0 < 0) {
                _increaseCollateral(data.token0, data.token1, IERC20(data.token0), data.payer, uint256(-collateralUsed0));
            }

            if (collateralUsed1 > 0) {
                if (data.caller != data.payer) if (!isApprovedForAll(data.payer, data.caller)) revert CallerNotApproved();
                _decreaseCollateral(data.token0, data.token1, IERC20(data.token1), data.payer, uint256(collateralUsed1));
            } else if (collateralUsed1 < 0) {
                _increaseCollateral(data.token0, data.token1, IERC20(data.token1), data.payer, uint256(-collateralUsed1));
            }

            // msg.sender = pool, send funds to pool to fit user pay
            if (amount0 > 0) SafeERC20.safeTransfer(IERC20(data.token0), msg.sender, uint256(amount0));
            if (amount1 > 0) SafeERC20.safeTransfer(IERC20(data.token1), msg.sender, uint256(amount1));
        } else if (data.paymentType == PaymentType.WALLET) {
            //negative amount has already been paid
            if (amount0 > 0) pay(IERC20(data.token0), data.payer, msg.sender, uint256(amount0));
            if (amount1 > 0) pay(IERC20(data.token1), data.payer, msg.sender, uint256(amount1));
        } else {
            revert InvalidPaymentType();
        }
    }

    struct SwapInfo {
        address swapForwarder;
        address tokenInSpender;
        address to;
        bytes data;
    }

    function newLoan(address token0, address token1, int256 splits, address onBehalfOf, SwapInfo calldata swap, NewLoan.NewLoanParams calldata params)
        public
    {
        if (token0 >= token1) revert InvalidTokenOrder();
        address spender = msg.sender;

        if (spender != onBehalfOf) if (!isApprovedForAll(onBehalfOf, spender)) revert CallerNotApproved();
        address poolAddress = IInfinityPoolFactory(factory).getPool(token0, token1, splits);
        if (poolAddress == address(0)) revert InvalidPoolAddress();
        IInfinityPool infPool = IInfinityPool(poolAddress);
        CallbackData memory callbackData = CallbackData({
            token0: token0,
            token1: token1,
            splits: splits,
            caller: msg.sender,
            payer: onBehalfOf,
            paymentType: PaymentType.COLLATERAL_SWAP,
            extraData: abi.encode(swap)
        });

        (uint256 swapperNum,,) = infPool.newLoan(params, abi.encode(callbackData));
        _mint(onBehalfOf, EncodeIdHelper.encodeId(EncodeIdHelper.PositionType.Swapper, poolAddress, uint88(swapperNum)));
    }

    struct BatchActionLocalVars {
        uint256 length;
        IInfinityPool.Action[] actions;
        bytes[] actionDatas;
        address owner;
    }

    function batchActionsOnSwappers(
        uint256[] calldata unwindTokenIds,
        ReflowParams[] calldata reflowParams,
        NewLoan.NewLoanParams[] calldata newLoanParams,
        SwapInfo calldata swap
    ) public {
        BatchActionLocalVars memory vars;
        vars.length = unwindTokenIds.length + reflowParams.length + newLoanParams.length;

        vars.actions = new IInfinityPool.Action[](vars.length);
        uint256 tokenId = unwindTokenIds.length != 0 ? unwindTokenIds[0] : reflowParams[0].tokenId;
        vars.owner = _ownerOf(tokenId);

        (address poolAddress,, CallbackData memory callbackData) = _handleSwapper(tokenId, swap);

        vars.actionDatas = new bytes[](vars.length);
        for (uint256 i; i < unwindTokenIds.length; i++) {
            uint256 unwindTokenId = unwindTokenIds[i];
            vars.actions[i] = IInfinityPool.Action.UNWIND;
            (EncodeIdHelper.PositionType positionType, address _poolAddress, uint256 swapperNum) = EncodeIdHelper.decodeId(unwindTokenId);
            if (poolAddress != _poolAddress) revert PoolAddressIsNotTheSame();
            if (ownerOf(unwindTokenId) != vars.owner) revert OwnerIsNotTheSame();
            if (positionType != EncodeIdHelper.PositionType.Swapper) revert PositionTypeIsNotTheSame();
            vars.actionDatas[i] = abi.encode(swapperNum);
        }

        for (uint256 i; i < reflowParams.length; i++) {
            uint256 offsetIdx = i + unwindTokenIds.length;
            vars.actions[offsetIdx] = IInfinityPool.Action.REFLOW;
            uint256 resetTokenId = reflowParams[i].tokenId;
            (EncodeIdHelper.PositionType positionType, address _poolAddress, uint256 swapperNum) = EncodeIdHelper.decodeId(resetTokenId);
            ReflowParams calldata reflowParam = reflowParams[i];
            if (poolAddress != _poolAddress) revert PoolAddressIsNotTheSame();
            if (ownerOf(resetTokenId) != vars.owner) revert OwnerIsNotTheSame();
            if (positionType != EncodeIdHelper.PositionType.Swapper) revert PositionTypeIsNotTheSame();
            vars.actionDatas[offsetIdx] = abi.encode(swapperNum, reflowParam.tokenMix, reflowParam.fixedToken, reflowParam.twapUntil);
        }

        for (uint256 i; i < newLoanParams.length; i++) {
            uint256 offsetIdx = i + reflowParams.length + unwindTokenIds.length;
            vars.actions[offsetIdx] = IInfinityPool.Action.NEW_LOAN;
            vars.actionDatas[offsetIdx] = abi.encode(newLoanParams[i]);
        }

        IInfinityPool(poolAddress).doActions(vars.actions, vars.actionDatas, address(this), abi.encode(callbackData));

        uint256 swappersCount = IInfinityPool(poolAddress).getSwappersCount();
        for (uint256 i; i < newLoanParams.length; i++) {
            _mint(vars.owner, EncodeIdHelper.encodeId(EncodeIdHelper.PositionType.Swapper, poolAddress, uint88(swappersCount - 1 - i)));
        }
    }

    function _handleSwapper(uint256 tokenId, SwapInfo calldata swap)
        internal
        returns (address poolAddress, uint256 swapperNum, CallbackData memory callbackData)
    {
        EncodeIdHelper.PositionType positionType;
        (positionType, poolAddress, swapperNum) = EncodeIdHelper.decodeId(tokenId);
        if (positionType != EncodeIdHelper.PositionType.Swapper) revert InvalidID();
        if (!_isAuthorized(_requireOwned(tokenId), msg.sender, tokenId)) revert CallerNotApproved();

        (address token0, address token1, int256 splits) = IInfinityPool(poolAddress).getPoolInfo();
        callbackData = CallbackData({
            token0: token0,
            token1: token1,
            splits: splits,
            caller: msg.sender,
            payer: ownerOf(tokenId),
            paymentType: PaymentType.COLLATERAL_SWAP,
            extraData: abi.encode(swap)
        });
    }

    function unwind(uint256 tokenId, SwapInfo calldata swap) public returns (int256 amount0, int256 amount1) {
        (address poolAddress, uint256 swapperNum, CallbackData memory callbackData) = _handleSwapper(tokenId, swap);
        return IInfinityPool(poolAddress).unwind(swapperNum, address(this), abi.encode(callbackData));
    }

    struct ResetParams {
        uint256 tokenId;
        int256 deadEra;
        Quad tokenMix;
        bool fixedToken;
        int256 twapUntil;
    }

    function reset(ResetParams memory params, SwapInfo calldata swap) public returns (int256 amount0, int256 amount1) {
        (address poolAddress, uint256 swapperNum, CallbackData memory callbackData) = _handleSwapper(params.tokenId, swap);

        return IInfinityPool(poolAddress).reset(
            swapperNum,
            OptInt256.wrap(params.deadEra),
            params.tokenMix,
            params.fixedToken,
            OptInt256.wrap(params.twapUntil),
            address(this),
            abi.encode(callbackData)
        );
    }

    struct ReflowParams {
        uint256 tokenId;
        Quad tokenMix;
        bool fixedToken;
        int256 twapUntil;
    }

    function reflow(ReflowParams memory params, SwapInfo calldata swap) public returns (int256 amount0, int256 amount1) {
        (address poolAddress, uint256 swapperNum, CallbackData memory callbackData) = _handleSwapper(params.tokenId, swap);

        return IInfinityPool(poolAddress).reflow(
            swapperNum, params.tokenMix, params.fixedToken, OptInt256.wrap(params.twapUntil), address(this), abi.encode(callbackData)
        );
    }

    function drain(uint256 tokenId, address receiver) public returns (int256 amount0, int256 amount1) {
        (EncodeIdHelper.PositionType positionType, address poolAddress, uint256 lpNum) = EncodeIdHelper.decodeId(tokenId);
        if (positionType != EncodeIdHelper.PositionType.LP) revert InvalidID();
        if (!_isAuthorized(_requireOwned(tokenId), msg.sender, tokenId)) revert CallerNotApproved();

        return IInfinityPool(poolAddress).drain(lpNum, receiver, "");
    }

    function collect(uint256 tokenId, address receiver) public returns (int256 amount0, int256 amount1) {
        (EncodeIdHelper.PositionType positionType, address poolAddress, uint256 lpNum) = EncodeIdHelper.decodeId(tokenId);
        if (positionType != EncodeIdHelper.PositionType.LP) revert InvalidID();
        if (!_isAuthorized(_requireOwned(tokenId), msg.sender, tokenId)) revert CallerNotApproved();

        return IInfinityPool(poolAddress).collect(lpNum, receiver, "");
    }

    function tap(uint256 tokenId) public {
        (EncodeIdHelper.PositionType positionType, address poolAddress, uint256 lpNum) = EncodeIdHelper.decodeId(tokenId);
        if (positionType != EncodeIdHelper.PositionType.LP) revert InvalidID();

        return IInfinityPool(poolAddress).tap(lpNum);
    }

    function encodeId(EncodeIdHelper.PositionType enumValue, address poolAddress, uint88 lpOrSwapperNumber) public pure returns (uint256) {
        return EncodeIdHelper.encodeId(enumValue, poolAddress, lpOrSwapperNumber);
    }

    function withdrawAllCollaterals(address tokenA, address tokenB, address user) external {
        if (user != msg.sender) if (!isApprovedForAll(user, msg.sender)) revert CallerNotApproved();
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

        int256 collateral0 = collaterals[user][token0][token1][false];
        int256 collateral1 = collaterals[user][token0][token1][true];
        if (collateral0 > 0) {
            uint256 collateral0Unsigned = uint256(collateral0);
            _decreaseCollateral(token0, token1, IERC20(token0), user, collateral0Unsigned);
            _depositERC20(token0, user, collateral0Unsigned);
        }
        if (collateral1 > 0) {
            uint256 collateral1Unsigned = uint256(collateral1);
            _decreaseCollateral(token0, token1, IERC20(token1), user, collateral1Unsigned);
            _depositERC20(token1, user, collateral1Unsigned);
        }
    }

    // the NFT image will be fetched from below baseURI
    function _baseURI() internal pure override returns (string memory) {
        return "https://infinitypools.finance/nftInfo/";
    }
}
