import random

import web3

from main import compile, tx_stub, setup, randomword, pad_bytes, build_web3_provider, build_address, \
    create_contract_elixireum, random_int256

source = "test/contracts/constructor.exm"


class TestConstructor:
    @classmethod
    def setup_class(cls):
        bytecode, abi = compile(source)
        cls.bytecode = bytecode
        cls.abi = abi
        w3 = build_web3_provider()
        contract = w3.eth.contract(
            abi=abi,
            bytecode=bytecode)
        cls.constructor_arg_1 = random_int256()
        cls.constructor_arg_2 = randomword(64)
        cls.constructor_arg_3 = pad_bytes(web3.Web3.to_bytes(random.randint(0, 2 ** 128 - 1)), 16)
        cls.constructor_arg_4 = random_int256()
        cls.constructor_arg_5 = random.randint(-2 ** 8 + 1, 2 ** 8 - 1)
        print(cls.constructor_arg_5)
        bytecode_with_args = contract.constructor(cls.constructor_arg_1, cls.constructor_arg_2, cls.constructor_arg_3,
                                                  cls.constructor_arg_4,
                                                  cls.constructor_arg_5).data_in_transaction
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

    def test_get_int(self):
        assert self.contract.functions.get_int_test().call() == self.constructor_arg_1

    def test_get_owner(self):
        assert self.contract.functions.get_owner().call() == self.acc.address

    def test_get_contract_symbol(self):
        assert self.contract.functions.get_contract_symbol().call() == self.constructor_arg_2

    def test_mapping(self):
        assert self.contract.functions.get_mapping_test_int16(self.constructor_arg_3,
                                                              self.constructor_arg_4).call() == self.constructor_arg_5
