import random

import web3
import pytest
from web3.exceptions import ContractCustomError

from main import tx_stub, setup, randomword, pad_bytes, tx_stub_new

source = "test/contracts/comparison/exm/ERC721.exm"

from main import compile, tx_stub, setup, randomword, pad_bytes, build_web3_provider, build_address, \
    create_contract_elixireum, random_int256


def send_funds(self, to):
    tx = tx_stub(self)
    tx['value'] = self.w3.to_wei(1, "ether")
    tx['to'] = to
    tx['gas'] = 21000

    stx = self.acc.sign_transaction(tx)
    tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
    self.w3.eth.wait_for_transaction_receipt(tx_hash)


class TestERC721:
    @classmethod
    def setup_class(cls):
        bytecode, abi = compile(source)
        cls.bytecode = bytecode
        cls.abi = abi
        w3 = build_web3_provider()
        contract = w3.eth.contract(
            abi=abi,
            bytecode=bytecode)
        cls.name = randomword(64)
        cls.symbol = randomword(64)
        cls.decimals = 18
        bytecode_with_args = contract.constructor(cls.name, cls.symbol).data_in_transaction
        print(bytecode_with_args)
        acc = build_address()
        address = create_contract_elixireum(bytecode_with_args, w3, acc)
        cls.contract = w3.eth.contract(address=address,
                                       abi=abi,
                                       bytecode=bytecode)
        cls.w3 = w3

        cls.chain_id = w3.eth.chain_id

        w3.eth.defaultAccount = acc.address
        cls.nonce = w3.eth.get_transaction_count(acc.address)
        cls.acc = acc

    def test_static_getters(self):
        assert self.contract.functions.name().call() == self.name
        assert self.contract.functions.symbol().call() == self.symbol

    def test_mint_and_burn(self):
        acc_1 = web3.Account.create()
        assert self.contract.functions.balanceOf(acc_1.address).call() == 0
        uri = randomword(72)
        token_id = random.randint(0, 2 ** 256 - 1)
        tx = self.contract.functions.mint(acc_1.address, token_id, uri).build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.Transfer().process_receipt(receipt)
        assert log['args']['from'] == '0x0000000000000000000000000000000000000000'
        assert log['args']['to'] == acc_1.address
        assert log['args']['tokenId'] == token_id

        assert self.contract.functions.tokenURI(token_id).call() == uri
        assert self.contract.functions.balanceOf(acc_1.address).call() == 1

        assert self.contract.functions.ownerOf(token_id).call() == acc_1.address

        send_funds(self, acc_1.address)
        tx = self.contract.functions.burn(token_id).build_transaction(tx_stub_new(self, acc_1))
        stx = acc_1.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.Transfer().process_receipt(receipt)
        assert log['args']['from'] == acc_1.address
        assert log['args']['to'] == '0x0000000000000000000000000000000000000000'
        assert log['args']['tokenId'] == token_id
        assert self.contract.functions.balanceOf(acc_1.address).call() == 0
        with pytest.raises(ContractCustomError) as error:
            self.contract.functions.ownerOf(token_id).call()
        assert bytes.fromhex(error.value.args[1].replace('0x', '')).decode('utf-8') == 'ERC721NonexistentToken(tokenId)'

    def test_transfer_from(self):
        addr = web3.Account.create().address

        token_id = random.randint(1, 2 ** 256 - 1)

        tx = self.contract.functions.mint(self.acc.address, token_id, '').build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.Transfer().process_receipt(receipt)
        assert log['args']['from'] == '0x0000000000000000000000000000000000000000'
        assert log['args']['to'] == self.acc.address
        assert log['args']['tokenId'] == token_id
        assert self.contract.functions.tokenURI(token_id).call() == ''
        assert self.contract.functions.balanceOf(self.acc.address).call() == 1
        assert self.contract.functions.ownerOf(token_id).call() == self.acc.address

        tx = self.contract.functions.transferFrom(self.acc.address, addr, token_id).build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        print(receipt)
        (log,) = self.contract.events.Transfer().process_receipt(receipt)
        assert log['args']['from'] == self.acc.address
        assert log['args']['to'] == addr
        assert log['args']['tokenId'] == token_id

        assert self.contract.functions.balanceOf(addr).call() == 1
        assert self.contract.functions.balanceOf(self.acc.address).call() == 0
        assert self.contract.functions.ownerOf(token_id).call() == addr

    def test_approval_and_transfer_from(self):
        acc_1 = web3.Account.create()
        send_funds(self, acc_1.address)

        token_id = random.randint(1, 2 ** 256 - 1)

        tx = self.contract.functions.mint(acc_1.address, token_id, '').build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)

        tx = self.contract.functions.approve(self.acc.address, token_id).build_transaction(tx_stub_new(self, acc_1))
        stx = acc_1.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        print(receipt)
        (log,) = self.contract.events.Approval().process_receipt(receipt)
        assert log['args']['owner'] == acc_1.address
        assert log['args']['approved'] == self.acc.address
        assert log['args']['tokenId'] == token_id

        assert self.contract.functions.getApproved(token_id).call() == self.acc.address

        addr = web3.Account.create().address

        tx = self.contract.functions.transferFrom(acc_1.address, addr, token_id).build_transaction(
            tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.Transfer().process_receipt(receipt)
        assert log['args']['from'] == acc_1.address
        assert log['args']['to'] == addr
        assert log['args']['tokenId'] == token_id

        assert self.contract.functions.balanceOf(addr).call() == 1
        assert self.contract.functions.balanceOf(acc_1.address).call() == 0
        assert self.contract.functions.ownerOf(token_id).call() == addr

    def test_approval_for_all(self):
        acc_1 = web3.Account.create()
        send_funds(self, acc_1.address)

        tx = self.contract.functions.setApprovalForAll(self.acc.address, True).build_transaction(
            tx_stub_new(self, acc_1))
        stx = acc_1.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        print(receipt)
        (log,) = self.contract.events.ApprovalForAll().process_receipt(receipt)
        assert log['args']['owner'] == acc_1.address
        assert log['args']['operator'] == self.acc.address
        assert log['args']['approved']

        assert self.contract.functions.isApprovedForAll(acc_1.address, self.acc.address).call()

        token_id = random.randint(1, 2 ** 256 - 1)

        tx = self.contract.functions.mint(acc_1.address, token_id, '').build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)

        addr = web3.Account.create().address

        tx = self.contract.functions.transferFrom(acc_1.address, addr, token_id).build_transaction(
            tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.Transfer().process_receipt(receipt)
        assert log['args']['from'] == acc_1.address
        assert log['args']['to'] == addr
        assert log['args']['tokenId'] == token_id

        assert self.contract.functions.balanceOf(addr).call() == 1
        assert self.contract.functions.balanceOf(acc_1.address).call() == 0
        assert self.contract.functions.ownerOf(token_id).call() == addr
