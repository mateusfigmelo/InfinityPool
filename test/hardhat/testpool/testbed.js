"use strict";
const { TokenUtils } = require("../../../javascript/core/TokenUtils.js");
const { Constants } = require("../../../javascript/core/Constants.js");
const { Testbed } = require("../../../javascript/test/testbed.js");
// const bscPancakeRouterV2Address = "0x10ED43C718714eb63d5aA57B78B54704E256024E";

class TestbedWithTestContract extends Testbed {
	// override
	factoryContractName() {
		return "TestInfinityPoolFactory";
	}

	poolContractName() {
		return "TestInfinityPool";
	}

	async getUsed(user, tokenA, tokenB, splits, startBin, stopBin) {
		return await this.periphery.connect(user).getUsed(tokenA, tokenB, splits, startBin, stopBin);
	}

	async getMinted(user, tokenA, tokenB, splits, startTub, stopTub) {
		return await this.periphery.connect(user).getMinted(tokenA, tokenB, splits, startTub, stopTub);
	}

	async getAllMinted(user, tokenA, tokenB, splits) {
		return await this.periphery.connect(user).getMintedRaw(tokenA, tokenB, splits);
	}
}

Object.defineProperty(exports, "__esModule", { value: true });
exports.TestbedWithTestContract = TestbedWithTestContract;
