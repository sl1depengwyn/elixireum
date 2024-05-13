import random

import web3

from main import tx_stub, setup, randomword, pad_bytes, tx_stub_new

source = "test/contracts/comparison/exm/ERC20.exm"

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

class TestERC20:
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
        assert self.contract.functions.decimals().call() == self.decimals
        assert self.contract.functions.totalSupply().call() == 0

    def test_mint_and_burn(self):
        acc_1 = web3.Account.create()  # self.acc.address
        assert self.contract.functions.balanceOf(acc_1.address).call() == 0

        amount = random.randint(0, 2 ** 256 - 1)
        tx = self.contract.functions.mint(acc_1.address, amount).build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.Transfer().process_receipt(receipt)
        assert log['args']['from'] == '0x0000000000000000000000000000000000000000'
        assert log['args']['to'] == acc_1.address
        assert log['args']['value'] == amount
        assert self.contract.functions.totalSupply().call() == amount
        assert self.contract.functions.balanceOf(acc_1.address).call() == amount

        send_funds(self, acc_1.address)
        tx = self.contract.functions.burn(amount).build_transaction(tx_stub_new(self, acc_1))
        stx = acc_1.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.Transfer().process_receipt(receipt)
        assert log['args']['from'] == acc_1.address
        assert log['args']['to'] == '0x0000000000000000000000000000000000000000'
        assert log['args']['value'] == amount
        assert self.contract.functions.totalSupply().call() == 0
        assert self.contract.functions.balanceOf(acc_1.address).call() == 0

    def test_transfer(self):
        addr = web3.Account.create().address  # self.acc.address

        amount = random.randint(1, 2 ** 256 - 1)
        tx = self.contract.functions.mint(self.acc.address, amount).build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.Transfer().process_receipt(receipt)
        assert log['args']['from'] == '0x0000000000000000000000000000000000000000'
        assert log['args']['to'] == self.acc.address
        assert log['args']['value'] == amount

        assert self.contract.functions.totalSupply().call() == amount
        assert self.contract.functions.balanceOf(self.acc.address).call() == amount

        amount_1 = 1
        tx = self.contract.functions.transfer(addr, amount_1).build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        print(receipt)
        (log,) = self.contract.events.Transfer().process_receipt(receipt)
        assert log['args']['from'] == self.acc.address
        assert log['args']['to'] == addr
        assert log['args']['value'] == amount_1
        assert self.contract.functions.totalSupply().call() == amount
        assert self.contract.functions.balanceOf(addr).call() == amount_1
        assert self.contract.functions.balanceOf(self.acc.address).call() == amount - amount_1

    def test_approval_and_transfer_from(self):
        acc_1 = web3.Account.create()
        send_funds(self, acc_1.address)

        amount = random.randint(1, 2 ** 256 - 1)

        tx = self.contract.functions.mint(acc_1.address, amount).build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        self.w3.eth.wait_for_transaction_receipt(tx_hash)

        tx = self.contract.functions.approve(self.acc.address, amount).build_transaction(tx_stub_new(self, acc_1))
        stx = acc_1.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        print(receipt)
        (log,) = self.contract.events.Approval().process_receipt(receipt)
        assert log['args']['owner'] == acc_1.address
        assert log['args']['spender'] == self.acc.address
        assert log['args']['value'] == amount
        assert self.contract.functions.allowance(acc_1.address, self.acc.address).call() == amount

        addr = web3.Account.create().address

        tx = self.contract.functions.transferFrom(acc_1.address, addr, amount).build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.Transfer().process_receipt(receipt)
        assert log['args']['from'] == acc_1.address
        assert log['args']['to'] == addr
        assert log['args']['value'] == amount

        assert self.contract.functions.balanceOf(addr).call() == amount
        assert self.contract.functions.balanceOf(acc_1.address).call() == 0
