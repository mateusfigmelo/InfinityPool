const { expect } = require("chai");
const { BigNumber } = require("@ethersproject/bignumber");
const ZERO_BYTES16 = "0x00000000000000000000000000000000";
const bscPancakeRouterV2Address = "0x10ED43C718714eb63d5aA57B78B54704E256024E";

describe("Test InfinityPoolsPeriphery", function () {
    const splits = 15;
    const Z = false;
    const I = true;
    let deployer;
    let user;
    let token0;
    let token1;
    let tokenC;
    let infinityPool;
    let periphery;
    let infinityPoolsFactory;

    beforeEach(async function () {
        let signers = await hre.ethers.getSigners();
        deployer = signers[0];
        user = signers[1];
        const Token = await hre.ethers.getContractFactory("Token");
        const WETH9 = await hre.ethers.getContractFactory("WETH9");
        const tokenA = await Token.deploy("TokenA", "TA", 18);
        const tokenB = await Token.deploy("TokenB", "TB", 18);
        tokenC = await Token.deploy("TokenC", "TC", 18);
        const weth9 = await WETH9.deploy();

        [token0, token1] = (BigNumber.from(tokenA.target).lt(BigNumber.from(tokenB.target))) ? [tokenA, tokenB] : [tokenB, tokenA];


        const piecewiseGrowthNew = await hre.ethers.deployContract("PiecewiseGrowthNew");
        const growthSplitFrame = await hre.ethers.deployContract("GrowthSplitFrame", { libraries: { PiecewiseGrowthNew: piecewiseGrowthNew.target } });
        const jumpyAnchorFaber = await hre.ethers.deployContract("JumpyAnchorFaber");
        const jumpyFallback = await hre.ethers.deployContract("JumpyFallback");

        const gapStagedFrame = await hre.ethers.deployContract("GapStagedFrame", { libraries: { JumpyFallback: jumpyFallback.target, JumpyAnchorFaber: jumpyAnchorFaber.target, GrowthSplitFrame: growthSplitFrame } });
        const eachPayoff = await hre.ethers.deployContract("EachPayoff", { libraries: { GapStagedFrame: gapStagedFrame.target, GrowthSplitFrame: growthSplitFrame.target } });
        const eraBoxcarMidSum = await hre.ethers.deployContract("EraBoxcarMidSum");
        const spot = await hre.ethers.deployContract("Spot", { libraries: { GrowthSplitFrame: growthSplitFrame.target, EachPayoff: eachPayoff.target } });
        const subAdvanceHelpers = await hre.ethers.deployContract("SubAdvanceHelpers", { libraries: { GrowthSplitFrame: growthSplitFrame.target, EachPayoff: eachPayoff.target } });
        const subAdvance = await hre.ethers.deployContract("SubAdvance", { libraries: { GrowthSplitFrame: growthSplitFrame.target, EraBoxcarMidSum: eraBoxcarMidSum.target, SubAdvanceHelpers: subAdvanceHelpers.target, EachPayoff: eachPayoff.target, JumpyAnchorFaber: jumpyAnchorFaber.target, Spot: spot.target } });
        const advance = await hre.ethers.deployContract("Advance", { libraries: { EachPayoff: eachPayoff.target, SubAdvance: subAdvance.target, JumpyAnchorFaber: jumpyAnchorFaber.target, JumpyFallback: jumpyFallback.target, Spot: spot.target } });

        const lpShed = await hre.ethers.deployContract("LPShed");
        const lp = await hre.ethers.deployContract("LP", { libraries: { LPShed: lpShed.target, GrowthSplitFrame: growthSplitFrame.target, EachPayoff: eachPayoff.target, JumpyAnchorFaber: jumpyAnchorFaber.target, JumpyFallback: jumpyFallback.target, GapStagedFrame: gapStagedFrame.target } });
        const anyPayoff = await hre.ethers.deployContract("AnyPayoff", { libraries: { EraBoxcarMidSum: eraBoxcarMidSum.target } });
        const swapperInternal = await hre.ethers.deployContract("SwapperInternal", { libraries: { GapStagedFrame: gapStagedFrame.target, GrowthSplitFrame: growthSplitFrame.target, JumpyAnchorFaber: jumpyAnchorFaber.target, JumpyFallback: jumpyFallback.target, AnyPayoff: anyPayoff.target } });
        const swapper = await hre.ethers.deployContract("Swapper", { libraries: { SwapperInternal: swapperInternal.target } });
        const newLoan = await hre.ethers.deployContract("NewLoan", { libraries: { Swapper: swapper.target, SwapperInternal: swapperInternal.target } });
        const userPay = await ethers.deployContract("UserPay");

        const poolReader = await hre.ethers.deployContract("PoolReader", { libraries: { LP: lp.target, LPShed: lpShed.target, GrowthSplitFrame: growthSplitFrame.target } });
        const poolConstructor = await hre.ethers.deployContract("PoolConstructor", { libraries: { EraBoxcarMidSum: eraBoxcarMidSum, JumpyAnchorFaber: jumpyAnchorFaber, GrowthSplitFrame: growthSplitFrame } });
        const collectNetted = await hre.ethers.deployContract("CollectNetted", { libraries: { Advance: advance.target, UserPay: userPay.target } });

        infinityPoolsFactory = await hre.ethers.deployContract("InfinityPoolsFactory", {
            libraries: {
                NewLoan: newLoan.target,
                Spot: spot.target,
                Advance: advance.target,
                LP: lp.target,
                Swapper: swapper.target,
                UserPay: userPay.target,
                PoolReader: poolReader.target,
                PoolConstructor: poolConstructor.target,
                CollectNetted: collectNetted.target

            }
        });


        await infinityPoolsFactory.createPool(token0.target, token1.target, splits);
        poolAddress = await infinityPoolsFactory.getPool(token0.target, token1.target, splits);
        infinityPool = await hre.ethers.getContractAt("InfinityPool", poolAddress);

        const peripheryActions = await hre.ethers.deployContract("PeripheryActions");
        const permit2Address = "0x000000000022d473030f116ddee9f6b43ac78ba3";
        const InfinityPoolsPeriphery = await hre.ethers.getContractFactory("InfinityPoolsPeriphery", { libraries: { PeripheryActions: peripheryActions.target } });
        periphery = await InfinityPoolsPeriphery.deploy();
        await periphery.initialize(infinityPoolsFactory, weth9, permit2Address);
    });

    it("Revert when add to a non existing pool", async function () {
        let token0Address = token0.target < tokenC.target ? token0.target : tokenC.target;
        let token1Address = token0.target < tokenC.target ? tokenC.target : token0.target;


        await expect(
            periphery.addLiquidity({
                token0: token0Address,
                token1: token1Address,
                splits: splits,
                startEdge: 1,
                stopEdge: 2,
                amount0Desired: 1,
                amount1Desired: 1,
                amount0Min: 1,
                amount1Min: 1,
            })
        ).to.be.revertedWithCustomError(periphery, "PoolDoesNotExist");
    });

    it("addLiquidity one sided liquidity", async function () {
        await token0.approve(periphery.target, 1);
        await periphery.addLiquidity({
            token0: token0.target,
            token1: token1.target,
            splits: splits,
            startEdge: 1,
            stopEdge: 2,
            amount0Desired: 1,
            amount1Desired: 0,
            amount0Min: 0,
            amount1Min: 0,
        });

        //make sure NFT is minted to the user
        expect(await periphery.balanceOf(deployer.address)).to.equal(1);

        const poolAddress = await infinityPoolsFactory.getPool(token0.target, token1.target, splits);
        const lpNum = 0;
        const positionType = 0; // LP position
        const nftId = await periphery.encodeId(positionType, poolAddress, lpNum);
        expect(await periphery.ownerOf(nftId)).to.equal(deployer.address);
    });

    it("addLiquidity with incorrect ordering of token0 and token1", async function () {
        await token0.approve(periphery.target, 1);
        await expect(
            periphery.addLiquidity({
                token0: token1.target,
                token1: token0.target,
                splits: splits,
                startEdge: 1,
                stopEdge: 2,
                amount0Desired: 1,
                amount1Desired: 0,
                amount0Min: 2,
                amount1Min: 0,
            })
        ).to.be.revertedWithCustomError(periphery, "TokenOrderInvalid");
    });


    it("addLiquidity with amountMin more than amountDesire", async function () {
        await token0.approve(periphery.target, 1);
        await expect(
            periphery.addLiquidity({
                token0: token0.target,
                token1: token1.target,
                splits: splits,
                startEdge: 1,
                stopEdge: 2,
                amount0Desired: 1,
                amount1Desired: 0,
                amount0Min: 2,
                amount1Min: 0,
            })
        ).to.be.revertedWithCustomError(periphery, "PriceSlippageAmount0");
    });

    it("addLiquidity one sided liquidity but provide more amount1Desired than needed", async function () {
        await token0.approve(periphery.target, 1);
        await periphery.addLiquidity({
            token0: token0.target,
            token1: token1.target,
            splits: splits,
            startEdge: 1,
            stopEdge: 2,
            amount0Desired: 1,
            amount1Desired: 1,
            amount0Min: 0,
            amount1Min: 0,
        });
    });

    it("addLiquidity using multicall", async function () {
        await token0.approve(periphery.target, 1);
        const params = {
            token0: token0.target,
            token1: token1.target,
            splits: splits,
            startEdge: 1,
            stopEdge: 2,
            amount0Desired: 1,
            amount1Desired: 1,
            amount0Min: 0,
            amount1Min: 0,
        };

        const addLiquidityCall = periphery.interface.encodeFunctionData("addLiquidity", [params]);

        // const poolAddress = await infinityPoolsFactory.getPool(token0.target, token1.target, splits);
        // const lpNum = 0;
        // const positionType = 0; // LP position
        // const tokenId = await periphery.encodeId(positionType, poolAddress, lpNum);

        // const drainCall = periphery.interface.encodeFunctionData("drain", [tokenId, deployer.address]);
        // const calls = [addLiquidityCall, drainCall];

        const calls = [addLiquidityCall];
        await periphery.multicall(calls);
    });

    it("addLiquidity one sided liquidity but provide more amount1Min than needed", async function () {
        await token0.approve(periphery.target, 1);
        await expect(
            periphery.addLiquidity({
                token0: token0.target,
                token1: token1.target,
                splits: splits,
                startEdge: 1,
                stopEdge: 2,
                amount0Desired: 1,
                amount1Desired: 0,
                amount0Min: 0,
                amount1Min: 1,
            })
        ).to.be.revertedWithCustomError(periphery, "PriceSlippageAmount1");

    });

});
