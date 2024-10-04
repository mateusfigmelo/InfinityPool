const { TestbedWithTestContract } = require("../test/unit/hardhat/testpool/testbed.js");
const { Constants } = require("../javascript/core/Constants.js");
const splits = 15;

async function benchmark() {
	const testbed = new TestbedWithTestContract();
	await testbed.ensureInit();
	const tokenA = await testbed.createToken("TokenA", 8);
	const tokenB = await testbed.createToken("TokenB", 6);
	const pool = await testbed.createPool(tokenA, tokenB, splits, Constants.POSITIVE_TWO, Constants.POSITIVE_HALF);
	const lper = testbed.users[0]

	const spans = [ 4096 ];
	const starts = [0];

	// console.log(`getLiquidityInfo(startTub, stopTub) using BoxcarTubFrame.apply_`)
	for (const startTub of starts) {
		for (const span of spans) {
			const stopTub = startTub + span;
			if (stopTub <= 4096) {
				const t0 = performance.now();
				const result = await pool.pool.connect(lper).getLiquidityInfo(startTub, stopTub);
				const t1 = performance.now();
				const dt = t1 - t0;
				console.log(`getLiquidityInfo(${startTub}, ${stopTub}): ${dt} ms`);
			}
		}
	}
}

benchmark()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
