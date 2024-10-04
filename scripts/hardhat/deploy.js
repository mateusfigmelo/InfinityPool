"use strict";
const { BigNumber } = require("@ethersproject/bignumber");
const { Command } = require('commander');
const fs = require('fs');

function makePoolSpec(token0, token1, splits) {
	return { token0: token0, token1: token1, splits: splits };
}

function parsePoolSpec(spec, defaultSplits, validTokenNames) {
	const parts = spec.split(':');
	if (parts.length < 2 || parts.length > 3) {
		throw new Error(`invalid pool spec (${spec}); expecting token-name:token-name[:splits]`);
	}
	const token0 = parts[0].trim().toUpperCase();
	if (!validTokenNames.includes(token0))
		throw new Error(`invalid pool spec (${spec}); invalid token0 name ${parts[0]}; valid names are ${validTokenNames}`);
	const token1 = parts[1].trim().toUpperCase();
	if (!validTokenNames.includes(token1))
		throw new Error(`invalid pool spec (${spec}); invalid token1 name ${parts[1]}; valid names are ${validTokenNames}`);
	if (token0 == token1)
		throw new Error(`invalid pool spec (${spec}); token0 (${token0}) == token1 (${token1})`);
	const splits = parts.length == 3 ? parseInt(parts[2]) : defaultSplits;
	if (splits < 12)
		throw new Error(`invalid pool spec (${spec}); splits (${splits}) < 12`);
	return makePoolSpec(token0, token1, splits);
}

function parseTokenSpec(spec) {
	const parts = spec.split(':');
	if (parts.length != 2) {
		throw new Error(`invalid token spec (${spec}); expecting name:decimals`);
	}
	return { name: parts[0], decimals: parseInt(parts[1]) };
}


// https://www.npmjs.com/package/commander
// or https://www.digitalocean.com/community/tutorials/nodejs-command-line-arguments-node-scripts
const program = new Command();
program
	.name('deploy')
	.description('deploy the factory, pools, periphery and test token contracts')
	.argument('[pools...]', 'pools to deploy, each pool=tokenA-name:tokenB-name[:splits]')
	.option('-v, --verbose', 'verbose', false)
	.option('-T, --deploy-test-pools-and-factory', 'deploy TestInfinityPoolFactory and TestInfinityPools.', false)
	.option('-k, --deployer-private-key <string>', 'use the specified key instead.')
	//.option('-C, --compile-contracts', 'compile the contracts first.', false)
	.option('-m, --mint-token-amount <int>', 'mint tokens for each account.')
	.option('-n, --network <string>', 'use the network.')
	.option('-r, --json-rpc-url <string>', 'the JSON RPC URL for the network.')
	.option('-A, --deploy-all-pool-pairs', 'deploy pools of all pairs using the default splits.', false)
	.option('-s, --default-splits <int>', 'default splits value.', 15)
	.option('-S, --json-output-spacing <int>', 'JSON output spacing when saved to file.')
	.option('-I, --include-contract-abi', 'include the ABI in the JSON output.', false)
	.option('-w, --weth-address <string>', 'the address of deployed WETH contract.')
	.option('-p, --permit2-address <string>', 'the address of deployed Permit2 contract.', '0x000000000022d473030f116ddee9f6b43ac78ba3')
	.option('-t, --tokens [tokens...]', 'specify Test ERC20 tokens; each token is specified by name:decimals', [])
	.option('-o, --json-output-path <string>', 'save the JSON output to a file')
	.version('0.0.1');

function configureHardhatNetwork(options) {
	// https://hardhat.org/hardhat-runner/docs/reference/environment-variables
	if (options.network == undefined) {
		process.env.HARDHAT_NETWORK = undefined;
		console.log(`using the default network`);
	} else if (options.network == "anvil" || options.network == "hardhat" || options.network == "localhost") {
		process.env.HARDHAT_NETWORK = options.network;
		console.log(`using network ${process.env['HARDHAT_NETWORK']}`);
	} else if (options.network == "localdev") {
		if (options.jsonRpcUrl == undefined) {
			throw new Error(`missing jsonRpcUrl (-r) for network ${options.network}`);
		}
		process.env.HARDHAT_NETWORK = options.network;
		process.env.TESTNET_JSON_RPC_URL = options.jsonRpcUrl;
		console.log(`using network ${process.env['HARDHAT_NETWORK']} with JSON RPC URL ${process.env['TESTNET_JSON_RPC_URL']}`);
	} else if (options.network == "testnet") {
		if (options.jsonRpcUrl == undefined) {
			throw new Error(`missing jsonRpcUrl (-r) for network ${options.network}`);
		}
		if (options.wethAddress == undefined) {
			throw new Error(`missing WETH address (-w) for network ${options.network}`);
		}
		process.env.HARDHAT_NETWORK = options.network;
		process.env.TESTNET_JSON_RPC_URL = options.jsonRpcUrl;
		console.log(`using network ${process.env['HARDHAT_NETWORK']} with JSON RPC URL ${process.env['TESTNET_JSON_RPC_URL']}`);
	} else {
		throw new Error(`unknown network ${options.network} specified`);
	}
}

async function deploy(program) {
	program.parse();
	const options = program.opts();
	configureHardhatNetwork(options);

	// N.B. We have to load Hardhat after we set the environment variables.
	const { Deployer } = require("../../javascript/core/deployCore.js");
	// const { compile } = require("hardhat")
	const hre = require("hardhat");
	// Always compile
	console.log('compiling the contracts ......');
	await hre.run('compile');
	console.log('done compiling the contracts.');

	const tokenAmountToMint = options.mintTokenAmount == undefined ? undefined : BigNumber.from(options.mintTokenAmount);
	console.log(`parsing token specs: [${options.tokens}]`);
	const tokens = options.tokens.map((spec) => parseTokenSpec(spec));
	console.log(`token to deploy: ${JSON.stringify(tokens)}`);
	const validTokenNames = tokens.map((token) => token.name.trim().toUpperCase());
	validTokenNames.push('WETH');
	console.log(`parsing pools specs: [${program.args}]`);
	var poolsToDeploy = program.args.map((spec) => parsePoolSpec(spec, options.defaultSplits, validTokenNames));
	if (options.deployAllPoolPairs) {
		// TODO: use poolsToDeploy to override the default-generated pools via -A
		if (program.args.length > 0) console.warn(`ignoring pools ${program.args} because -A is set`);
		poolsToDeploy = validTokenNames.flatMap((token0, i) => validTokenNames.slice(i + 1).map((token1) =>
			makePoolSpec(token0, token1, options.defaultSplits)
		));
	}
	console.log(`pools to deploy: ${JSON.stringify(poolsToDeploy)}`);

	const factoryContractName = options.deployTestPoolsAndFactory ? 'TestInfinityPoolFactory' : 'InfinityPoolsFactory';
	const poolContractName = options.deployTestPoolsAndFactory ? 'TestInfinityPool' : 'InfinityPool';
	const srcDir = options.deployTestPoolsAndFactory ? 'src/mock' : 'src';
	const result = await (new Deployer()).deploy({
		deployerPrivateKey: options.deployerPrivateKey,
		factoryContractName: factoryContractName,
		poolContractName: poolContractName,
		srcDir: factoryContractName,
		tokens: tokens,
		pools: poolsToDeploy,
		tokenAmountToMint: tokenAmountToMint,
		includeABI: options.includeContractAbi,
		wethAddress: options.wethAddress,
		permit2Address: options.permit2Address,
	});
	if (options.jsonOutputPath != undefined && options.jsonOutputPath != '') {
		var data = JSON.stringify(result);
		console.log(`saving JSON result ${data} to ${options.jsonOutputPath} ......`);
		if (options.jsonOutputSpacing != undefined) {
			data = JSON.stringify(result, undefined, parseInt(options.jsonOutputSpacing));
		}
		fs.writeFileSync(options.jsonOutputPath, data, (err) => {
			if (err) throw err;
		});
	} else {
		console.log(`${JSON.stringify(result)}`);
	}
}
deploy(program).then(() => process.exit(0)).catch(error => { console.error(error); process.exit(1); });
