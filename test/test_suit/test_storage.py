import random

import web3

from main import tx_stub, setup, randomword, pad_bytes

source = "test/contracts/storage.exm"


class TestStorage:
    @classmethod
    def setup_class(cls):
        setup(cls, source)

    def test_get_and_store_int(self):
        number = random.randint(0, 100)
        tx = self.contract.functions.store_int_test(number).build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)
        assert self.contract.functions.get_int_test().call() == number

    def test_get_and_store_addresses(self):
        address = web3.Account.create().address
        tx = self.contract.functions.store_address(address).build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)
        assert self.contract.functions.get_address().call() == address

    def test_get_and_store_symbol(self):
        string = randomword(32)
        tx = self.contract.functions.store_contract_symbol(string).build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)
        assert self.contract.functions.get_contract_symbol().call() == string

    def test_get_and_store_mapping_test_int16(self):
        key_1 = web3.Web3.to_bytes(random.randint(0, 100))
        key_2 = random.randint(0, 100)
        value = random.randint(0, 100)
        tx = self.contract.functions.store_mapping_test_int16(key_1, key_2, value).build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)

        assert self.contract.functions.get_mapping_test_int16(key_1, key_2).call() == value

    def test_get_and_store_mapping_test_bytes_16(self):
        key_1 = random.randint(0, 100)
        key_2 = pad_bytes(web3.Web3.to_bytes(random.randint(0, 100)), 16)
        value = pad_bytes(web3.Web3.to_bytes(random.randint(0, 100)), 16)

        tx = self.contract.functions.store_mapping_test_bytes16(key_1, key_2, value).build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)
        assert self.contract.functions.get_mapping_test_bytes16(key_1, key_2).call() == value

    def test_increment_mapping_test_int16(self):
        key_1 = web3.Web3.to_bytes(random.randint(0, 100))
        key_2 = random.randint(0, 100)
        value = random.randint(0, 100)
        tx = self.contract.functions.store_mapping_test_int16(key_1, key_2, value).build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)

        self.w3.eth.wait_for_transaction_receipt(self.w3.eth.send_raw_transaction(self.acc.sign_transaction(
            self.contract.functions.increment_mapping_test_int16(key_1, key_2).build_transaction(
                tx_stub(self))).rawTransaction))
        assert self.contract.functions.get_mapping_test_int16(key_1, key_2).call() == value + 1

    def test_address(self):
        addr = web3.Account.create().address  # self.acc.address

        id = random.randint(1, 2 ** 256 - 1)
        tx = self.contract.functions.store_addresses(id, addr).build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)
        assert self.contract.functions.get_addresses(id).call() == addr

    def test_tokenURIs(self):
        addr = web3.Account.create().address  # self.acc.address
        uri = "dfkjmnvk;advkdfmnvk;jadfvkadfn;kjvndf"

        id = random.randint(1, 2 ** 256 - 1)
        tx = self.contract.functions.set_tokenURIs(id, uri).build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)
        assert self.contract.functions.get_tokenURIs(id).call() == uri
