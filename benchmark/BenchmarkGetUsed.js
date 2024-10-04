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

	// console.log("testing getUsed(0, 300)");
	// await pool.pool.connect(lper).getUsed(0, 300);

	const spans = [
		1, 2, 4, 8, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 150, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 2000, 4096
	];
	const starts = [
		0, 1, 2, 3, 501, 1001, 2048, 2049,
	]
	console.log("testing getUsed with multiple startBins and spans");
	for (const startBin of starts) {
		for (const span of spans) {
			const stopBin = startBin + span;
			if (stopBin <= 4096 * 2) {
				const t0 = performance.now();
				const tx = await pool.pool.connect(lper).getUsed(startBin, stopBin);
				const t1 = performance.now();
				const dt = t1 - t0;
				console.log(`getUsed(${startBin}, ${stopBin}): ${dt} ms (${tx.hash})`);
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
