# JS Deployer

Deploy the factory, pools, periphery and test token contracts as well as optionally minting the tokens.

## Token specification
The token is specified by `name:decimals`.

## Pool specification
A pool to be deployed can be specified as `tokenA-name:tokenB-name[:splits]`.
For examples, `tokenA:tokenB` and `tokenA:tokenB:13`.

## Saving the JSON result
The info regarding the deployed contracts is stored as a JSON object.

By default, the deployment result is printed to the console as a single-line JSON string.

One can also save it to a file by supplying the `-o filepath` option.

## Usage
```
Usage: deploy [options] [pools...]

deploy the factory, pools, periphery and test token contracts

Arguments:
  pools                                pools to deploy, each pool=tokenA-name:tokenB-name[:splits]

Options:
  -v, --verbose                        verbose (default: false)
  -T, --deploy-test-pools-and-factory  deploy TestInfinityPoolFactory and TestInfinityPools. (default: false)
  -k, --deployer-private-key <string>  use the specified key instead.
  -m, --mint-token-amount <int>        mint tokens for each account.
  -n, --network <string>               use the network.
  -r, --json-rpc-url <string>          the JSON RPC URL for the network.
  -A, --deploy-all-pool-pairs          deploy pools of all pairs using the default splits. (default: false)
  -s, --default-splits <int>           default splits value. (default: 15)
  -S, --json-output-spacing <int>      JSON output spacing when saved to file.
  -I, --include-contract-abi           include the ABI in the JSON output. (default: false)
  -w, --weth-address <string>          the address of deployed WETH contract.
  -p, --permit2-address <string>       the address of deployed Permit2 contract. (default: "0x000000000022d473030f116ddee9f6b43ac78ba3")
  -t, --tokens [tokens...]             specify Test ERC20 tokens; each token is specified by name:decimals (default: [])
  -o, --json-output-path <string>      save the JSON output to a file
  -V, --version                        output the version number
  -h, --help                           display help for command
```

## Examples
```
node scripts/hardhat/deploy.js -T -n testnet -r https://virtual.arbitrum.rpc.tenderly.co/????????-????-????-????-???????????? -k 0x????????????????????????????????????????????????????????????????
node scripts/hardhat/deploy.js -T -t a:8 b:9 -- a:WETH
node scripts/hardhat/deploy.js -t a:8 -t b:9 -A
node scripts/hardhat/deploy.js -t a:8 -t b:9 -A -m 200000
node scripts/hardhat/deploy.js -t a:8 -t b:9 -- a:WETH b:WETH
node scripts/hardhat/deploy.js -t a:8 -t b:9 -o junk -- a:WETH a:b:13
node scripts/hardhat/deploy.js -t a:8 -t b:9 -o junk -S 2 -- a:WETH b:WETH
```
