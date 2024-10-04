/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-foundry");
require("@nomicfoundation/hardhat-ethers");
require("dotenv").config();
require("@nomicfoundation/hardhat-chai-matchers");
require("hardhat-tracer");

const privateKey = process.env.PRIVATE_KEY;
const accounts = privateKey ? [privateKey] : { mnemonic: "test test test test test test test test test test test junk" };

module.exports = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    testnet: {
      url: `${process.env.TESTNET_JSON_RPC_URL}`,
      accounts: accounts,
    },
    localdev: {
      url: `${process.env.TESTNET_JSON_RPC_URL}`,
      accounts: accounts,
    },
    anvil: {
      allowUnlimitedContractSize: true,
      url: "http://0.0.0.0:8545",
      accounts: accounts,
      timeout: 100000000,
    },
    hardhat: {
      allowUnlimitedContractSize: true,
      forking: {
        enabled: process.env.FORKING === "true",
        url: `${process.env.MAINNET_RPC_URL}`,
      },
    },
  },
  tenderly: {
    project: "project",
    username: "yashnaman",
    privateVerification: true,
  },
};
