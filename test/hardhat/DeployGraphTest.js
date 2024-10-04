const { expect } = require('chai');
const hre = require('hardhat');
const { Constants } = require('../../javascript/core/Constants.js');
const { TokenUtils } = require('../../javascript/core/TokenUtils.js');
const { Testbed } = require('../../javascript/test/testbed.js');
const { deployInfinityPoolsPeriphery } = require('../../javascript/core/DeployGraph.js');

describe('DeployGraphTest', function () {

	it('can deploy InfinityPoolsFactory and InfinityPoolsPeriphery correctly', async function () {
		const signers = await hre.ethers.getSigners();
		const WETH9 = await hre.ethers.getContractFactory("WETH9");
		const weth = await WETH9.deploy();
		const permit2 = "0x000000000022d473030f116ddee9f6b43ac78ba3";
		const result = await deployInfinityPoolsPeriphery(signers[0], weth, permit2);
		await expect(result.periphery).to.not.be.undefined;
		await expect(result.periphery).to.not.be.null;
		await expect(result.factory).to.not.be.undefined;
		await expect(result.factory).to.not.be.null;
		const expectedKeys = [
			'Advance',
			'AnyPayoff',
			'EachPayoff',
			'EraBoxcarMidSum',
			'GapStagedFrame',
			'GrowthSplitFrame',
			'InfinityPoolsFactory',
			'JumpyAnchorFaber',
			'JumpyFallback',
			'LP',
			'LPShed',
			'NewLoan',
			'PiecewiseGrowthNew',
			'PoolConstructor',
			'PoolReader',
			'Spot',
			'SubAdvance',
			'SubAdvanceHelpers',
			'Swapper',
			'SwapperInternal',
			'UserPay',
			'CollectNetted'
		];
		await expect(result.deployedContracts).to.have.keys(expectedKeys);
	});
});
