const { expect } = require("chai");
const { ethers } = require("hardhat");
// const { ethers } = require("hardhat");
// const { constants, utils, BigNumber } = ethers;


function parseEther(amount) {
    return ethers.parseEther(amount.toString());
}

describe("InfinityPoolsFactory", function () {
    let infinityPoolsFactory;
    let token0;
    let token1;
    let infinityPool;
    let poolAddress;
    const splits = 15;


    beforeEach(async () => {
        const [owner, user1] = await ethers.getSigners();

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
        const poolConstructor = await hre.ethers.deployContract("PoolConstructor", { libraries: { EraBoxcarMidSum: eraBoxcarMidSum, GrowthSplitFrame: growthSplitFrame, JumpyAnchorFaber: jumpyAnchorFaber } });
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

        token0 = await ethers.deployContract("Token", ["token0", "TK0", 18]);
        token1 = await ethers.deployContract("Token", ["token1", "TK1", 18]);

        token0.mint(user1.address, parseEther("1000"));
        token1.mint(user1.address, parseEther("1000"));

        await infinityPoolsFactory.createPool(token0.target, token1.target, splits);
        poolAddress = await infinityPoolsFactory.getPool(token0.target, token1.target, splits);
        infinityPool = await ethers.getContractAt("InfinityPool", poolAddress);
    });

    it("Should create a pool correctly", async function () {
        expect(poolAddress).to.not.equal(ethers.AddressZero);
        //do stuff with infinityPool
        //if you need access to variables that infinityPool itself doesn't expose,you will have to create a infinityPoolTestMock contract that inherits from infinityPool and exposes those variables
    });

});
