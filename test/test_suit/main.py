import requests
from web3 import Web3, HTTPProvider
import web3
import subprocess
import json
import bcrypt

source_file = './examples/storage.exm'


def compile(src_filename):
    out_dir = "/Users/nikitosing/PycharmProjects/elixireum_tests/"
    out_json = f"{out_dir}qwe.json"
    out_abi = f"{out_dir}abi.json"

    subprocess.check_output(f"source ~/.zshrc; mix gen {src_filename} --out {out_json} --abi {out_abi}",
                            cwd='/Users/nikitosing/study/thesis/elixireum', shell=True)
    bytecode = None
    abi = None
    with open(out_json, 'r') as f:
        js = json.load(f)
        bytecode = js["contracts"]["contracts/test.yul"]["contract"]["evm"]["bytecode"]["object"]

    with open(out_abi, 'r') as f:
        abi = f.read()
        # print(bytecode)
    return bytecode, abi


# w3 = Web3(HTTPProvider("https://rpc2.sepolia.org"))
# contract = w3.eth.contract(address=Web3.to_checksum_address('0x2418D8D2b4Fab405FDDFe36Ec1494775785B4b4d'),
#                            abi='[{"name":"test_bytes15","type":"function","outputs":[{"name":"output","type":"bytes15","internal_type":"bytes15"}],"inputs":[{"name":"a","type":"bytes15","internal_type":"bytes15"}],"stateMutability":"view"},{"name":"test_string","type":"function","outputs":[{"name":"output","type":"string","internal_type":"string"}],"inputs":[{"name":"a","type":"string","internal_type":"string"}],"stateMutability":"view"},{"name":"test_address","type":"function","outputs":[{"name":"output","type":"address","internal_type":"address"}],"inputs":[],"stateMutability":"view"},{"name":"simple_arr_test","type":"function","outputs":[{"name":"output","type":"int256[]","internal_type":"int256[]"}],"inputs":[{"name":"_","type":"int256[]","internal_type":"int256[]"},{"name":"arr","type":"int256[]","internal_type":"int256[]"}],"stateMutability":"view"},{"name":"dyn_dyn_arr_test","type":"function","outputs":[{"name":"output","type":"int256[][]","internal_type":"int256[][]"}],"inputs":[{"name":"_","type":"int256[][]","internal_type":"int256[][]"},{"name":"arr","type":"int256[][]","internal_type":"int256[][]"}],"stateMutability":"view"},{"name":"dyn_dyn_arr_test_non_word","type":"function","outputs":[{"name":"output","type":"int16[][]","internal_type":"int16[][]"}],"inputs":[{"name":"_","type":"int16[][]","internal_type":"int16[][]"},{"name":"arr","type":"int16[][]","internal_type":"int16[][]"}],"stateMutability":"view"},{"name":"dyn_st_arr_test_non_word","type":"function","outputs":[{"name":"output","type":"bytes16[][]","internal_type":"bytes16[][]"}],"inputs":[{"name":"_","type":"bytes16[][]","internal_type":"bytes16[][]"},{"name":"arr","type":"bytes16[][]","internal_type":"bytes16[][]"}],"stateMutability":"view"},{"name":"st_dyn_arr_test_non_word","type":"function","outputs":[{"name":"output","type":"int16[][]","internal_type":"int16[][]"}],"inputs":[{"name":"_","type":"int16[][]","internal_type":"int16[][]"},{"name":"arr","type":"int16[][]","internal_type":"int16[][]"}],"stateMutability":"view"},{"name":"st_st_arr_test_non_word","type":"function","outputs":[{"name":"output","type":"bytes16[][]","internal_type":"bytes16[][]"}],"inputs":[{"name":"_","type":"bytes16[][]","internal_type":"bytes16[][]"},{"name":"arr","type":"bytes16[][]","internal_type":"bytes16[][]"}],"stateMutability":"view"},{"name":"dyn_arr_test_string","type":"function","outputs":[{"name":"output","type":"string[][]","internal_type":"string[][]"}],"inputs":[{"name":"_","type":"string[][]","internal_type":"string[][]"},{"name":"arr","type":"string[][]","internal_type":"string[][]"}],"stateMutability":"view"},{"name":"dyn_st_arr_test","type":"function","outputs":[{"name":"output","type":"int256[3][]","internal_type":"int256[3][]"}],"inputs":[{"name":"_","type":"int256[3][]","internal_type":"int256[3][]"},{"name":"arr","type":"int256[3][]","internal_type":"int256[3][]"}],"stateMutability":"view"},{"name":"st_dyn_arr_test","type":"function","outputs":[{"name":"output","type":"int256[][3]","internal_type":"int256[][3]"}],"inputs":[{"name":"_","type":"int256[][3]","internal_type":"int256[][3]"},{"name":"arr","type":"int256[][3]","internal_type":"int256[][3]"}],"stateMutability":"view"},{"name":"simple_tuple","type":"function","outputs":[{"name":"output","type":"tuple","components":[{"name":"name_","type":"int256","internal_type":"int256"},{"name":"name_","type":"int256","internal_type":"int256"}],"internal_type":"tuple"}],"inputs":[{"name":"_","type":"int256","internal_type":"int256"},{"name":"tuple","type":"tuple","components":[{"name":"name_","type":"int256","internal_type":"int256"},{"name":"name_","type":"int256","internal_type":"int256"}],"internal_type":"tuple"}],"stateMutability":"view"},{"name":"hard_tuple","type":"function","outputs":[{"name":"output","type":"tuple","components":[{"name":"name_","type":"int256","internal_type":"int256"},{"name":"name_","type":"int256[]","internal_type":"int256[]"},{"name":"name_","type":"int256[2]","internal_type":"int256[2]"},{"name":"name_","type":"int256[]","internal_type":"int256[]"}],"internal_type":"tuple"}],"inputs":[{"name":"tuple","type":"tuple","components":[{"name":"name_","type":"int256","internal_type":"int256"},{"name":"name_","type":"int256[]","internal_type":"int256[]"},{"name":"name_","type":"int256[2]","internal_type":"int256[2]"},{"name":"name_","type":"int256[]","internal_type":"int256[]"}],"internal_type":"tuple"}],"stateMutability":"view"}]',
#                            bytecode='')


# arr = [1, 2, 3, 4]
#
# print(contract.functions.simple_arr_test([], arr).call())
#
# arr = [[], [1, 2, 3, 4], [], [100, 20002, 20003], []]
#
# print(contract.functions.dyn_dyn_arr_test(arr, arr).call())
# # print(contract.functions.dyn_dyn_arr_test_non_word(arr, arr).call())
#
# print(contract.encodeABI(fn_name='dyn_dyn_arr_test_non_word', args=[arr, arr]))

# contract.functions.get_owner


#
# Chain_id = w3.eth.chain_id


# print(contract.encodeABI(fn_name='get_owner', args=['0x']))
# constructor = contract.constructor(10000, '0x1c5410A21874BCC5A968989b198730a3a125AF6D')

# print(contract.functions.test_string('qwerty').call())

# print(contract.functions.get_owner().call())
# print(contract.functions.get_int_test().call())


# '0x4ff896dc00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000'
# '0x53b821c900000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000'
def create_contract_elixireum(tx_input, w3, acc):
    nonce = w3.eth.get_transaction_count(acc.address)
    print(nonce)
    tx = {"chainId": w3.eth.chain_id, "gas": 10000000, 'from': acc.address,
          "maxFeePerGas": w3.eth.max_priority_fee + w3.to_wei(10, "gwei"),
          "maxPriorityFeePerGas": w3.eth.max_priority_fee, 'nonce': nonce, 'data': tx_input}
    stx = acc.sign_transaction(tx)
    tx_hash = w3.eth.send_raw_transaction(stx.rawTransaction)
    print(tx_hash.hex())
    receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print(receipt)
    return receipt['contractAddress']


def build_address():
    key = '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'
    acc = web3.Account.from_key(key)
    return acc


def build_web3_provider():
    w3 = Web3(HTTPProvider("http://127.0.0.1:8545"))
    w3.strict_bytes_type_checking = False
    return w3


def tx_stub(self):
    nonce = self.w3.eth.get_transaction_count(self.acc.address)
    tx = {"chainId": self.chain_id, "gas": 10000000, 'from': self.acc.address,
          "gasPrice": self.w3.eth.gas_price + self.w3.to_wei(10, "gwei"), 'nonce': nonce}
    return tx


def setup(cls, source):
    bytecode, abi = compile(source)
    cls.bytecode = bytecode
    cls.abi = abi

    w3 = build_web3_provider()
    acc = build_address()
    address = create_contract_elixireum(bytecode, w3, acc)
    cls.contract = w3.eth.contract(address=address,
                                   abi=abi,
                                   bytecode=bytecode)
    cls.w3 = w3

    cls.chain_id = w3.eth.chain_id

    w3.eth.defaultAccount = acc.address
    cls.nonce = w3.eth.get_transaction_count(acc.address)
    print(cls.nonce)
    cls.acc = acc


import random, string


def randomword(length):
    letters = string.printable
    return ''.join(random.choice(letters) for i in range(length))


from web3._utils.encoding import (
    pad_bytes as pad_bytes_eth
)


def pad_bytes(bytes, bytes_count):
    return pad_bytes_eth(b'\x00', bytes_count, bytes)


def random_int256():
    return random.randint(-2 ** 128 + 1, 2 ** 128 - 1)

# tx_hash = create_contract_elixireum()
# receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

# bytecode, abi = compile(source_file)
# address = create_contract_elixireum(bytecode)
# print(address)
