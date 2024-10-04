#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO_ROOT=$(dirname $(dirname $SCRIPT_DIR))

fail () {
  echo "Error: $@"
  exit 1
}

USAGE="usage: $0 [-T] [-k PRIVATE_KEY] [-n|--testnet-name NAME] [-u|--json-rpc-url URL] [-w|--weth WETH-ADDRESS]"

TEST_FLAG=
TESTNET_NAME=tenderly
DEPLOYMENT_PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 
WETH_ADDRESS=0x82aF49447D8a07e3bd95BD0d56f35241523fBab1
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo $USAGE
      exit 0
      ;;
    -u|--json-rpc-url)
      shift # past argument
      JSON_RPC_URL=$1
      shift # value
      ;;
    -n|--testnet-name)
      shift # past argument
      TESTNET_NAME=$1
      shift # value
      ;;
    -k|--private-key)
      shift # past argument
      DEPLOYMENT_PRIVATE_KEY=$1
      shift # value
      ;;
    -w|--weth)
      shift # past argument
      WETH_ADDRESS=$1
      shift # value
      ;;
    -T|--deploy-test-contract) # for docker image build
      TEST_FLAG=-T
      shift # past argument
      ;;
    -*|--*)
      fail "Unknown option $1"
      exit 1
      ;;
    *)
      # POSITIONAL_ARGS+=("$1") # save positional arg
      # shift # past argument
      fail "unknown positional argument $1"
      exit 1
      ;;
  esac
done

if [ -z "$DEPLOYMENT_PRIVATE_KEY" ]; then
  echo "Error: DEPLOYMENT_PRIVATE_KEY cannot be empty!"
  exit 1
fi
if [ -z "$TESTNET_NAME" ]; then
  echo "Error: TESTNET_NAME cannot be empty!"
  exit 1
fi
if [ -z "$WETH_ADDRESS" ]; then
  echo "Error: WETH_ADDRESS cannot be empty!"
  exit 1
fi
if [ -z "$JSON_RPC_URL" ]; then
  echo "Error: missing JSON_RPC_URL!"
  exit 1
fi
cd $REPO_ROOT
RESULTS_DIR=$REPO_ROOT/deployment/results/$TESTNET_NAME
mkdir -p $RESULTS_DIR
node scripts/hardhat/deploy.js $TEST_FLAG \
        -n testnet \
        -r $JSON_RPC_URL \
        -w $WETH_ADDRESS \
	-k $DEPLOYMENT_PRIVATE_KEY \
        -o $RESULTS_DIR/deployed-$(date +%s).json
