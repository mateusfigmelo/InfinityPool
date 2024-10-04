const { expect } = require("chai");
const ZERO_BYTES16 = "0x00000000000000000000000000000000";
const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
const ONE_ADDRESS = "0x0000000000000000000000000000000000000001";
const { BigNumber } = require("@ethersproject/bignumber");
const { Contract, ContractFactory } = require("ethers");
const factoryArtifact = require("@uniswap/v2-core/build/UniswapV2Factory.json");
const routerArtifact = require("@uniswap/v2-periphery/build/UniswapV2Router02.json");
const { ethers } = require("hardhat");

describe("InfinityPoolsPeriphery newLoan", function () {
    const splits = 15;
    let signers;
    let deployer;
    let user1;
    let token0;
    let token1;
    let infinityPoolWithGeneratedPools = {};
    let infinityPoolsPeriphery = {};
    let generalSwapForwarderAddress = {};
    let uniswapRouterV2;
    let uniswapRouterV2Address;
    let infinityPoolsFactory;
    let uniV2SwapForwarder;

    beforeEach(async function () {
        signers = await hre.ethers.getSigners();
        deployer = signers[0];
        user1 = signers[1];
        const Token = await hre.ethers.getContractFactory("Token");
        const WETH9 = await hre.ethers.getContractFactory("WETH9");
        const tokenA = await Token.deploy("TokenA", "TA", 18);
        const tokenB = await Token.deploy("TokenB", "TB", 18);
        const weth9 = await WETH9.deploy();

        [token0, token1] = (BigNumber.from(tokenA.target).lt(BigNumber.from(tokenB.target))) ? [tokenA, tokenB] : [tokenB, tokenA];

        const token0Address = token0.target;
        const token1Address = token1.target;
        const wethAddress = weth9.target;

        const Factory = new ContractFactory(factoryArtifact.abi, factoryArtifact.bytecode, deployer);
        const univ2Factory = await Factory.deploy(deployer.address);
        const univ2FactoryAddress = await univ2Factory.getAddress();
        console.log(`UniV2 Factory deployed to ${univ2FactoryAddress}`);

        const UniV2Router = new ContractFactory(routerArtifact.abi, routerArtifact.bytecode, deployer);
        const uniV2Router = await UniV2Router.deploy(univ2FactoryAddress, wethAddress);
        uniswapRouterV2Address = await uniV2Router.getAddress();
        console.log(`UniV2 Router deployed to ${uniV2Router.target}`);


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

        const UniV2SwapForwarderFactory = await hre.ethers.getContractFactory("UniV2SwapForwarder");
        uniV2SwapForwarder = await UniV2SwapForwarderFactory.deploy(uniswapRouterV2Address);

        const peripheryActions = await hre.ethers.deployContract("PeripheryActions");


        infinityPoolWithGeneratedPools = {};
        infinityPoolsPeriphery = {};
        for (let i = 1; i <= 8; i++) {
            let tempGeneratedPool = await hre.ethers.deployContract("MockNewLoan" + i);
            let mockSwapper = await hre.ethers.deployContract("MockSwapper" + ((i % 2) + 1));
            infinityPoolsFactory = await hre.ethers.deployContract("InfinityPoolsFactory", {
                libraries: {
                    "src/libraries/external/NewLoan.sol:NewLoan": tempGeneratedPool.target,
                    Spot: spot.target,
                    Advance: advance.target,
                    LP: lp.target,
                    "src/libraries/external/Swapper.sol:Swapper": mockSwapper.target,
                    UserPay: userPay.target,
                    PoolReader: poolReader.target,
                    PoolConstructor: poolConstructor.target,
                    CollectNetted: collectNetted.target
                }

            });


            await infinityPoolsFactory.createPool(token0.target, token1.target, splits);
            poolAddress = await infinityPoolsFactory.getPool(token0.target, token1.target, splits);
            infinityPool = await hre.ethers.getContractAt("InfinityPool", poolAddress);
            infinityPoolWithGeneratedPools[i] = await hre.ethers.getContractAt("InfinityPool", poolAddress);

            const InfinityPoolsPeriphery = await hre.ethers.getContractFactory("InfinityPoolsPeriphery", { libraries: { PeripheryActions: peripheryActions.target } });

            const permit2 = ZERO_ADDRESS;
            infinityPoolsPeriphery[i] = await InfinityPoolsPeriphery.deploy();
            await infinityPoolsPeriphery[i].initialize(infinityPoolsFactory, weth9, permit2);
            generalSwapForwarderAddress[i] = await infinityPoolsPeriphery[i].generalSwapForwarder();
            await infinityPoolsPeriphery[i].addOrRemoveSwapForwarder(uniV2SwapForwarder.target, true);

        }
        uniswapRouterV2 = await hre.ethers.getContractAt("IUniswapV2Router02", uniswapRouterV2Address);





        //price of token0/token1 = 400
        const token0Amount = "1" + "0".repeat(22);
        const token1Amount = "4" + "0".repeat(24);
        await token0.approve(uniswapRouterV2Address, token0Amount);
        await token1.approve(uniswapRouterV2Address, token1Amount);
        await uniswapRouterV2.addLiquidity(token0Address, token1Address,
            token0Amount, token1Amount,
            token0Amount, token1Amount,
            signers[0].address, 1000000000000);

    });

    async function openNewLoan(idx, signer, collateralTokenIsToken0, collateralAmount, isError = false) {

        const depositERC20Data = infinityPoolsPeriphery[idx].interface.encodeFunctionData("depositERC20", [collateralTokenIsToken0 ? token0.target : token1.target, deployer.address, collateralAmount, false, 0, 0, "0x"]);
        const addCollateralData = infinityPoolsPeriphery[idx].interface.encodeFunctionData("addCollateral", [token0.target, token1.target, collateralTokenIsToken0 ? token0.target : token1.target, deployer.address, collateralAmount]);

        const newLoanParams = [[ZERO_BYTES16], 0, 0, ZERO_BYTES16, ZERO_BYTES16, 0, false, 0];

        const swapInfo = [uniV2SwapForwarder.target, uniswapRouterV2Address, uniswapRouterV2Address, '0x'];

        const newLoanData = infinityPoolsPeriphery[idx].interface.encodeFunctionData("newLoan", [token0.target, token1.target, splits, deployer.address, swapInfo, newLoanParams]);

        const calls = [depositERC20Data, addCollateralData, newLoanData];
        if (!isError) {
            await infinityPoolsPeriphery[idx].connect(signer).multicall(calls);
        } else {
            await expect(infinityPoolsPeriphery[idx].connect(signer).multicall(calls)).to.be.revertedWith("");
        }
    }

    it("Revert when caller do not have enough allowance", async function () {
        const idx = 1;
        const infinityPoolAddress = await infinityPoolWithGeneratedPools[idx].getAddress();
        //Add liquidity to infinity pool
        await token1.transfer(infinityPoolAddress, "1" + "0".repeat(18));

        const collateralAmount = 1;
        const collateralTokenIsToken0 = false;

        const swapInfo = [uniV2SwapForwarder.target, uniswapRouterV2Address, uniswapRouterV2Address, '0x'];
        //we are using custom newLoan lib for tests. That is why any empty parameter to newLoan works
        const newLoanParams = [[ZERO_BYTES16], 0, 0, ZERO_BYTES16, ZERO_BYTES16, 0, false, 0];

        await expect(
            infinityPoolsPeriphery[idx].newLoan(token0, token1, splits, user1, swapInfo, newLoanParams)
        ).to.be.revertedWithCustomError(infinityPoolsPeriphery[idx], "CallerNotApproved");
    });

    it("Revert when spot swap (market price at 400) + collateral (token1 = 0) does not fit UserPay requirement (1,-1)", async function () {
        const idx = 1;
        const infinityPoolAddress = await infinityPoolWithGeneratedPools[idx].getAddress();
        //Add liquidity to infinity pool
        await token1.transfer(infinityPoolAddress, "1" + "0".repeat(18));

        const collateralAmount = 0;
        const collateralTokenIsToken0 = false;

        const swapInfo = [uniV2SwapForwarder.target, uniswapRouterV2Address, uniswapRouterV2Address, '0x'];
        //we are using custom newLoan lib for tests. That is why any empty parameter to newLoan works
        const newLoanParams = [[ZERO_BYTES16], 0, 0, ZERO_BYTES16, ZERO_BYTES16, 0, false, 0];

        await infinityPoolsPeriphery[idx].setApprovalForAll(deployer, true);

        await expect(
            infinityPoolsPeriphery[idx].newLoan(token0, token1, splits, deployer, swapInfo, newLoanParams)
        ).to.be.revertedWith("UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
    });

    it("Revert when spot swap (market price at 400) + collateral (token1 = 0) does not fit UserPay requirement (-1,500)", async function () {
        const idx = 5;
        const infinityPoolAddress = await infinityPoolWithGeneratedPools[idx].getAddress();
        //Add liquidity to infinity pool
        await token0.transfer(infinityPoolAddress, "1" + "0".repeat(18));

        const collateralAmount = 0;
        const collateralTokenIsToken0 = false;

        const swapInfo = [uniV2SwapForwarder.target, uniswapRouterV2Address, uniswapRouterV2Address, '0x'];
        //we are using custom newLoan lib for tests. That is why any empty parameter to newLoan works
        const newLoanParams = [[ZERO_BYTES16], 0, 0, ZERO_BYTES16, ZERO_BYTES16, 0, false, 0];

        await infinityPoolsPeriphery[idx].setApprovalForAll(deployer, true);

        await expect(
            infinityPoolsPeriphery[idx].newLoan(token0, token1, splits, deployer, swapInfo, newLoanParams)
        ).to.be.revertedWith("UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
    });

    it("Succeed when spot swap (market price at 400) + collateral (token1 = 0) fit UserPay requirement (1,-500)", async function () {
        const idx = 4;
        const infinityPoolAddress = await infinityPoolWithGeneratedPools[idx].getAddress();

        //Add liquidity to infinity pool
        await token1.transfer(infinityPoolAddress, "5" + "0".repeat(20));

        const collateralAmount = BigInt(0);
        const collateralTokenIsToken0 = false;

        await openNewLoan(idx, deployer, collateralTokenIsToken0, collateralAmount);

    });


    it("Succeed when spot swap (market price at 400) + collateral (token0 = 300) fit UserPay requirement (1,-200)", async function () {
        const idx = 7;
        const infinityPoolAddress = await infinityPoolWithGeneratedPools[idx].getAddress();

        //Add liquidity to infinity pool
        const poolToken = "2" + "0".repeat(20);
        await token1.transfer(infinityPoolAddress, poolToken);

        const collateralAmount = BigInt("3" + "0".repeat(20));
        const collateralTokenIsToken0 = true;
        await token0.approve(infinityPoolsPeriphery[idx], collateralAmount);


        await openNewLoan(idx, deployer, collateralTokenIsToken0, collateralAmount);
    });



    it("Succeed when spot swap (market price at 400) + collateral (token0 = 0.75) fit UserPay requirement (1,-200)", async function () {
        const idx = 7;
        const infinityPoolAddress = await infinityPoolWithGeneratedPools[idx].getAddress();

        //Add liquidity to infinity pool
        const poolToken = "2" + "0".repeat(20);
        await token1.transfer(infinityPoolAddress, poolToken);

        const collateralAmount = BigInt("75" + "0".repeat(16));
        const collateralTokenIsToken0 = true;

        await token0.approve(infinityPoolsPeriphery[idx], collateralAmount);
        await openNewLoan(idx, deployer, collateralTokenIsToken0, collateralAmount);

    });

    it("Succeed when spot swap (market price at 400) + collateral (token1 = 400) fit UserPay requirement (-1,600)", async function () {
        const idx = 8;
        const infinityPoolAddress = await infinityPoolWithGeneratedPools[idx].getAddress();

        //Add liquidity to infinity pool
        const poolToken = "1" + "0".repeat(18);
        await token0.transfer(infinityPoolAddress, poolToken);

        const collateralAmount = BigInt("4" + "0".repeat(20));
        const collateralTokenIsToken0 = false;

        await token1.approve(infinityPoolsPeriphery[idx], collateralAmount);
        await openNewLoan(idx, deployer, collateralTokenIsToken0, collateralAmount);
    });

    it("Succeed when spot swap (market price at 400) + collateral (token0 = 1) fit UserPay requirement (-1,600)", async function () {
        const idx = 8;
        const infinityPoolAddress = await infinityPoolWithGeneratedPools[idx].getAddress();

        //Add liquidity to infinity pool
        const poolToken = "1" + "0".repeat(18);
        await token0.transfer(infinityPoolAddress, poolToken);

        const collateralAmount = BigInt("1" + "0".repeat(18));
        const collateralTokenIsToken0 = true;

        await token0.approve(infinityPoolsPeriphery[idx], collateralAmount);
        await openNewLoan(idx, deployer, collateralTokenIsToken0, collateralAmount);
    });


    it("newLoan went through when user approve operator in Vault", async function () {
        const idx = 8;
        const infinityPoolAddress = await infinityPoolWithGeneratedPools[idx].getAddress();

        //Add liquidity to infinity pool
        const poolToken = "1" + "0".repeat(18);
        await token0.transfer(infinityPoolAddress, poolToken);

        const collateralAmount = BigInt("1" + "0".repeat(18));
        const collateralTokenIsToken0 = true;
        await token0.approve(infinityPoolsPeriphery[idx], collateralAmount);

        await infinityPoolsPeriphery[idx].depositERC20(token0.target, deployer.address, collateralAmount, false, 0, 0, "0x");
        await infinityPoolsPeriphery[idx].addCollateral(token0.target, token1.target, token0.target, deployer.address, collateralAmount);


        const newLoanParams = [[ZERO_BYTES16], 0, 0, ZERO_BYTES16, ZERO_BYTES16, 0, false, 0];
        const swapInfo = [uniV2SwapForwarder.target, uniswapRouterV2Address, uniswapRouterV2Address, '0x'];

        await expect(infinityPoolsPeriphery[idx].connect(user1).newLoan(token0.target, token1.target, splits, deployer.address, swapInfo, newLoanParams)).to.be.revertedWithCustomError(infinityPoolsPeriphery[idx], "CallerNotApproved");

        await infinityPoolsPeriphery[idx].setApprovalForAll(user1.address, true);
        await infinityPoolsPeriphery[idx].connect(user1).newLoan(token0.target, token1.target, splits, deployer.address, swapInfo, newLoanParams);
    });

    it('replenishPeriodic should work correctly', async function () {
        const idx = 8;
        const infinityPoolAddress = await infinityPoolWithGeneratedPools[idx].getAddress();

        //Add liquidity to infinity pool
        const poolToken = "102" + "0".repeat(18);
        await token0.transfer(infinityPoolAddress, poolToken);

        const collateralAmount = BigInt("10" + "0".repeat(18));
        const collateralTokenIsToken0 = true;

        await token0.approve(infinityPoolsPeriphery[idx], collateralAmount);

        await openNewLoan(idx, deployer, collateralTokenIsToken0, collateralAmount);

        //unwind + newLoan
        const newLoanParams = [[ZERO_BYTES16], 0, 0, ZERO_BYTES16, ZERO_BYTES16, 0, false, 0];
        const swapInfo = [uniV2SwapForwarder.target, uniswapRouterV2Address, uniswapRouterV2Address, '0x'];
        const poolAddress = await infinityPoolsFactory.getPool(token0.target, token1.target, splits);
        const lpNum = 0;
        const positionType = 1; // Swapper position
        const tokenId = await infinityPoolsPeriphery[idx].encodeId(positionType, poolAddress, lpNum);


        await infinityPoolsPeriphery[idx].batchActionsOnSwappers([tokenId], [], [newLoanParams], swapInfo);
    });

});
