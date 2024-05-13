import random

import web3
import pandas as pd


from main import (
    tx_stub,
    setup,
    randomword,
    pad_bytes,
    tx_stub_new,
    compile,
    tx_stub,
    setup,
    randomword,
    pad_bytes,
    build_web3_provider,
    build_address,
    create_contract_elixireum,
    random_int256,
)


def send_funds(self, to):
    tx = tx_stub(self)
    tx["value"] = self.w3.to_wei(1, "ether")
    tx["to"] = to
    tx["gas"] = 21000

    stx = self.acc.sign_transaction(tx)
    tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
    self.w3.eth.wait_for_transaction_receipt(tx_hash)


class ERC20Benchmark:
    def __init__(
        self,
        exm_source="test/contracts/comparison/exm/ERC20.exm",
        sol_source="test/contracts/comparison/sol/ERC20.sol",
    ):
        bytecode, abi = compile(source)

        self.bytecode = bytecode
        self.abi = abi
        w3 = build_web3_provider()
        contract = w3.eth.contract(abi=abi, bytecode=bytecode)
        self.name = randomword(64)
        self.symbol = randomword(64)
        self.decimals = 18
        bytecode_with_args = contract.constructor(
            self.name, self.symbol
        ).data_in_transaction
        acc = build_address()
        address = create_contract_elixireum(bytecode_with_args, w3, acc)
        self.exm_contract = w3.eth.contract(address=address, abi=abi, bytecode=bytecode)
        self.w3 = w3
        self.chain_id = w3.eth.chain_id
        w3.eth.defaultAccount = acc.address
        self.nonce = w3.eth.get_transaction_count(acc.address)
        self.acc = acc

    def test_static_getters(self):
        assert self.contract.functions.name().call() == self.name
        assert self.contract.functions.symbol().call() == self.symbol
        assert self.contract.functions.decimals().call() == self.decimals
        assert self.contract.functions.totalSupply().call() == 0

    def run_all_measures(self):
        results = dict()
        results = self.measure_transfer_and_mint() | results
        results = self.measure_transfer_and_mint() | results
        results = self.measure_approval_and_transfer_from() | results
        df = pd.DataFrame(results)
        print(df)

    def measure_transfer_and_mint(self):
        addr = web3.Account.create().address
        results = dict()

        amount = random.randint(1, 2**256 - 1)
        tx = self.contract.functions.mint(self.acc.address, amount).build_transaction(
            tx_stub_new(self, self.acc)
        )
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (_log,) = self.contract.events.Transfer().process_receipt(receipt)
        results["mint"] = receipt["gasUsed"]

        amount_1 = 1
        tx = self.contract.functions.transfer(addr, amount_1).build_transaction(
            tx_stub(self)
        )
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (_log,) = self.contract.events.Transfer().process_receipt(receipt)
        results["transfer"] = receipt["gasUsed"]

        return results

    def measure_mint_and_burn(self):
        acc_1 = web3.Account.create()
        results = dict()
        amount = random.randint(0, 2**256 - 1)
        tx = self.contract.functions.mint(acc_1.address, amount).build_transaction(
            tx_stub_new(self, self.acc)
        )
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (_log,) = self.contract.events.Transfer().process_receipt(receipt)
        results["mint"] = receipt["gasUsed"]

        send_funds(self, acc_1.address)
        tx = self.contract.functions.burn(amount).build_transaction(
            tx_stub_new(self, acc_1)
        )
        stx = acc_1.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (_log,) = self.contract.events.Transfer().process_receipt(receipt)
        results["burn"] = receipt["gasUsed"]
        
        return results

    def measure_approval_and_transfer_from(self):
        acc_1 = web3.Account.create()
        send_funds(self, acc_1.address)
        results = dict()
        amount = random.randint(1, 2**256 - 1)

        tx = self.contract.functions.mint(acc_1.address, amount).build_transaction(
            tx_stub_new(self, self.acc)
        )
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        results['mint'] = receipt['gasUsed']
        
        tx = self.contract.functions.approve(
            self.acc.address, amount
        ).build_transaction(tx_stub_new(self, acc_1))
        stx = acc_1.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (_log,) = self.contract.events.Approval().process_receipt(receipt)
        results['approve'] = receipt['gasUsed']

        addr = web3.Account.create().address

        tx = self.contract.functions.transferFrom(
            acc_1.address, addr, amount
        ).build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (_log,) = self.contract.events.Transfer().process_receipt(receipt)
        results['transferFrom'] = receipt['gasUsed']

        return results