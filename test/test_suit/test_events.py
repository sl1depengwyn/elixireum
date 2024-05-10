import random

import web3

from main import tx_stub, setup, randomword, pad_bytes

source = "test/contracts/events.exm"


class TestEvents:
    @classmethod
    def setup_class(cls):
        setup(cls, source)

    def test_event_with_no_indexed_args(self):
        tx = self.contract.functions.no_indexed_args().build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.no_indexed_args().process_receipt(receipt)
        assert log['args']['c'] == 1
        assert log['args']['d'] == [1, 2, 3]

    # (AttributeDict({'args': AttributeDict({'c': 1, 'd': [1, 2, 3]}), 'event': 'no_indexed_args', 'logIndex': 4,
    #                 'transactionIndex': 9,
    #                 'transactionHash': HexBytes('0x9397c291edb3149d812e411dacbc14e7e697c46e2bce54175beec9bc4dceea7e'),
    #                 'address': '0xB1beFFf86e09c9aF840214bDA3fB08e599573Aa4',
    #                 'blockHash': HexBytes('0x6887b90af3af0a9c041cd3c6bf63d8910239cab99a6fd40c50e7017d44fa9af1'),
    #                 'blockNumber': 5836756}),)

    # (AttributeDict({'args': AttributeDict({'a': 1}), 'event': 'no_data_args', 'logIndex': 1, 'transactionIndex': 4,
    #                 'transactionHash': HexBytes('0xe9e906d37b0d9d52e2ead434fd8a420703b71a0c0159d8cbd8f5ff78b56628e2'),
    #                 'address': '0x5bB7079829F408C1D1103276132e66C1e3b7147F',
    #                 'blockHash': HexBytes('0x1d16442f60c8ac8e3fcd63b91faf77213b1b5fb7b0461fa861d49ca14b0a5a4e'),
    #                 'blockNumber': 5836556}),)
    def test_event_with_no_data_args(self):
        tx = self.contract.functions.no_data_args().build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.no_data_args().process_receipt(receipt)
        assert log['args']['a'] == 1

        # assert self.contract.functions.get_int_test().call() == number

    def test_event_complex_indexed(self):
        tx = self.contract.functions.with_complex_indexed().build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.with_complex_indexed().process_receipt(receipt)
        assert log['args']['a'] == 1
        assert log['args']['b'] == 1
        assert log['args']['c'] == web3.Web3.keccak(
            hexstr='0x31' + '00' * 31 + '32' + '00' * 31 + '33' + '00' * 31)

    def test_event_complex_data(self):
        tx = self.contract.functions.with_complex_data().build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (log,) = self.contract.events.with_complex_data().process_receipt(receipt)
        print(log)
        assert log['args']['a'] == 1
        assert log['args']['b'] == ['1', '2', '3']

    # AttributeDict({'blockHash': HexBytes('0x2cb9a06c98cc9600336032fc859b242971eafd65f1dafa89bf5ffca5939882b8'),
    #                'blockNumber': 5835859, 'contractAddress': None, 'cumulativeGasUsed': 165941,
    #                'effectiveGasPrice': 45706304755, 'from': '0xBb36c792B9B45Aaf8b848A1392B0d6559202729E', 'gasUsed': 24132,
    #                'logs': [AttributeDict({'address': '0x296921b060F41563Ed858DE5Bcd56c0590cE7464', 'topics': [
    #                    HexBytes('0x11a9fef58f53c1197de31fd5e97c2a871ea94519b0fd67cdef1570c3438f279d')], 'data': HexBytes(
    #                    '0x000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003'),
    #                                        'blockNumber': 5835859, 'transactionHash': HexBytes(
    #                        '0x3e05042092f915d83a45ceb59cf545d638666a4db36efcc67336df1e97582b3c'), 'transactionIndex': 6,
    #                                        'blockHash': HexBytes(
    #                                            '0x2cb9a06c98cc9600336032fc859b242971eafd65f1dafa89bf5ffca5939882b8'),
    #                                        'logIndex': 0, 'removed': False})], 'logsBloom': HexBytes(
    #         '0x00000002000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000002000000200000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'),
    #                'status': 1, 'to': '0x296921b060F41563Ed858DE5Bcd56c0590cE7464',
    #                'transactionHash': HexBytes('0x3e05042092f915d83a45ceb59cf545d638666a4db36efcc67336df1e97582b3c'),
    #                'transactionIndex': 6, 'type': 0})
