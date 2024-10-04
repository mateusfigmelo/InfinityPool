from dataclasses import dataclass
from datetime import datetime
from decimal import *
from eth_account.messages import encode_defunct
import json
import time
from web3 import Web3

@dataclass
class SymbolConfig:
    name: str
    decimals: int
    address: str
    contract_instance: object

    def toNative(self, amount: Decimal):
        return int(Decimal(amount) * Decimal('1' + '0' * self.decimals))

    def fromNative(self, amount: int):
        return Decimal(amount) / Decimal('1' + '0' * self.decimals)

@dataclass
class LiquidityRatio:
    baseSize: Decimal
    quoteSize: Decimal

def check_and_raise_error(r, valid_status_codes = [200]):
    if r.status_code not in valid_status_codes:
        raise Exception(r.text)

class Testbed:
    def __init__(self, w3, wallet, periphery_instance, factory_instance, pool_abi: dict, tokens: dict):
        self.web3 = w3
        self.wallet = wallet
        self.periphery_instance = periphery_instance
        self.factory_instance = factory_instance
        self.pool_abi = pool_abi
        self.tokens = tokens

    def get_chain_id(self):
        return self.web3.eth.chain_id

    def get_token(self, name: str):
        return self.tokens[name.upper()]

    def approve_periphery_spending(self, token_name: str, amount: Decimal):
        token = self.get_token(token_name)
        print('approving {} for spending {} {}'.format(self.periphery_instance.address, amount, token_name))
        tx_hash = token.contract_instance.functions.approve(self.periphery_instance.address, token.toNative(amount)).transact({
            "from": self.wallet.address,
            "chainId": self.get_chain_id(),
            "nonce": self.web3.eth.get_transaction_count(account=self.wallet.address),
        })
        assert(tx_hash is not None)
        tx_receipt = self.web3.eth.wait_for_transaction_receipt(tx_hash)
        print(tx_receipt)

    def token_periphery_allowance(self, token_name: str):
        token = self.get_token(token_name)
        allowance = token.contract_instance.functions.allowance(self.wallet.address, self.periphery_instance.address).call()
        return token.fromNative(allowance)

    def token_balance(self, token_name: str):
        token = self.get_token(token_name)
        balance = token.contract_instance.functions.balanceOf(self.wallet.address).call()
        return token.fromNative(balance)

    def create_pool(self, token0: str, token1: str, splits: int):
        token0_info = self.get_token(token0)
        token1_info = self.get_token(token1)
        tx_hash = self.factory_instance.functions.createPool(
                token0_info.address,
                token1_info.address,
                splits
        ).transact({
            "from": self.wallet.address,
            "chainId": self.get_chain_id(),
            "nonce": self.web3.eth.get_transaction_count(account=self.wallet.address),
        })
        tx_receipt = self.web3.eth.wait_for_transaction_receipt(tx_hash)
        return tx_receipt

    def get_pool(self, token0: str, token1: str, splits: int):
        token0_config = self.get_token(token0)
        token1_config = self.get_token(token1)
        if token0_config.address == token1_config.address:
            raise Exception('{}({}) == {}({})'.format(base, token0_config.address, quote, token1_config.address))
        elif token0_config.address < token1_config.address:
            pool_address = self.factory_instance.functions.getPool(token0_config.address, token1_config.address, splits).call()
        else:
            pool_address = self.factory_instance.functions.getPool(token1_config.address, token0_config.address, splits).call()
        return self.web3.eth.contract(address=Web3.to_checksum_address(pool_address), abi=self.pool_abi)

    def get_minted(self, base: str, quote: str, startTub: int, stopTub: int, splits: int=15):
        pool = self.get_pool(base, quote, splits)
        return pool.functions.getMinted(startTub, stopTub).call()

    def get_used(self, base: str, quote: str, startBin: int, stopBin: int, splits: int=15):
        pool = self.get_pool(base, quote, splits)
        return pool.functions.getUsed(startBin, stopBin).call()

    def add_liquidity(
            self,
            base: str,
            quote: str,
            lowerTick: int,
            upperTick: int,
            desiredBaseSize: Decimal,
            desiredQuoteSize: Decimal,
            minBaseSize: Decimal = Decimal(0),
            minQuoteSize: Decimal = Decimal(0)):
        token0 = self.get_token(base)
        token1 = self.get_token(quote)
        if token0.address == token1.address:
            raise Exception('{}({}) == {}({})'.format(base, token0.address, quote, token1.address))
        elif token0.address > token1.address:
            return self.add_liquidity(
                    quote, base, -upperTick, -lowerTick, desiredQuoteSize, desiredBaseSize, minQuoteSize, minBaseSize)
        req = {
                'token0': token0.address,
                'token1': token1.address,
                'splits': 15,
                'startEdge': lowerTick,
                'stopEdge': upperTick,
                'amount0Desired': token0.toNative(desiredBaseSize),
                'amount1Desired': token1.toNative(desiredQuoteSize),
                'amount0Min': token0.toNative(minBaseSize),
                'amount1Min': token1.toNative(minQuoteSize)
        }
        tx_hash = self.periphery_instance.functions.addLiquidity(req).transact({
            "from": self.wallet.address,
            "chainId": self.get_chain_id(),
            "nonce": self.web3.eth.get_transaction_count(account=self.wallet.address),
        })
        tx_receipt = self.web3.eth.wait_for_transaction_receipt(tx_hash)
        return tx_receipt
