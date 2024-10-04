"use strict";
const { Constants } = require("../core/Constants.js");
const { TokenUtils } = require("../core/TokenUtils.js");
const { Infinity } = require("../core/TokenUtils.js");
const { deployInfinityPoolsPeriphery } = require("../core/DeployGraph.js");
// const bscPancakeRouterV2Address = "0x10ED43C718714eb63d5aA57B78B54704E256024E";

class Pool {
	constructor(poolAddress, pool, token0, token1, splits, permit2) {
		this.address = poolAddress;
		this.pool = pool;
		this.token0 = token0;
		this.token1 = token1;
		this.splits = splits;
	}
}

class Testbed {
	constructor(resetHardhat = false) {
		this.resetHardhat = resetHardhat;
		this.initialized = false;
	}

	factoryContractName() {
		return "InfinityPoolsFactory";
	}

	poolContractName() {
		return "InfinityPool";
	}

	async ensureInit() {
		if (!this.initialized) {
			await this._init();
		}
		this.initialized = true;
	}

	async _init() {
		if (this.initialized) {
			return;
		}
		if (this.resetHardhat) {
			await hre.ethers.provider.send("hardhat_reset", [{
				// forking: { jsonRpcUrl: "https://bsc-dataseed1.binance.org/" }
			}]);
		}
		this.signers = await hre.ethers.getSigners();
		this.deployer = this.signers[0];
		this.users = this.signers.slice(1, this.signers.length);
		// console.log(`user0 = ${this.users[0].address}`);
		this.TokenFactory = await hre.ethers.getContractFactory("Token");

		const WETH9 = await hre.ethers.getContractFactory("WETH9");
		const weth = await WETH9.deploy();
		const permit2 = "0x000000000022d473030f116ddee9f6b43ac78ba3";

		const result = await deployInfinityPoolsPeriphery(
			this.deployer, weth, permit2, this.factoryContractName(),
		);
		this.infinityPoolsFactory = result.factory;
		this.periphery = result.periphery;
		this.peripheryAddress = await this.periphery.getAddress();
	}

	// returns Pool
	async createPool(tokenA, tokenB, splits, initialPoolPrice, quadVar) {
		const [token0, token1] = TokenUtils.orderTokenPair(tokenA, tokenB);
		let tx = await this.infinityPoolsFactory.createPool(token0.target, token1.target, splits);
		await tx.wait();
		const poolAddress = await this.infinityPoolsFactory.getPool(token0.target, token1.target, splits);
		const pool = await hre.ethers.getContractAt(this.poolContractName(), poolAddress);
		tx = await pool.setInitialPriceAndVariance(initialPoolPrice, quadVar);
		await tx.wait();
		return new Pool(poolAddress, pool, token0, token1, splits);
	}

	async createToken(name, decimals) {
		return await this.TokenFactory.deploy(name, name, decimals);
	}

	// TODO: update the interface to using pool instead of tokenA, tokenB, splits
	async getPourQuantities(user, tokenA, tokenB, splits, startTub, stopTub, liquidity) {
		const poolAddress = await this.infinityPoolsFactory.getPool(tokenA, tokenB, splits);
		const pool = await hre.ethers.getContractAt(this.poolContractName(), poolAddress);
		return await pool.connect(user).getPourQuantities(startTub, stopTub, liquidity);
	}

	async addLiquidity(user, params) {
		return await this.periphery.connect(user).addLiquidity(params);
	}
	async addLiquidity(user, params, value) {
		return await this.periphery.connect(user).addLiquidity(params, { value: value });
	}

	async addLiquidityAndDrain(user, params) {

		const addLiquidityCall = this.periphery.interface.encodeFunctionData("addLiquidity", [params]);
		const tokenId = 0;
		const drainCall = this.periphery.interface.encodeFunctionData("drain", [tokenId, params.receiver]);

		const calls = [addLiquidityCall, drainCall];

		return await this.periphery.connect(user).multicall(calls);
	}

	async getLiquidityPosition(user, pool, lpNum) {
		const poolAddress = await this.infinityPoolsFactory.getPool(pool.token0, pool.token1, pool.splits);
		const poolContract = await hre.ethers.getContractAt(this.poolContractName(), poolAddress);

		return await poolContract
			.connect(user)
			.getLiquidityPosition(lpNum);
	}


	extractFirstEventFromReceipt(receipt, name) {
		for (const event of receipt.logs) {
			if (event.fragment && event.fragment.name == name) {
				return event;
			}
		}
		return undefined;
	}
};

Object.defineProperty(exports, "__esModule", { value: true });
exports.Testbed = Testbed;
