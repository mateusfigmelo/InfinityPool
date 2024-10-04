"use strict";
const { ethers } = require("hardhat");
const hre = require("hardhat");
const { BigNumber } = require("@ethersproject/bignumber");

class DeployedContractInfo {
	constructor(instance, address) {
		this.instance = instance;
		this.address = address;
	}
};

class HardhatDeployer {
	constructor(signer) {
		this.signer = signer;
	}

	async deploy(name, libraries) {
		var params = { signer: this.signer, libraries: {} };
		if (libraries != undefined) {
			params.libraries = libraries;
		}
		console.debug(`deploying ${name} with libraries ${params.libraries}......`);
		const instance = await hre.ethers.deployContract(name, params);
		return new DeployedContractInfo(instance, await instance.getAddress());
	}
}

class ContractDepedencyGraph {
	constructor() {
		this.graph = {};
	}
	addDependencies(name, dependencies = []) {
		this.graph[name] = { dependencies: dependencies };
		return this;
	}

	async deploy(root, deployer) {
		let deployedContracts = {};
		await this.deployRecursive(root, deployer, deployedContracts);
		return deployedContracts;
	}

	// deployer.deploy returns DeployedContractInfo
	async deployRecursive(root, deployer, deployedContracts) {
		if (deployedContracts[root] != undefined) return deployedContracts[root];
		const dependencies = this.graph[root].dependencies;
		if (dependencies == undefined || dependencies.length == 0) {
			//deployedContracts[root] = await hre.ethers.deployContract(root, {signer: deployer});
			console.debug(`deploying ${root} with no dependencies ......`);
			deployedContracts[root] = await deployer.deploy(root, []);
		} else {
			let libraries = {};
			for (const dependency of dependencies) {
				const deployed = await this.deployRecursive(dependency, deployer, deployedContracts);
				console.debug(`adding dependency ${root}:${dependency} => ${deployed.address}`);
				libraries[dependency] = deployed.address;
			}
			// deployedContracts[root] = await hre.ethers.deployContract(root, {libraries: libraries, signer: deployer});
			console.debug(`deploying ${root} with dependencies ${dependencies} ......`);
			deployedContracts[root] = await deployer.deploy(root, libraries);
		}
		return deployedContracts[root];
	}
}



const InfinityPoolContractDependencyGraph = new ContractDepedencyGraph()
	.addDependencies('PiecewiseGrowthNew')
	.addDependencies('GrowthSplitFrame', ['PiecewiseGrowthNew'])
	.addDependencies('JumpyAnchorFaber')
	.addDependencies('JumpyFallback')
	.addDependencies('GapStagedFrame', ['JumpyFallback', 'JumpyAnchorFaber', 'GrowthSplitFrame'])
	.addDependencies('EachPayoff', ['GapStagedFrame', 'GrowthSplitFrame'])
	.addDependencies('EraBoxcarMidSum')
	.addDependencies('Spot', ['GrowthSplitFrame', 'EachPayoff'])
	.addDependencies('SubAdvanceHelpers', ['GrowthSplitFrame', 'EachPayoff'])
	.addDependencies('SubAdvance', ['GrowthSplitFrame', 'EraBoxcarMidSum', 'SubAdvanceHelpers', 'EachPayoff', 'JumpyAnchorFaber', 'Spot'])
	.addDependencies('Advance', ['EachPayoff', 'SubAdvance', 'JumpyAnchorFaber', 'JumpyFallback', 'Spot'])
	.addDependencies('LPShed')
	.addDependencies('LP', ['LPShed', 'GrowthSplitFrame', 'EachPayoff', 'JumpyAnchorFaber', 'JumpyFallback', 'GapStagedFrame'])
	.addDependencies('AnyPayoff', ['EraBoxcarMidSum'])
	.addDependencies('SwapperInternal', ['GapStagedFrame', 'GrowthSplitFrame', 'JumpyAnchorFaber', 'JumpyFallback', 'AnyPayoff'])
	.addDependencies('Swapper', ['SwapperInternal'])
	.addDependencies('NewLoan', ['Swapper', 'SwapperInternal'])
	.addDependencies('UserPay')
	.addDependencies('PoolReader', ['LP', 'LPShed', 'GrowthSplitFrame'])
	.addDependencies('PoolConstructor', ['EraBoxcarMidSum', 'GrowthSplitFrame', 'JumpyAnchorFaber'])
	.addDependencies('CollectNetted', ['Advance', 'UserPay'])
	.addDependencies('TestInfinityPoolHelper')
	.addDependencies('InfinityPoolsFactory', [
		'NewLoan', 'Spot', 'Advance', 'LP', 'Swapper', 'UserPay', 'PoolReader',
		'PoolConstructor', 'CollectNetted'
	])
	.addDependencies('TestInfinityPoolFactory', [
		'NewLoan', 'Spot', 'Advance', 'LP', 'Swapper', 'UserPay', 'PoolReader',
		'PoolConstructor', 'CollectNetted', 'TestInfinityPoolHelper'
	]);



async function deployInfinityPoolsPeriphery(signer, weth, permit2Address, factoryContractName = "InfinityPoolsFactory") {
	const deployer = new HardhatDeployer(signer);
	const deployedContracts = await InfinityPoolContractDependencyGraph.deploy(factoryContractName, deployer);
	const PeripheryActions = await hre.ethers.getContractFactory("PeripheryActions");
	const peripheryActions = await PeripheryActions.deploy();
	const InfinityPoolsPeriphery = await hre.ethers.getContractFactory("InfinityPoolsPeriphery", { libraries: { PeripheryActions: peripheryActions.target } });

	const periphery = await InfinityPoolsPeriphery.deploy();
	await periphery.initialize(deployedContracts[factoryContractName].instance, weth, permit2Address);
	return {
		factory: deployedContracts[factoryContractName].instance,
		periphery: periphery,
		deployedContracts: deployedContracts,
	};
}

Object.defineProperty(exports, "__esModule", { value: true });
exports.HardhatDeployer = HardhatDeployer;
exports.InfinityPoolContractDependencyGraph = InfinityPoolContractDependencyGraph;
exports.deployInfinityPoolsPeriphery = deployInfinityPoolsPeriphery;
