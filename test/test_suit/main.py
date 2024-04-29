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

def create_contract_elixireum(tx_input, w3, acc):
    nonce = w3.eth.get_transaction_count(acc.address)

    tx = {"chainId": w3.eth.chain_id, "gas": 10000000, 'from': acc.address,
          "gasPrice": w3.eth.gas_price + w3.to_wei(10, "gwei"), 'nonce': nonce, 'data': tx_input}
    stx = acc.sign_transaction(tx)
    tx_hash = w3.eth.send_raw_transaction(stx.rawTransaction)
    print(tx_hash.hex())
    receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print(receipt)
    return receipt['contractAddress']


def build_address():
    key = '***'
    acc = web3.Account.from_key(key)
    return acc


def build_web3_provider():
    w3 = Web3(HTTPProvider("https://rpc2.sepolia.org"))
    w3.strict_bytes_type_checking = False
    return w3
