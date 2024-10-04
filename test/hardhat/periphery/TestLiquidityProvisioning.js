const { expect } = require("chai");
const { Constants } = require("../../../javascript/core/Constants.js");
const { TokenUtils } = require("../../../javascript/core/TokenUtils.js");
const { Testbed } = require("../../../javascript/test/testbed.js");
const { BigNumber } = require("@ethersproject/bignumber");


describe("addLiquidity", function () {
	const splits = 15;
	const quadVar = Constants.POSITIVE_HALF;
	let testbed;
	let lper;
	let tokenA;
	let tokenB;
	let initialBalance = 100;
	let lpAmount = 1;

	beforeEach(async function () {
		testbed = new Testbed(true);
		await testbed.ensureInit();
		lper = testbed.users[0];
		tokenA = await testbed.createToken("TokenA", 8);
		tokenB = await testbed.createToken("TokenB", 8);

	});


	it("should pass a basic smoke test", async function () {
		const initialPoolPrice = Constants.POSITIVE_ONE;
		const pool = await testbed.createPool(tokenA, tokenB, splits, initialPoolPrice, quadVar);
		await TokenUtils.mintDecimal(tokenA, lper.address, initialBalance);
		console.log(`minted ${initialBalance} TokenA for ${lper.address}; native balance = ${await tokenA.balanceOf(lper.address)}`);
		await TokenUtils.mintDecimal(tokenB, lper.address, initialBalance);
		console.log(`minted ${initialBalance} TokenB for ${lper.address}; native balance = ${await tokenB.balanceOf(lper.address)}`);

		console.log(`approving spending by periphery ${testbed.peripheryAddress}`);
		await tokenA.connect(lper).approve(testbed.peripheryAddress, await TokenUtils.toNativeAmount(tokenA, lpAmount));
		await tokenB.connect(lper).approve(testbed.peripheryAddress, await TokenUtils.toNativeAmount(tokenB, lpAmount));
		const params = {
			token0: pool.token0.target,
			token1: pool.token1.target,
			splits: splits,
			startEdge: -100,
			stopEdge: 100,
			amount0Desired: await TokenUtils.toNativeAmount(tokenA, lpAmount),
			amount1Desired: await TokenUtils.toNativeAmount(tokenB, lpAmount),
			amount0Min: 0,
			amount1Min: 0
		};
		console.log(`Before addLiquidity: TokenA(${lper.address}) = ${await TokenUtils.getTokenBalance(tokenA, lper.address)}`);
		console.log(`Before addLiquidity: TokenB(${lper.address}) = ${await TokenUtils.getTokenBalance(tokenB, lper.address)}`);


		//emit LiquidityAdded(msg.sender, poolAddress, lpNum, amount0, amount1, earnEra, poolDate);
		testbed.periphery.on("LiquidityAdded", (u, poolAddress, lpNum, amount0, amount1, earnEra, poolDate) => {
			console.log(`EVENT: ${u}, ${poolAddress}, ${lpNum}, ${amount0}, ${amount1}, ${earnEra}`);
		});

		const tx = await testbed.addLiquidity(lper, params);
		await expect(tx).to.emit(testbed.periphery, "LiquidityAdded");
		console.log(`hash = ${tx.hash}`);
		const event = testbed.extractFirstEventFromReceipt(await tx.wait(), "LiquidityAdded");
		expect(event).to.not.be.undefined;
		const [u, poolAddress, lpNum, amount0, amount1, earnEra] = event.args;
		expect(u).to.equal(lper.address);
		expect(poolAddress).to.equal(pool.address);
		expect(lpNum).to.equal(0);

		console.log(`After addLiquidity: TokenA(${lper.address}) = ${await TokenUtils.getTokenBalance(tokenA, lper.address)} (${await tokenA.balanceOf(lper.address)})`);
		console.log(`After addLiquidity: TokenB(${lper.address}) = ${await TokenUtils.getTokenBalance(tokenB, lper.address)} (${await tokenB.balanceOf(lper.address)})`);

		expect(await tokenA.balanceOf(lper.address)).to.lessThan(await TokenUtils.toNativeAmount(tokenA, initialBalance));
		expect(await tokenB.balanceOf(lper.address)).to.lessThan(await TokenUtils.toNativeAmount(tokenB, initialBalance));

		// completely symmetric when price = 1
		expect(await tokenA.balanceOf(lper.address)).to.equal(await tokenB.balanceOf(lper.address));
		expect(amount0).to.equal(amount1);
		expect(amount0 + await tokenA.balanceOf(lper.address)).to.equal(await TokenUtils.toNativeAmount(tokenA, initialBalance));
		expect(amount0 + await tokenB.balanceOf(lper.address)).to.equal(await TokenUtils.toNativeAmount(tokenB, initialBalance));
		// await expect(earnEra).to.greaterThan(0); // It is negative. Is it based off a future date?
	});

	it("should work with native ETH", async function () {
		const initialPoolPrice = Constants.POSITIVE_ONE;
		const wethAddress = await testbed.periphery.WETH9();
		tokenB = tokenB.attach(wethAddress);
		const pool = await testbed.createPool(tokenA, tokenB, splits, initialPoolPrice, quadVar);
		await TokenUtils.mintDecimal(tokenA, lper.address, initialBalance);
		console.log(`minted ${initialBalance} TokenA for ${lper.address}; native balance = ${await tokenA.balanceOf(lper.address)}`);

		//tokenB is WETH


		console.log(`approving spending by periphery ${testbed.peripheryAddress}`);
		await tokenA.connect(lper).approve(testbed.peripheryAddress, await TokenUtils.toNativeAmount(tokenA, lpAmount));
		const params = {
			token0: pool.token0.target,
			token1: pool.token1.target,
			splits: splits,
			startEdge: -100,
			stopEdge: 100,
			amount0Desired: await TokenUtils.toNativeAmount(tokenA, lpAmount),
			amount1Desired: await TokenUtils.toNativeAmount(tokenB, lpAmount),
			amount0Min: 0,
			amount1Min: 0
		};
		console.log(`Before addLiquidity: TokenA(${lper.address}) = ${await TokenUtils.getTokenBalance(tokenA, lper.address)}`);
		console.log(`Before addLiquidity: TokenB(${lper.address}) = ${await TokenUtils.getTokenBalance(tokenB, lper.address)}`);

		testbed.periphery.on("LiquidityAdded", (u, poolAddress, lpNum, amount0, amount1, earnEra) => {
			console.log(`EVENT: ${u}, ${poolAddress}, ${lpNum}, ${amount0}, ${amount1}, ${earnEra}`);
		});

		const tx = await testbed.addLiquidity(lper, params, ethers.parseEther(initialBalance.toString()));
		await expect(tx).to.emit(testbed.periphery, "LiquidityAdded");
		console.log(`hash = ${tx.hash}`);
		const event = testbed.extractFirstEventFromReceipt(await tx.wait(), "LiquidityAdded");
		expect(event).to.not.be.undefined;
		const [u, poolAddress, lpNum, amount0, amount1, earnEra] = event.args;
		expect(u).to.equal(lper.address);
		expect(poolAddress).to.equal(pool.address);
		expect(lpNum).to.equal(0);

		console.log(`After addLiquidity: TokenA(${lper.address}) = ${await TokenUtils.getTokenBalance(tokenA, lper.address)} (${await tokenA.balanceOf(lper.address)})`);
		console.log(`After addLiquidity: TokenB(${lper.address}) = ${await TokenUtils.getTokenBalance(tokenB, lper.address)} (${await tokenB.balanceOf(lper.address)})`);

		expect(await tokenA.balanceOf(lper.address)).to.lessThan(await TokenUtils.toNativeAmount(tokenA, initialBalance));
		expect(await tokenB.balanceOf(lper.address)).to.lessThan(await TokenUtils.toNativeAmount(tokenB, initialBalance));

		// completely symmetric when price = 1
		// expect(await TokenUtils.formateUnits(tokenA, amount0)).to.be.deep.equal(await TokenUtils.formateUnits(tokenB, amount1));


	});

	it("should fail when token0 and token1 are out of order", async function () {
		const initialPoolPrice = Constants.POSITIVE_ONE;
		const pool = await testbed.createPool(tokenA, tokenB, splits, initialPoolPrice, quadVar);
		await TokenUtils.mintDecimal(tokenA, lper.address, initialBalance);
		await TokenUtils.mintDecimal(tokenB, lper.address, initialBalance);
		await tokenA.connect(lper).approve(testbed.peripheryAddress, await TokenUtils.toNativeAmount(tokenA, lpAmount));
		await tokenB.connect(lper).approve(testbed.peripheryAddress, await TokenUtils.toNativeAmount(tokenB, lpAmount));
		const params = {
			token0: pool.token1.target,
			token1: pool.token0.target,
			splits: splits,
			startEdge: -100,
			stopEdge: 100,
			amount0Desired: TokenUtils.toNativeAmount(tokenA, lpAmount),
			amount1Desired: TokenUtils.toNativeAmount(tokenB, lpAmount),
			amount0Min: 0,
			amount1Min: 0
		};
		await expect(testbed.addLiquidity(lper, params)).to.be.revertedWithCustomError(testbed.periphery, "TokenOrderInvalid");
	});

	it("should fail when token0 and token1 are the same", async function () {
		const initialPoolPrice = Constants.POSITIVE_ONE;
		const pool = await testbed.createPool(tokenA, tokenB, splits, initialPoolPrice, quadVar);
		await TokenUtils.mintDecimal(tokenA, lper.address, initialBalance);
		await TokenUtils.mintDecimal(tokenB, lper.address, initialBalance);
		await tokenA.connect(lper).approve(testbed.peripheryAddress, await TokenUtils.toNativeAmount(tokenA, lpAmount));
		await tokenB.connect(lper).approve(testbed.peripheryAddress, await TokenUtils.toNativeAmount(tokenB, lpAmount));
		const params = {
			token0: pool.token0.target,
			token1: pool.token0.target,
			splits: splits,
			startEdge: -100,
			stopEdge: 100,
			amount0Desired: TokenUtils.toNativeAmount(tokenA, lpAmount),
			amount1Desired: TokenUtils.toNativeAmount(tokenB, lpAmount),
			amount0Min: 0,
			amount1Min: 0
		};
		await expect(testbed.addLiquidity(lper, params)).to.be.revertedWithCustomError(testbed.periphery, "IdenticalTokens");
	});
});


describe("getLiquidityPosition", function () {
	const splits = 15;
	const quadVar = Constants.POSITIVE_HALF;
	let testbed;
	let lper;
	let tokenA;
	let tokenB;
	let initialBalance = 100;
	let lpAmount = 1;
	let initialPoolPrice = Constants.POSITIVE_ONE;
	let pool;

	beforeEach(async function () {
		testbed = new Testbed(true);
		await testbed.ensureInit();
		lper = testbed.users[0];
		tokenA = await testbed.createToken("TokenA", 8);
		tokenB = await testbed.createToken("TokenB", 8);
		pool = await testbed.createPool(tokenA, tokenB, splits, initialPoolPrice, quadVar);
		await TokenUtils.mintDecimal(tokenA, lper.address, initialBalance);
		await TokenUtils.mintDecimal(tokenB, lper.address, initialBalance);
		await tokenA.connect(lper).approve(testbed.peripheryAddress, await TokenUtils.toNativeAmount(tokenA, lpAmount));
		await tokenB.connect(lper).approve(testbed.peripheryAddress, await TokenUtils.toNativeAmount(tokenB, lpAmount));
	});

	it("should fail when the position does not exist", async function () {
		await expect(testbed.getLiquidityPosition(lper, pool, 0)).to.be.revertedWithCustomError(pool.pool, "InvalidLPNumber");
		await expect(testbed.getLiquidityPosition(lper, pool, 1)).to.be.revertedWithCustomError(pool.pool, "InvalidLPNumber");
	});
	it("should pass a basic smoke test", async function () {
		const params = {
			token0: pool.token0.target,
			token1: pool.token1.target,
			splits: splits,
			startEdge: -100,
			stopEdge: 100,
			amount0Desired: TokenUtils.toNativeAmount(tokenA, lpAmount),
			amount1Desired: TokenUtils.toNativeAmount(tokenB, lpAmount),
			amount0Min: 0,
			amount1Min: 0
		};

		await expect(await testbed.addLiquidity(lper, params)).to.emit(testbed.periphery, "LiquidityAdded");
		await expect(testbed.getLiquidityPosition(lper, pool, 0)).to.not.be.reverted;
	});
});
