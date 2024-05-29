from web3 import Web3, HTTPProvider
import web3
import subprocess
import json


def compile(src_filename):
    out_dir = "/Users/nikitosing/PycharmProjects/elixireum_tests/"
    out_json = f"{out_dir}out.json"
    out_abi = f"{out_dir}abi.json"

    subprocess.check_output(f"source ~/.zshrc; mix gen {src_filename} --out {out_json} --abi {out_abi}",
                            cwd='/Users/nikitosing/study/thesis/elixireum', shell=True)
    bytecode = None
    abi = None
    with open(out_json, 'r') as f:
        js = json.load(f)
        bytecode = js["contracts"]["contracts/in.yul"]["contract"]["evm"]["bytecode"]["object"]

    with open(out_abi, 'r') as f:
        abi = f.read()
    return bytecode, abi


def tx_dict(account):
    global w3
    nonce = w3.eth.get_transaction_count(account.address)
    return {'from': account.address, 'nonce': nonce}


def send_and_wait_transaction(tx, signer):
    stx = signer.sign_transaction(tx)
    tx_hash = w3.eth.send_raw_transaction(stx.rawTransaction)
    print(f'Transaction hash: {tx_hash.hex()}')
    w3.eth.wait_for_transaction_receipt(tx_hash)


source = "test/contracts/comparison/exm/ERC20.exm"

bytecode, abi = compile(source)

# w3 = Web3(HTTPProvider("http://127.0.0.1:8545"))
w3 = Web3(HTTPProvider("https://rpc2.sepolia.org"))
contract = w3.eth.contract(
    abi=abi,
    bytecode=bytecode)

name = 'ElixireumToken'
symbol = 'EXTT'
decimals = 18

bytecode_with_args = contract.constructor(name, symbol).data_in_transaction

# key = '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'
key = ''
acc = web3.Account.from_key(key)

nonce = w3.eth.get_transaction_count(acc.address)
tx = {"chainId": w3.eth.chain_id, "gas": 1939441, 'from': acc.address,
      "maxFeePerGas": w3.eth.gas_price + w3.to_wei(5, "gwei"),
      "maxPriorityFeePerGas": w3.eth.max_priority_fee + w3.to_wei(5, "gwei"), 'nonce': nonce,
      'data': bytecode_with_args}
print(tx)
stx = acc.sign_transaction(tx)
tx_hash = w3.eth.send_raw_transaction(stx.rawTransaction)
print(f'Creation transaction hash: {tx_hash.hex()}')

receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

address = receipt['contractAddress']

contract = w3.eth.contract(address=address,
                           abi=abi,
                           bytecode=bytecode)

print(f'Contract address hash: {address}')

# from demo import *
#
# contract.functions.balanceOf(acc.address).call()
#
# tx = contract.functions.mint(acc.address, 100 * 10**18).build_transaction(tx_dict(acc))
# send_and_wait_transaction(tx, acc)
#
# new_account = web3.Account.create()
#
# tx = contract.functions.transfer(new_account.address, 15 * 10**18).build_transaction(tx_dict(acc))
# send_and_wait_transaction(tx, acc)
