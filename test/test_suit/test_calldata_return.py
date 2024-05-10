import random

import web3

from main import tx_stub, setup, randomword, pad_bytes, random_int256

source = "test/contracts/calldata_return.exm"


class TestCalldataReturn:
    @classmethod
    def setup_class(cls):
        setup(cls, source)

    def test_bytes15(self):
        value = pad_bytes(web3.Web3.to_bytes(random.randint(0, 10000)), 15)

        assert self.contract.functions.test_bytes15(value).call() == value

    def test_string(self):
        value = randomword(32)

        assert self.contract.functions.test_string(value).call() == value

    def test_address(self):
        assert self.contract.functions.test_address().call() == web3.Web3.to_checksum_address(
            "0x8a258309B8177Df36c48de82885A56cCF576979C")

    def test_simple_arr(self):
        arr = [1, 2, 3, 4]

        assert self.contract.functions.simple_arr_test([], [1, 2, 3, 4]).call() == arr
        assert self.contract.functions.simple_arr_test([], []).call() == []

    def test_2dym_array(self):
        arr = [[], [1, 2, 3, 4], [], [100, 20002, 20003], []]

        assert self.contract.functions.dyn_dyn_arr_test(arr, arr).call() == arr
        assert self.contract.functions.dyn_dyn_arr_test([], []).call() == []

    def test_2dym_array_int_16(self):
        arr = [[], [1, 2, 3, 4], [], [100, 20002, 20003], []]

        assert self.contract.functions.dyn_dyn_arr_test_non_word(arr, arr).call() == arr
        assert self.contract.functions.dyn_dyn_arr_test_non_word([], []).call() == []

    def test_2dym_array_bytes_16(self):
        arr = [[1, 2, 3], [100, 20002, 20003]]
        for i in range(len(arr)):
            for j in range(len(arr[i])):
                arr[i][j] = pad_bytes(web3.Web3.to_bytes(arr[i][j]), 16)

        assert self.contract.functions.dyn_st_arr_test_non_word([], arr).call() == arr

    def test_2dym_array_int_16_1(self):
        arr = [[], [1, 2, 3, 4], [100, 20002, 20003]]

        assert self.contract.functions.st_dyn_arr_test_non_word(arr, arr).call() == arr
        assert self.contract.functions.st_dyn_arr_test_non_word([], arr).call() == arr

    def test_2dym_array_bytes_16_1(self):
        arr = [[1, 2, 3], [0, 100, 101], [100, 20002, 20003]]
        for i in range(len(arr)):
            for j in range(len(arr[i])):
                arr[i][j] = pad_bytes(web3.Web3.to_bytes(arr[i][j]), 16)

        assert self.contract.functions.st_st_arr_test_non_word([], arr).call() == arr

    def test_2dym_array_string(self):
        arr = [[], [randomword(100), randomword(1), randomword(0)], [randomword(0)], [randomword(64), randomword(32)],
               []]

        assert self.contract.functions.dyn_arr_test_string(arr, arr).call() == arr
        assert self.contract.functions.dyn_arr_test_string([], []).call() == []

    def test_2dym_array_with_static_array_int(self):
        arr = [[random_int256(), random_int256(), random_int256()],
               [random_int256(), random_int256(), random_int256()],
               [1, 2, 3]]

        assert self.contract.functions.dyn_st_arr_test(arr, arr).call() == arr

    def test_2dym_static_array_of_dynamic_arrays_int(self):
        arr = [[random_int256(), random_int256(), random_int256()],
               [random_int256(), random_int256()],
               []]

        assert self.contract.functions.st_dyn_arr_test(arr, arr).call() == arr

    def test_simple_tuple(self):
        tuple = (random_int256(), random_int256())
        assert self.contract.functions.simple_tuple(random_int256(), tuple).call() == tuple

    def test_hard_tuple(self):
        tuple = (random_int256(), [random_int256(), random_int256(), -1000], [random_int256(), random_int256()], [])
        assert self.contract.functions.hard_tuple(tuple).call() == tuple
