"use strict";
const { ethers } = require("hardhat");
const hre = require("hardhat");
const { BigNumber } = require("@ethersproject/bignumber");
const { deployInfinityPoolsPeriphery } = require('./DeployGraph.js');
const { Constants } = require("./Constants.js");
const { TokenUtils } = require("./TokenUtils.js");
const Z = false;
const I = true;

class Deployer {
	constructor() { }

	async addTokenToResult(result, name, token) {
		const decimals = await token.decimals();
		result.tokens[name] = {};
		result.tokens[name].name = name;
		result.tokens[name].decimals = Number(decimals);
		result.tokens[name].address = await token.target;
	}

	getPairKey(token0, token1) { return `${token0.target}:${token1.target}`; }

	getSplitsKey(splits) { return `${splits}`; }

	addPool(result, token0, token1, splits, poolAddress) {
		if (!result.hasOwnProperty('pools')) {
			result.pools = {};
		}
		const pairKey = this.getPairKey(token0, token1);

		if (!result.pools.hasOwnProperty(pairKey)) {
			result.pools[pairKey] = {};
		}
		const splitsKey = this.getSplitsKey(splits);
		console.assert(!result.pools[pairKey].hasOwnProperty(splitsKey));
		result.pools[pairKey][splitsKey] = {};
		result.pools[pairKey][splitsKey].poolAddress = poolAddress;
	}

	isPoolCreated(result, token0, token1, splits) {
		const pairKey = this.getPairKey(token0, token1);
		return result.hasOwnProperty('pools') &&
			result.pools.hasOwnProperty(pairKey) &&
			result.pools[pairKey].hasOwnProperty(this.getSplitsKey(splits));
	}

	async createPool(infinityPoolsFactory, tokenA, tokenB, splits, initialPoolPrice, quadVar, result) {
		const [token0, token1] = (BigNumber.from(tokenA.target) < BigNumber.from(tokenB.target)) ?
			[tokenA, tokenB] : [tokenB, tokenA];
		if (this.isPoolCreated(result, token0, token1, splits)) {
			throw new Error(`Pool(${token0.target}, ${token1.target}, ${splits}) has already been created!`);
		}
		await infinityPoolsFactory.createPool(token0.target, token1.target, splits, result);
		const poolAddress = await infinityPoolsFactory.getPool(token0.target, token1.target, splits);
		const pool = await hre.ethers.getContractAt("InfinityPool", poolAddress);
		await pool.setInitialPriceAndVariance(initialPoolPrice, quadVar);
		this.addPool(result, token0, token1, splits, poolAddress);
	}

	async getDeployedERC20(name, address) {
		// return await hre.ethers.Contract(address, ERC20_ABI, hre.ethers.provider);
		return await hre.ethers.getContractAt(name, address);
	}

	async deployWETH(deployer) {
		const WETH9 = await hre.ethers.getContractFactory("WETH9");
		return await WETH9.connect(deployer).deploy();
	}

	async deploy(params) {
		const srcDir = params.srcDir;
		let signers = await hre.ethers.getSigners();
		console.log(`found ${signers.length} signers`);
		const deployer = params.deployerPrivateKey == undefined ?
			signers[0] : new hre.ethers.Wallet(params.deployerPrivateKey, hre.ethers.provider);
		var result = {};
		result.deployer = deployer.address;
		const preDeployBlock = await hre.ethers.provider.getBlock("latest");
		result.preDeployBlock = {
			blkno: preDeployBlock.number,
			timestamp: preDeployBlock.timestamp,
		};

		result.tokens = {};
		let weth;
		if (params.wethAddress == undefined) {
			console.log(`deploying WETH9 contract ......`);
			weth = await this.deployWETH(deployer);
			await this.addTokenToResult(result, 'WETH', weth);
		} else {
			console.log(`getting WETH contract instance at ${params.wethAddress} ......`);
			weth = await this.getDeployedERC20('WETH9', params.wethAddress);
		}
		let deployedTokens = { 'WETH': weth };
		const Token = await hre.ethers.getContractFactory("Token");
		for (const token of params.tokens) {
			const key = token.name.trim().toUpperCase();
			if (deployedTokens[key] != undefined) {
				console.warn(`token ${key} has already been deployed!`);
				continue;
			}
			console.log(`deploying test token ${JSON.stringify(token)} ......`);
			const deployed = await Token.connect(deployer).deploy(token.name, token.name, token.decimals);
			deployedTokens[key] = deployed;
			await this.addTokenToResult(result, key, deployed);

			if (params.tokenAmountToMint != undefined) {
				const mintAmount = BigNumber.from(params.tokenAmountToMint);
				const nativeAmount = await TokenUtils.toNativeAmount(deployed, mintAmount);
				console.log(`minting ${mintAmount} (${nativeAmount}) ${token.name} for each account ......`);
				for (const signer of signers) {
					const addr = signer.address;
					console.log(`minting ${mintAmount} (${nativeAmount}) ${token.name} for ${addr} ......`);
					await deployed.connect(deployer).mint(addr, nativeAmount);
					console.log(`${addr}[${token.name}] =  ${await deployed.balanceOf(addr)}`);
				}
			}
		}

		console.log(`using permit2 address ${params.permit2Address}`);
		console.log('deploying the contracts ......');
		const deployResult = await deployInfinityPoolsPeriphery(
			deployer, weth, params.permit2Address, params.factoryContractName
		);

		result.factoryContract = {
			address: await deployResult.factory.getAddress(),
			abipath: `artifacts/${srcDir}/${params.factoryContractName}.sol/${params.factoryContractName}.json`,
		};
		result.peripheryContract = {
			address: await deployResult.periphery.getAddress(),
			abipath: "artifacts/src/periphery/InfinityPoolsPeriphery.sol/InfinityPoolsPeriphery.json",
		};
		result.poolContract = {
			abipath: `artifacts/${srcDir}/${params.poolContractName}.sol/${params.poolContractName}.json`
		};

		for (const pool of params.pools) {
			const tokenA = deployedTokens[pool.token0.trim().toUpperCase()];
			const tokenB = deployedTokens[pool.token1.trim().toUpperCase()];
			console.log(`creating pool ${JSON.stringify(pool)} ......`);
			await this.createPool(
				deployResult.factory,
				tokenA,
				tokenB,
				pool.splits,
				Constants.POSITIVE_ONE, // TODO: customizable
				Constants.POSITIVE_HALF, // TODO: customizable
				result,
			);
		}

		// https://hardhat.org/hardhat-runner/docs/advanced/artifacts
		if (params.includeABI) {
			console.log(`reading ABI for ${params.factoryContractName} ......`);
			result.factoryContract.abi = (await hre.artifacts.readArtifact(params.factoryContractName)).abi;
			console.log(`reading ABI for ${params.poolContractName} ......`);
			result.poolContract.abi = (await hre.artifacts.readArtifact(params.poolContractName)).abi;
			console.log(`reading ABI for InfinityPoolsPeriphery ......`);
			result.peripheryContract.abi = (await hre.artifacts.readArtifact('InfinityPoolsPeriphery')).abi;
		}
		const postDeployBlock = await hre.ethers.provider.getBlock("latest");
		result.postDeployBlock = {
			blkno: postDeployBlock.number,
			timestamp: postDeployBlock.timestamp,
		};
		return result;
	}
};

Object.defineProperty(exports, "__esModule", { value: true });
exports.Deployer = Deployer;
