#!/usr/bin/env python

import argparse
import json
from eth_account import Account
from eth_account.signers.local import LocalAccount
import IPython
import os
from web3 import Web3

from testbed import Testbed, SymbolConfig
from erc20abi import ERC20_ABI

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
ROOT_DIR = os.path.dirname(os.path.dirname(SCRIPT_DIR))

def parse_args():
    parser = argparse.ArgumentParser(prog='InfinityPool SmartContract Python Environment')
    parser.add_argument('expressions', nargs='*', default=[])
    parser.add_argument('-r', '--chain-rpc-url', default='http://localhost:8545')
    parser.add_argument('-k', '--wallet-private-key', default=None, required=True)
    parser.add_argument('-a', '--artifacts-root', default=os.path.join(ROOT_DIR, 'artifacts'))
    parser.add_argument('-d', '--deployment-json-path', default=None, required=True)
    parser.add_argument('-p', '--pool-abi-path', default=None, required=True)
    parser.add_argument('-s', '--script', default=None)
    return parser.parse_args()

def load_abi(abi_path):
    with open(abi_path) as f:
        abi = json.load(f)
        assert(abi is not None)
        if 'abi' in abi:
            abi = abi['abi']
        return abi

def load_contract(w3, deployment_json, artifacts_root, name):
    if name not in deployment_json:
        raise Exception('missing {} in deployment JSON ({})'.format(name, deployment_json))
    data = deployment_json[name]
    abi = load_abi(os.path.join(artifacts_root, data['abipath']))
    return w3.eth.contract(address=Web3.to_checksum_address(data['address']), abi=abi)

def load_deployment_json(deployment_json_path):
    with open(deployment_json_path) as f:
        return json.load(f)

def to_symbol_config(w3, d: dict):
    contract_address = Web3.to_checksum_address(d['address'])
    instance = w3.eth.contract(address=Web3.to_checksum_address(contract_address), abi=ERC20_ABI)
    return SymbolConfig(
            name=d['name'],
            decimals=d['decimals'],
            address=contract_address,
            contract_instance=instance)

def eval_expression(testbed, expr):
    print('evaluating script:\n{}'.format(expr))
    globals()['testbed'] = testbed
    eval(expr)

def main():
    args = parse_args()
    wallet: LocalAccount = Account.from_key(args.wallet_private_key)
    deployment_json = load_deployment_json(args.deployment_json_path)

    w3 = Web3(Web3.HTTPProvider(args.chain_rpc_url, request_kwargs={'timeout': 60}))
    periphery_contract = load_contract(w3, deployment_json, args.artifacts_root, "peripheryContract")
    factory_contract = load_contract(w3, deployment_json, args.artifacts_root, "factoryContract")
    pool_abi = load_abi(args.pool_abi_path)
    tokens = { k.upper(): to_symbol_config(w3, v) for (k, v) in deployment_json['tokens'].items() }
    testbed = Testbed(w3, wallet, periphery_contract, factory_contract, pool_abi, tokens)

    if args.script:
        with open(args.script) as f:
            exec(f.read(), {'testbed': testbed})
    elif args.expressions:
        for expr in args.expressions:
            eval_expression(testbed, expr)
    else:
        IPython.embed()

if __name__ == '__main__':
    main()
