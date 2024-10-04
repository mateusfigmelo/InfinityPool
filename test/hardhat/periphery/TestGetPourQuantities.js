const { expect } = require("chai");
const { Constants } = require("../../../javascript/core/Constants.js");
const { TokenUtils } = require("../../../javascript/core/TokenUtils.js");
const { Testbed } = require("../../../javascript/test/testbed.js");

describe("getPourQuantities", function () {
	const splits = 15;
	let testbed;

	beforeEach(async function () {
		testbed = new Testbed(true);
		await testbed.ensureInit();
	});

	it("can call getPourQuantities successfully", async function () {
		const tokenA = await testbed.createToken("TokenA", 8);
		const tokenB = await testbed.createToken("TokenB", 6);
		const pool = await testbed.createPool(tokenA, tokenB, splits, Constants.POSITIVE_TWO, Constants.POSITIVE_HALF);
		const lper = testbed.users[0];
		const result = await testbed.getPourQuantities(lper, tokenA, tokenB, splits, 0, 4096, Constants.POSITIVE_ONE);
		console.log(`getPourQuantities(0, 4096, 1) = ${result}`);
		const hash = await result.wait();
		console.log(`hash = ${hash}`);
	});
});
