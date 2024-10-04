// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {POSITIVE_INFINITY, POSITIVE_ZERO, Quad, LibOptQuad, fromInt256, fromUint256} from "src/types/ABDKMathQuad/Quad.sol";
import {InfinityPoolsFactory} from "src/InfinityPoolsFactory.sol";
import {InfinityPool} from "src/InfinityPool.sol";
import {Token} from "src/mock/Token.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {TUBS} from "src/Constants.sol";
import {Spot} from "src/libraries/external/Spot.sol";
import {LP} from "src/libraries/external/LP.sol";
import {Structs} from "src/libraries/external/Structs.sol";
import {NewLoan} from "src/libraries/external/NewLoan.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {OPT_INT256_NONE, OptInt256} from "src/types/Optional/OptInt256.sol";

contract InfinityPoolTest is Test {
    InfinityPool infinityPool;
    Token token0;
    Token token1;

    event Borrowed(
        address indexed user,
        uint256 indexed swapperNum,
        Quad[] owedPotential,
        int256 startBin,
        int256 strikeBin,
        Quad tokenMix,
        Quad lockinEnd,
        OptInt256 deadEra,
        bool token,
        OptInt256 twapUntil
    );

    function setUp() public {
        //necessary for the timestamp to be greater than 1735740000 as that is the "start time" of the pool
        vm.warp(1735740000 + 2 days);
        token0 = new Token("Token0", "TOK0", 18);
        token1 = new Token("Token1", "TOK1", 18);

        token0.mint(address(this), 100 ether);
        token1.mint(address(this), 100 ether);

        InfinityPoolsFactory factory = new InfinityPoolsFactory();
        factory.createPool(address(token0), address(token1), 15);
        address pool = factory.getPool(address(token0), address(token1), 15);
        assertTrue(pool != address(0));

        infinityPool = InfinityPool(pool);

        Quad startPrice = fromUint256(1);
        Quad quadVar = fromUint256(1);
        infinityPool.setInitialPriceAndVariance(startPrice, quadVar);

        token0.approve(address(infinityPool), 1000 ether);
        token1.approve(address(infinityPool), 1000 ether);
    }

    function test_Pour() public {
        Quad liquidity = fromUint256(1000);

        console2.log("block.timestamp", block.timestamp);

        vm.warp(block.timestamp + 1 minutes);
        infinityPool.pour(0, TUBS, liquidity, "");

        console2.log("token0 balance of pool", token0.balanceOf(address(infinityPool)));
        console2.log("token1 balance of pool", token1.balanceOf(address(infinityPool)));
    }

    function test_Pour_1() public {
        Quad liquidity = fromUint256(1000);

        console2.log("block.timestamp", block.timestamp);

        vm.warp(block.timestamp + 1 minutes);
        (uint256 lpNum, int256 token0Amount, int256 token1Amount,) = infinityPool.pour(10, 11, liquidity, "");

        //we know both amounts should be positive as pour requires user to pay
        (address token0, address token1,) = infinityPool.getPoolInfo();
        assertEq(IERC20(token0).balanceOf(address(infinityPool)), uint256(token0Amount));
        assertEq(IERC20(token1).balanceOf(address(infinityPool)), uint256(token1Amount));
    }

    function test_Advance() public {
        vm.warp(block.timestamp + 12 seconds);
        infinityPool.advance();
    }

    function test_pour_tap_collect_1() public {
        uint256 baseTimestamp = block.timestamp + 1 days;
        vm.warp(baseTimestamp);
        Quad liquidity = fromUint256(1000);
        infinityPool.pour(0, TUBS, liquidity, "");
        vm.warp(baseTimestamp + 100 days);
        infinityPool.advance();
        infinityPool.tap(0);
        int256 earnedToken0;
        int256 earnedToken1;

        (earnedToken0, earnedToken1) = infinityPool.collect(0, address(this), "");
        assertTrue(earnedToken0 >= 0);
        assertTrue(earnedToken1 >= 0);
    }

    function test_drain_dollect_should_revert_if_not_owner() public {
        uint256 baseTimestamp = block.timestamp + 1 days;
        vm.warp(baseTimestamp);
        Quad liquidity = fromUint256(1000);
        infinityPool.pour(0, TUBS, liquidity, "");
        vm.warp(baseTimestamp + 100 days);
        infinityPool.advance();
        infinityPool.tap(0);

        vm.startPrank(address(0xabc));
        vm.expectRevert(LP.OnlyOwnerAllowed.selector);
        infinityPool.collect(0, address(this), "");

        vm.expectRevert(LP.OnlyOwnerAllowed.selector);
        infinityPool.drain(0, address(this), "");
        vm.stopPrank();
    }

    function checkGetLiquidityPositionIdempotency(uint256 lpNum, Structs.LiquidityPosition memory expected) public {
        Structs.LiquidityPosition memory lp2 = infinityPool.getLiquidityPosition(lpNum);
        assertEq(lp2.lpNum, expected.lpNum);
        assertEq(lp2.token0, expected.token0);
        assertEq(lp2.token1, expected.token1);
        assertEq(lp2.lowerEdge, expected.lowerEdge);
        assertEq(lp2.upperEdge, expected.upperEdge);
        assertEq(lp2.earnEra, expected.earnEra);
        assertEq(lp2.lockedAmount0, expected.lockedAmount0);
        assertEq(lp2.lockedAmount1, expected.lockedAmount1);
        assertEq(lp2.availableAmount0, expected.availableAmount0);
        assertEq(lp2.availableAmount1, expected.availableAmount1);
        assertEq(lp2.unclaimedFees0, expected.unclaimedFees0);
        assertEq(lp2.unclaimedFees1, expected.unclaimedFees1);
        assertEq(lp2.state, expected.state);
    }

    function test_get_liquidity_position() public {
        uint256 baseTimestamp = block.timestamp + 1 days;
        vm.warp(baseTimestamp);
        Quad liquidity = fromUint256(1000);
        (uint256 lpNum, int256 amount0, int256 amount1,) = infinityPool.pour(0, TUBS, liquidity, "");

        Structs.LiquidityPosition memory lp;
        lp = infinityPool.getLiquidityPosition(lpNum);
        checkGetLiquidityPositionIdempotency(lpNum, lp);
        assertEq(lp.lpNum, lpNum);
        assertEq(lp.state, Structs.LP_STATE_OPENED);
        if (address(token0) < address(token1)) {
            assertEq(lp.token0, address(token0));
            assertEq(lp.token1, address(token1));
        } else {
            assertEq(lp.token1, address(token0));
            assertEq(lp.token0, address(token1));
        }
        assertEq(lp.lowerEdge, -TUBS / 2);
        assertEq(lp.upperEdge, TUBS / 2);
        assertEq(lp.unclaimedFees0, 0);
        assertEq(lp.unclaimedFees1, 0);
        assertEq(lp.availableAmount0, 0);
        assertEq(lp.availableAmount1, 0);
        assertTrue(fromInt256(lp.lockedAmount0 - amount0).abs() <= fromUint256(1));
        assertTrue(fromInt256(lp.lockedAmount1 - amount1).abs() <= fromUint256(1));

        vm.warp(baseTimestamp + 100 days);
        lp = infinityPool.getLiquidityPosition(lpNum);
        checkGetLiquidityPositionIdempotency(lpNum, lp);
        assertEq(lp.state, Structs.LP_STATE_OPENED); // no tap yet. so still the same
        assertEq(lp.unclaimedFees0, 0);
        assertEq(lp.unclaimedFees1, 0);
        assertEq(lp.availableAmount0, 0);
        assertEq(lp.availableAmount1, 0);
        assertTrue(fromInt256(lp.lockedAmount0 - amount0).abs() <= fromUint256(1));
        assertTrue(fromInt256(lp.lockedAmount1 - amount1).abs() <= fromUint256(1));

        infinityPool.tap(0);

        lp = infinityPool.getLiquidityPosition(lpNum);
        checkGetLiquidityPositionIdempotency(lpNum, lp);
        assertEq(lp.state, Structs.LP_STATE_ACTIVE);
        assertTrue(lp.unclaimedFees0 == 0); // no loans yet
        assertTrue(lp.unclaimedFees1 == 0); // no loans yet
        assertEq(lp.availableAmount0, 0);
        assertEq(lp.availableAmount1, 0);
        assertTrue(fromInt256(lp.lockedAmount0 - amount0).abs() <= fromUint256(1));
        assertTrue(fromInt256(lp.lockedAmount1 - amount1).abs() <= fromUint256(1));

        // now we make a loan
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15825, // startBin
            strikeBin: 15825, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        (uint256 swapperNum, int256 loaned0, int256 loaned1) = infinityPool.newLoan(params, "");

        vm.warp(baseTimestamp + 200 days);
        lp = infinityPool.getLiquidityPosition(lpNum);
        checkGetLiquidityPositionIdempotency(lpNum, lp);
        assertEq(lp.state, Structs.LP_STATE_ACTIVE);
        assertTrue(lp.unclaimedFees0 > 0); // no loans yet
        assertTrue(lp.unclaimedFees1 > 0); // no loans yet
        assertEq(lp.availableAmount0, 0);
        assertEq(lp.availableAmount1, 0);
        assertTrue(lp.lockedAmount0 > amount0); // due to the loan?
        assertTrue(lp.lockedAmount1 < amount1); // due to the loan?

        // TODO: add position closure test
    }

    function test_newLoan_emit_borrowed() public {
        uint256 baseTimestamp = block.timestamp + 1 days;
        vm.warp(baseTimestamp);
        Quad liquidity = fromUint256(1000);
        (uint256 lpNum, int256 amount0, int256 amount1,) = infinityPool.pour(0, TUBS, liquidity, "");
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15825, // startBin
            strikeBin: 15825, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        vm.expectEmit(true, true, true, true);
        emit Borrowed(
            address(this),
            0,
            owedPotential,
            15825,
            15825,
            POSITIVE_ZERO,
            POSITIVE_INFINITY,
            OptInt256.wrap(OPT_INT256_NONE),
            false,
            OptInt256.wrap(OPT_INT256_NONE)
        );
        infinityPool.newLoan(params, "");
        vm.expectEmit(true, true, true, true);
        emit Borrowed(
            address(this),
            1,
            owedPotential,
            15825,
            15825,
            POSITIVE_ZERO,
            POSITIVE_INFINITY,
            OptInt256.wrap(OPT_INT256_NONE),
            false,
            OptInt256.wrap(OPT_INT256_NONE)
        );
        infinityPool.newLoan(params, "");
    }
}
