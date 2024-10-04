"use strict";
const { BigNumber } = require("@ethersproject/bignumber");
const bscPancakeRouterV2Address = "0x10ED43C718714eb63d5aA57B78B54704E256024E";

const TokenUtils = new class {
	orderTokenPair(tokenA, tokenB) {
		if (BigNumber.from(tokenA.target).lt(BigNumber.from(tokenB.target))) {
			return [tokenA, tokenB];
		} else {
			return [tokenB, tokenA];
		}
	}

	async toNativeAmount(token, amount) {
		const decimals = await token.decimals();
		return BigNumber.from(amount).mul(BigNumber.from("10").pow(BigNumber.from(decimals))).toBigInt();
	}

	async getTokenBalance(token, address) {
		const decimals = await token.decimals();
		const nativeAmount = await token.balanceOf(address);
		return BigNumber.from(nativeAmount).div(BigNumber.from("10").pow(BigNumber.from(decimals)));
	}

	async formateUnits(token, amount) {
		const decimals = await token.decimals();
		return BigNumber.from(amount).div(BigNumber.from("10").pow(BigNumber.from(decimals)));

	}

	async mintDecimal(token, address, amount) {
		const nativeAmount = await this.toNativeAmount(token, amount);
		await token.mint(address, nativeAmount);
	}
};

Object.defineProperty(exports, "__esModule", { value: true });
exports.TokenUtils = TokenUtils;
