const { expect } = require("chai");
const { Constants } = require("../../../javascript/core/Constants.js");
const { TokenUtils } = require("../../../javascript/core/TokenUtils.js");
const { Testbed } = require("../../../javascript/test/testbed.js");

describe("swap", function () {
	const quad_1_01 = "0x3fff028f5c28f5c28f5c28f5c28f5c29";
	const splits = 15;
	const quadVar = Constants.POSITIVE_HALF;
	let testbed;
	let lper;
	let initialBalance = 1000000;
	let lpAmount = 10;
	let initialPoolPrice = Constants.POSITIVE_ONE;
	let pool;

	beforeEach(async function () {
		testbed = new Testbed(true);
		await testbed.ensureInit();
		lper = testbed.users[0];
		const tokenA = await testbed.createToken("TokenA", 8);
		const tokenB = await testbed.createToken("TokenB", 8);
		pool = await testbed.createPool(tokenA, tokenB, splits, initialPoolPrice, quadVar);
		await TokenUtils.mintDecimal(tokenA, lper.address, initialBalance);
		await TokenUtils.mintDecimal(tokenB, lper.address, initialBalance);
		await tokenA.connect(lper).approve(testbed.peripheryAddress, await TokenUtils.toNativeAmount(tokenA, lpAmount));
		await tokenB.connect(lper).approve(testbed.peripheryAddress, await TokenUtils.toNativeAmount(tokenB, lpAmount));
		const params = {
			token0: pool.token0.target,
			token1: pool.token1.target,
			splits: splits,
			startEdge: -100, // 1.01^-100 = 0.36971121232
			stopEdge: 100, // 1.01 ^ 100 = 2.70481382942
			amount0Desired: TokenUtils.toNativeAmount(tokenA, lpAmount),
			amount1Desired: TokenUtils.toNativeAmount(tokenB, lpAmount),
			amount0Min: 0,
			amount1Min: 0
		};
		const tx = await testbed.addLiquidity(lper, params);
		await expect(tx).to.emit(testbed.periphery, "LiquidityAdded");
	});

	it("should pass a basic smoke test", async function () {
		const token0 = pool.token0;
		const token1 = pool.token1;
		const maxSwapAmount = 100.0;
		const initialBalance0 = await token0.balanceOf(lper.address);
		const initialBalance1 = await token1.balanceOf(lper.address);
		console.log(`Before swap: Token0(${lper.address}) = ${await TokenUtils.getTokenBalance(token0, lper.address)} (${await token0.balanceOf(lper.address)})`);
		console.log(`Before swap: Token1(${lper.address}) = ${await TokenUtils.getTokenBalance(token1, lper.address)} (${await token1.balanceOf(lper.address)})`);

		await token0.connect(lper).approve(pool.address, await TokenUtils.toNativeAmount(token0, maxSwapAmount));
		await token1.connect(lper).approve(pool.address, await TokenUtils.toNativeAmount(token1, maxSwapAmount));

		// token1 -> token0
		await expect(await pool.pool.connect(lper).swap(
			{
				push: Constants.POSITIVE_TWO, // well below TokenUtils.toNativeAmount(token, maxSwapAmount)
				token: true, // token 1
				limitPrice: { val: quad_1_01 } // close to 1
			},
			lper.address,
			"0x" // callback data
		)).to.not.be.reverted;

		console.log(`After swap 1: Token0(${lper.address}) = ${await TokenUtils.getTokenBalance(token0, lper.address)} (${await token0.balanceOf(lper.address)})`);
		console.log(`After swap 1: Token1(${lper.address}) = ${await TokenUtils.getTokenBalance(token1, lper.address)} (${await token1.balanceOf(lper.address)})`);

		const token0Delta = await token0.balanceOf(lper.address) - initialBalance0;
		const token1Delta = await token1.balanceOf(lper.address) - initialBalance1;
		await expect(token0Delta).to.be.greaterThan(0);
		await expect(token1Delta).to.be.lessThan(0);

		// swap back
		// maxSwapAmount = 100 -> 10^10 units
		// token0Delta = 12661482 = 0x40168265d40000000000000000000000
		await expect(await pool.pool.connect(lper).swap(
			{
				push: "0x40168265d40000000000000000000000",
				token: false, // token 0
				limitPrice: { val: Constants.POSITIVE_ONE } // close to 1
			},
			lper.address,
			"0x" // callback data
		)).to.not.be.reverted;

		console.log(`After swap 2: Token0(${lper.address}) = ${await TokenUtils.getTokenBalance(token0, lper.address)} (${await token0.balanceOf(lper.address)})`);
		console.log(`After swap 2: Token1(${lper.address}) = ${await TokenUtils.getTokenBalance(token1, lper.address)} (${await token1.balanceOf(lper.address)})`);
	});

	it("should do nothing when the limit price is in the wrong direction", async function () {
		const token0 = pool.token0;
		const token1 = pool.token1;
		const maxSwapAmount = 100.0;
		const initialBalance0 = await token0.balanceOf(lper.address);
		const initialBalance1 = await token1.balanceOf(lper.address);
		await token0.connect(lper).approve(pool.address, await TokenUtils.toNativeAmount(token0, maxSwapAmount));
		await token1.connect(lper).approve(pool.address, await TokenUtils.toNativeAmount(token1, maxSwapAmount));
		console.log(`Before swap: Token0(${lper.address}) = ${await TokenUtils.getTokenBalance(token0, lper.address)} (${await token0.balanceOf(lper.address)})`);
		console.log(`Before swap: Token1(${lper.address}) = ${await TokenUtils.getTokenBalance(token1, lper.address)} (${await token1.balanceOf(lper.address)})`);
		// token0 -> token1
		await expect(await pool.pool.connect(lper).swap(
			{
				push: Constants.POSITIVE_BILLION, // below TokenUtils.toNativeAmount(token, maxSwapAmount)
				token: false, // token 0
				limitPrice: { val: Constants.POSITIVE_TEN } // far away from the mid (1)
			},
			lper.address,
			"0x" // callback data
		)).to.not.be.reverted;
		console.log(`After swap 1: Token0(${lper.address}) = ${await TokenUtils.getTokenBalance(token0, lper.address)} (${await token0.balanceOf(lper.address)})`);
		console.log(`After swap 1: Token1(${lper.address}) = ${await TokenUtils.getTokenBalance(token1, lper.address)} (${await token1.balanceOf(lper.address)})`);

		const midBalance0 = await token0.balanceOf(lper.address);
		const midBalance1 = await token1.balanceOf(lper.address);

		// <= 1 due to the fees for the pushed token.
		await expect(Math.abs(Number(midBalance0 - initialBalance0))).to.be.at.most(1);
		await expect(midBalance1).to.equal(initialBalance1);

		// token1 -> token0
		await expect(await pool.pool.connect(lper).swap(
			{
				push: Constants.POSITIVE_TWO, // well below TokenUtils.toNativeAmount(token, maxSwapAmount)
				token: true, // token 1
				limitPrice: { val: Constants.POSITIVE_HALF } // far away from the mid (1)
			},
			lper.address,
			"0x" // callback data
		)).to.not.be.reverted;
		console.log(`After swap 2: Token0(${lper.address}) = ${await TokenUtils.getTokenBalance(token0, lper.address)} (${await token0.balanceOf(lper.address)})`);
		console.log(`After swap 2: Token1(${lper.address}) = ${await TokenUtils.getTokenBalance(token1, lper.address)} (${await token1.balanceOf(lper.address)})`);

		const finalBalance0 = await token0.balanceOf(lper.address);
		const finalBalance1 = await token1.balanceOf(lper.address);

		await expect(finalBalance0).to.equal(midBalance0);
		// <= 1 due to the fees for the pushed token.
		await expect(Math.abs(Number(finalBalance1 - midBalance1))).to.be.at.most(1);
	});
});

