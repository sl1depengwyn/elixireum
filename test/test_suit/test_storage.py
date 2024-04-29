import pytest
import web3

from main import compile, create_contract_elixireum, build_address, build_web3_provider
import random

source = "test/contracts/storage.exm"


class TestStorage:
    def _tx_stub(self):
        nonce = self.w3.eth.get_transaction_count(self.acc.address)
        tx = {"chainId": self.chain_id, "gas": 10000000, 'from': self.acc.address,
              "gasPrice": self.w3.eth.gas_price + self.w3.to_wei(10, "gwei"), 'nonce': nonce}
        return tx

    @classmethod
    def setup_class(cls):
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
        cls.acc = acc

    def test_get_and_store_int(self):
        number = random.randint(0, 100)
        tx = self.contract.functions.store_int_test(number).build_transaction(self._tx_stub())
        print(self.nonce)
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)
        assert self.contract.functions.get_int_test().call() == number

    def test_get_and_store_addresses(self):
        address = web3.Account.create().address
        tx = self.contract.functions.store_address(address).build_transaction(self._tx_stub())
        print(self.nonce)
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)
        assert self.contract.functions.get_address().call() == address

    def test_get_and_store_symbol(self):
        string = "SYMBOL$%"
        tx = self.contract.functions.store_contract_symbol(string).build_transaction(self._tx_stub())
        print(self.nonce)
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)
        assert self.contract.functions.get_contract_symbol().call() == string

    def test_get_and_store_mapping_test_int16(self):
        key_1 = web3.Web3.to_bytes(random.randint(0, 100))
        key_2 = random.randint(0, 100)
        value = random.randint(0, 100)
        tx = self.contract.functions.store_mapping_test_int16(key_1, key_2, value).build_transaction(self._tx_stub())
        print(self.nonce)
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)

        assert self.contract.functions.get_mapping_test_int16(key_1, key_2).call() == value

    def test_get_and_store_mapping_test_bytes_16(self):
        key_1 = random.randint(0, 100)
        key_2 = web3.Web3.to_bytes(random.randint(0, 100))
        value = web3.Web3.to_bytes(random.randint(0, 100))

        tx = self.contract.functions.store_mapping_test_bytes16(key_1, key_2, value).build_transaction(self._tx_stub())
        print(self.nonce)
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)

        assert self.contract.functions.get_mapping_test_bytes16(key_1, key_2).call() == value
