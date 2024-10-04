const { Contract, ContractFactory } = require("ethers");
// const { ethers } = require("hardhat");
const hre = require('hardhat');
const { expect } = require('chai');
const UniswapV2FactoryArtifact = require("@uniswap/v2-core/build/UniswapV2Factory.json");
const UniswapV2RouterArtifact = require("@uniswap/v2-periphery/build/UniswapV2Router02.json");
const UniswapV2PairArtifact = require("@uniswap/v2-periphery/build/IUniswapV2Pair.json");
const { Constants } = require('../../../javascript/core/Constants.js');
const { TokenUtils } = require('../../../javascript/core/TokenUtils.js');
const { Testbed } = require('../../../javascript/test/testbed.js');
const { deployInfinityPoolsPeriphery } = require('../../../javascript/core/DeployGraph.js');

describe('UniswapArbTest', function () {
	let deployer;
	let lper1;
	let lper2;
	let arbitrageur;
	let wethAddress;
	let token0;
	let token1;
	let tokenAddress0;
	let tokenAddress1;

	let uniswapV2Factory;
	let uniswapV2FactoryAddress;
	let uniswapV2Router;
	let uniswapV2RouterAddress;
	let uniswapV2PairAddress;
	let uniswapV2Pair;

	const splits = 15;
	let infinityPool;
	let testbed;
	let lper;

	let uniswapV2Arb;
	let uniswapV2ArbAddress;

	const MaxUint256 = "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
	const abiCoder = new ethers.AbiCoder();

	beforeEach(async function () {
		[deployer, lper1, lper2, arbitrageur] = await hre.ethers.getSigners();
		testbed = new Testbed(true);
		await testbed.ensureInit();
		wethAddress = await testbed.periphery.WETH9();
		lper = testbed.users[0];
		const tokenA = await testbed.createToken("TokenA", 6);
		const tokenB = await testbed.createToken("TokenB", 8);
		[token0, token1] = TokenUtils.orderTokenPair(tokenA, tokenB);
		tokenAddress0 = await token0.getAddress();
		tokenAddress1 = await token1.getAddress();

		// https://medium.com/coinmonks/deploy-interact-with-uniswap-v2-pair-locally-with-hardhat-and-ethers-js-v6-f8f5dd436930
		const Factory = new ContractFactory(
			UniswapV2FactoryArtifact.abi,
			UniswapV2FactoryArtifact.bytecode,
			deployer
		);
		uniswapV2Factory = await Factory.deploy(deployer.address);
		await expect(uniswapV2Factory).to.not.be.undefined;
		await expect(uniswapV2Factory).to.not.be.null;
		uniswapV2FactoryAddress = await uniswapV2Factory.getAddress();

		const Router = new ContractFactory(
			UniswapV2RouterArtifact.abi,
			UniswapV2RouterArtifact.bytecode,
			deployer
		);
		uniswapV2Router = await Router.deploy(uniswapV2FactoryAddress, wethAddress);
		uniswapV2RouterAddress = await uniswapV2Router.getAddress();

		const tx1 = await uniswapV2Factory.createPair(tokenAddress0, tokenAddress1);
		await tx1.wait();
		uniswapV2PairAddress = await uniswapV2Factory.getPair(tokenAddress0, tokenAddress1);
		console.log(`UniswapV2Pair deployed to ${uniswapV2PairAddress}`);
		// Initialize a new contract instance for the trading pair using its address and ABI.
		uniswapV2Pair = new Contract(uniswapV2PairAddress, UniswapV2PairArtifact.abi, deployer);

		const uniswapV2ArbFactory = await hre.ethers.getContractFactory("UniswapV2Arb");
		// uniswapV2Arb = await hre.ethers.deployContract(uniswapV2ArbFactory, uniswapV2FactoryAddress, testbed.peripheryAddress);
		uniswapV2Arb = await uniswapV2ArbFactory.deploy(uniswapV2FactoryAddress, testbed.peripheryAddress);
		uniswapV2ArbAddress = await uniswapV2Arb.getAddress();
		await expect(uniswapV2Arb).to.not.be.undefined;
		await expect(uniswapV2Arb).to.not.be.null;
		console.log(`UniswapV2Arb is deployed to ${uniswapV2ArbAddress}`);

		const bal = 100000000.0;

		await TokenUtils.mintDecimal(token0, lper1.address, bal);
		console.log(`minted ${bal} TokenA for ${lper1.address}; native balance = ${await token0.balanceOf(lper1.address)}`);
		await TokenUtils.mintDecimal(token1, lper1.address, bal);
		console.log(`minted ${bal} TokenB for ${lper1.address}; native balance = ${await token1.balanceOf(lper1.address)}`);

		await TokenUtils.mintDecimal(token0, lper2.address, bal);
		console.log(`minted ${bal} TokenA for ${lper2.address}; native balance = ${await token0.balanceOf(lper2.address)}`);
		await TokenUtils.mintDecimal(token1, lper2.address, bal);
		console.log(`minted ${bal} TokenB for ${lper2.address}; native balance = ${await token1.balanceOf(lper2.address)}`);

		await TokenUtils.mintDecimal(token0, arbitrageur.address, bal);
		console.log(`minted ${bal} TokenA for ${arbitrageur.address}; native balance = ${await token0.balanceOf(arbitrageur.address)}`);
		await TokenUtils.mintDecimal(token1, arbitrageur.address, bal);
		console.log(`minted ${bal} TokenB for ${arbitrageur.address}; native balance = ${await token1.balanceOf(arbitrageur.address)}`);

		infinityPool = await testbed.createPool(token0, token1, splits, Constants.POSITIVE_THREE, Constants.POSITIVE_HALF);
		await expect(infinityPool).to.not.be.undefined;
		await expect(infinityPool).to.not.be.null;
		console.log(`created infinity pool at ${infinityPool.address}: ${infinityPool}`);
	});

	async function approveSpending(user, spender, amount0, amount1) {
		const approveTx1 = await token0.connect(user).approve(spender, amount0);
		await approveTx1.wait();
		const approveTx2 = await token1.connect(user).approve(spender, amount1);
		await approveTx2.wait();
	}

	async function addUniswapV2Liquidity(lper, amount0, amount1) {
		console.log('adding liquidity to uniswapV2 ......');
		await approveSpending(lper, uniswapV2RouterAddress, MaxUint256, MaxUint256);

		const deadline = Math.floor(Date.now() / 1000) + 10 * 60;
		const addLiquidityTx = await uniswapV2Router
			.connect(lper)
			.addLiquidity(
				tokenAddress0,
				tokenAddress1,
				TokenUtils.toNativeAmount(token0, amount0),
				TokenUtils.toNativeAmount(token1, amount1),
				0,
				0,
				lper,
				deadline
			);
		await addLiquidityTx.wait();
		reserves = await uniswapV2Pair.getReserves();
		console.log(`Reserves: ${reserves[0].toString()}, ${reserves[1].toString()}`);
	}

	async function addInfinityPoolLiquidity(pool, lper, amount0, amount1) {
		console.log('adding liquidity to infinity pool ......');
		await approveSpending(lper, testbed.peripheryAddress, MaxUint256, MaxUint256);
		const params = {
			token0: pool.token0.target,
			token1: pool.token1.target,
			splits: splits,
			startEdge: -2048,
			stopEdge: 2048,
			amount0Desired: await TokenUtils.toNativeAmount(token0, amount0),
			amount1Desired: await TokenUtils.toNativeAmount(token1, amount1),
			amount0Min: 0,
			amount1Min: 0
		};
		const tx = await testbed.addLiquidity(lper, params);
		await tx.wait();
	}

	it('can perform an arb when the uniswap price is lower than the infinity pool price', async function () {
		await addInfinityPoolLiquidity(infinityPool, lper2, 10000, 10000); // price is initialized to be 3
		await addUniswapV2Liquidity(lper1, 100000, 290000); // token0/token1 price = 2.9 < 3

		// Since uniswap price < infinity pool price, token0 is worth more token1
		// at the infinity pool than at the uniswap pool.
		// We flash-loan token0, swap for token1 at the infinity pool, and return
		// some token1 to uniswap and pocket the remaining token1.
		const token0AmountBefore = await token0.balanceOf(arbitrageur.address);
		const token1AmountBefore = await token1.balanceOf(arbitrageur.address);
		await expect(await token0.balanceOf(uniswapV2ArbAddress)).to.equal(0);
		await expect(await token1.balanceOf(uniswapV2ArbAddress)).to.equal(0);

		// we figure out how much to arb
		const limitPriceQuad = "0x40007333333333333333333333333333"; // 2.9
		const swapParams = {
			push: Constants.POSITIVE_TEN,
			token: false, // push token 0
			limitPrice: { val: limitPriceQuad },
		};
		// token0 -> token1
		await approveSpending(arbitrageur, infinityPool.address, MaxUint256, MaxUint256);
		const [transferredAmount0, transferredAmount1] = await infinityPool.pool.connect(arbitrageur).swap.staticCall(
			swapParams, arbitrageur.address, "0x"
		);
		console.log(`infinity pool swap = (${transferredAmount0}, ${transferredAmount1})`);
		await expect(transferredAmount0).to.be.greaterThan(0);
		await expect(transferredAmount1).to.be.lessThan(0);

		// https://docs.ethers.org/v5/api/utils/abi/coder/
		const calldata = abiCoder.encode(["int256", "bytes16"], [splits, limitPriceQuad]);
		const tx = await uniswapV2Pair.connect(arbitrageur).swap(transferredAmount0, 0, uniswapV2ArbAddress, calldata);
		await tx.wait();

		await expect(await token0.balanceOf(uniswapV2ArbAddress)).to.equal(0);
		await expect(await token1.balanceOf(uniswapV2ArbAddress)).to.equal(0);

		const token0AmountAfter = await token0.balanceOf(arbitrageur.address);
		const token1AmountAfter = await token1.balanceOf(arbitrageur.address);

		// no change in arbitrageur's token0 balance.
		await expect(token0AmountAfter).to.equal(token0AmountBefore);
		// some profit in arbitrageur's token1 balance.
		await expect(token1AmountAfter).to.be.greaterThan(token1AmountBefore);
	});

	it('can perform an arb when the uniswap price is higher than the infinity pool price', async function () {
		await addInfinityPoolLiquidity(infinityPool, lper2, 10000, 10000); // price is initialized to be 3
		await addUniswapV2Liquidity(lper1, 100000, 310000); // token0/token1 price = 3.1 > 3

		// Since uniswap price > infinity pool price, token1 is worth more token0
		// at the infinity pool than at the uniswap pool.
		// We flash-loan token1, swap for token0 at the infinity pool, and return
		// some token0 to uniswap and pocket the remaining token0.
		const token0AmountBefore = await token0.balanceOf(arbitrageur.address);
		const token1AmountBefore = await token1.balanceOf(arbitrageur.address);
		await expect(await token0.balanceOf(uniswapV2ArbAddress)).to.equal(0);
		await expect(await token1.balanceOf(uniswapV2ArbAddress)).to.equal(0);

		// we figure out how much to arb
		const limitPriceQuad = "0x40008ccccccccccccccccccccccccccc"; // 3.1
		const swapParams = {
			push: Constants.POSITIVE_TEN,
			token: true, // push token 1
			limitPrice: { val: limitPriceQuad },
		};
		// token0 -> token1
		await approveSpending(arbitrageur, infinityPool.address, MaxUint256, MaxUint256);
		const [transferredAmount0, transferredAmount1] = await infinityPool.pool.connect(arbitrageur).swap.staticCall(
			swapParams, arbitrageur.address, "0x"
		);
		console.log(`infinity pool swap = (${transferredAmount0}, ${transferredAmount1})`);
		await expect(transferredAmount0).to.be.lessThan(0);
		await expect(transferredAmount1).to.be.greaterThan(0);

		// https://docs.ethers.org/v5/api/utils/abi/coder/
		const calldata = abiCoder.encode(["int256", "bytes16"], [splits, limitPriceQuad]);
		const tx = await uniswapV2Pair.connect(arbitrageur).swap(0, transferredAmount1, uniswapV2ArbAddress, calldata);
		await tx.wait();

		await expect(await token0.balanceOf(uniswapV2ArbAddress)).to.equal(0);
		await expect(await token1.balanceOf(uniswapV2ArbAddress)).to.equal(0);

		const token0AmountAfter = await token0.balanceOf(arbitrageur.address);
		const token1AmountAfter = await token1.balanceOf(arbitrageur.address);

		// some profit in arbitrageur's token0 balance.
		await expect(token0AmountAfter).to.be.greaterThan(token0AmountBefore);
		// no change in arbitrageur's token1 balance.
		await expect(token1AmountAfter).to.equal(token1AmountBefore);
	});
});
