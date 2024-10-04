# Testnet Deployment

## Set up Forge and NPM packages in the repo
```
curl -L https://foundry.paradigm.xyz | bash && source ~/.bashrc && foundryup
npm ci
```

## Fund the deployer account
### Tenderly
Navigate to the Faucet page on the Tenderly web UI and fund the deployer account with sufficient amount of ETH.

## Record the block number before deployment
This will be automated in the deployment script. But for now, record this number because we will need it to seed
the backend.

## Deploy the contracts
Use `-T` to deploy the test-version of the contracts.
``` 
node scripts/hardhat/deploy.js [-T] \
	-n testnet \
	-k ACCOUNT_PRIVATE_KEY \
	-w WETH_ADDRESS \
	-r TENDERLY_URL \
	-o RESULT_JSON_PATH
```
The result JSON file will be used to start the backend.
