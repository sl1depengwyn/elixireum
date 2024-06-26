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
    sol_compile,
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
        w3 = build_web3_provider()
        self.name = randomword(64)
        self.symbol = randomword(64)
        self.decimals = 18
        acc = build_address()
        self.acc = acc
        self.w3 = w3
        self.chain_id = w3.eth.chain_id
        w3.eth.defaultAccount = acc.address
        self.nonce = w3.eth.get_transaction_count(acc.address)

        bytecode, abi = compile(exm_source)
        contract = w3.eth.contract(abi=abi, bytecode=bytecode)
        bytecode_with_args = contract.constructor(
            self.name, self.symbol
        ).data_in_transaction
        receipt = create_contract_elixireum(bytecode_with_args, w3, acc)
        address = receipt['contractAddress']
        self.exm_contract = w3.eth.contract(
            address=address, abi=abi, bytecode=bytecode)
        self.results_exm = {'deploy': receipt['gasUsed']}

        bytecode, abi = sol_compile(sol_source, "ERC20")
        contract = w3.eth.contract(abi=abi, bytecode=bytecode)
        bytecode_with_args = contract.constructor(
            self.name, self.symbol
        ).data_in_transaction
        receipt = create_contract_elixireum(bytecode_with_args, w3, acc)
        address = receipt['contractAddress']
        self.sol_contract = w3.eth.contract(
            address=address, abi=abi, bytecode=bytecode)
        self.results_sol = {'deploy': receipt['gasUsed']}

    def run_all_measures(self):
        results_global = dict()
        runs_count = 20
        for i in range(runs_count):
            results = self.measure_mint_and_burn(self.exm_contract)
            results = self.measure_transfer_and_mint(
                self.exm_contract) | results
            results = self.measure_approval_and_transfer_from(
                self.exm_contract) | results
            if i > 0:
                for k in results:
                    results_global[k] += results[k]
            else:
                results_global = results
        for k in results_global:
            results_global[k] /= runs_count
        results = results_global | self.results_exm

        print('EXM:')
        print("{:<15} | {:<30}".format('Method', 'GasUsed'))
        print('-'*30)
        for k, v in results.items():
            print("{:<15} | {:<30}".format(k, v))
        print('-'*30)

        results_global = dict()
        for i in range(runs_count):
            results = self.measure_mint_and_burn(self.sol_contract)
            results = self.measure_transfer_and_mint(
                self.sol_contract) | results
            results = self.measure_approval_and_transfer_from(
                self.sol_contract) | results
            if i > 0:
                for k in results:
                    results_global[k] += results[k]
            else:
                results_global = results
        for k in results_global:
            results_global[k] /= runs_count
        results = results_global | self.results_sol

        print('SOL: ')
        print("{:<15} | {:<30}".format('Method', 'GasUsed'))
        print('-'*30)
        for k, v in results.items():
            print("{:<15} | {:<30}".format(k, v))
        print('-'*30)

    def measure_transfer_and_mint(self, contract):
        addr = web3.Account.create().address
        results = dict()

        amount = random.randint(1, 2**200 - 1)
        tx = contract.functions.mint(self.acc.address, amount).build_transaction(
            tx_stub_new(self, self.acc)
        )
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (_log,) = contract.events.Transfer().process_receipt(receipt)
        results["mint"] = receipt["gasUsed"]

        amount_1 = 1
        tx = contract.functions.transfer(addr, amount_1).build_transaction(
            tx_stub(self)
        )
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (_log,) = contract.events.Transfer().process_receipt(receipt)
        results["transfer"] = receipt["gasUsed"]

        return results

    def measure_mint_and_burn(self, contract):
        acc_1 = web3.Account.create()
        results = dict()
        amount = random.randint(0, 2**200 - 1)
        tx = contract.functions.mint(acc_1.address, amount).build_transaction(
            tx_stub_new(self, self.acc)
        )
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (_log,) = contract.events.Transfer().process_receipt(receipt)
        results["mint"] = receipt["gasUsed"]

        send_funds(self, acc_1.address)
        tx = contract.functions.burn(amount).build_transaction(
            tx_stub_new(self, acc_1)
        )
        stx = acc_1.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (_log,) = contract.events.Transfer().process_receipt(receipt)
        results["burn"] = receipt["gasUsed"]

        return results

    def measure_approval_and_transfer_from(self, contract):
        acc_1 = web3.Account.create()
        send_funds(self, acc_1.address)
        results = dict()
        amount = random.randint(1, 2**200 - 1)

        tx = contract.functions.mint(acc_1.address, amount).build_transaction(
            tx_stub_new(self, self.acc)
        )
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        results['mint'] = receipt['gasUsed']

        tx = contract.functions.approve(
            self.acc.address, amount
        ).build_transaction(tx_stub_new(self, acc_1))
        stx = acc_1.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (_log,) = contract.events.Approval().process_receipt(receipt)
        results['approve'] = receipt['gasUsed']

        addr = web3.Account.create().address

        tx = contract.functions.transferFrom(
            acc_1.address, addr, amount
        ).build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        (_log,) = contract.events.Transfer().process_receipt(receipt)
        results['transferFrom'] = receipt['gasUsed']

        return results


class ERC721Benchmark:
    def __init__(
        self,
        exm_source="test/contracts/comparison/exm/ERC721.exm",
        sol_source="test/contracts/comparison/sol/ERC721.sol",
    ):
        w3 = build_web3_provider()
        self.name = randomword(64)
        self.symbol = randomword(64)
        self.decimals = 18
        acc = build_address()
        self.acc = acc
        self.w3 = w3
        self.chain_id = w3.eth.chain_id
        w3.eth.defaultAccount = acc.address
        self.nonce = w3.eth.get_transaction_count(acc.address)

        bytecode, abi = compile(exm_source)
        contract = w3.eth.contract(abi=abi, bytecode=bytecode)
        bytecode_with_args = contract.constructor(
            self.name, self.symbol
        ).data_in_transaction
        receipt = create_contract_elixireum(bytecode_with_args, w3, acc)
        address = receipt['contractAddress']
        self.exm_contract = w3.eth.contract(
            address=address, abi=abi, bytecode=bytecode)
        self.results_exm = {'deploy': receipt['gasUsed']}

        bytecode, abi = sol_compile(sol_source, "ERC721")
        contract = w3.eth.contract(abi=abi, bytecode=bytecode)
        bytecode_with_args = contract.constructor(
            self.name, self.symbol
        ).data_in_transaction
        receipt = create_contract_elixireum(bytecode_with_args, w3, acc)
        address = receipt['contractAddress']
        self.sol_contract = w3.eth.contract(
            address=address, abi=abi, bytecode=bytecode)
        self.results_sol = {'deploy': receipt['gasUsed']}

    def run_all_measures(self):
        results_global = dict()
        runs_count = 20
        for i in range(runs_count):
            results = self.measure_mint_and_burn(self.exm_contract)
            results = self.measure_transfer_and_mint(
                self.exm_contract) | results
            results = self.measure_mint_approve_transfer_from(
                self.exm_contract) | results
            results = self.measure_setApprovalForAll_transferFrom(
            self.exm_contract) | results
            if i > 0:
                for k in results:
                    results_global[k] += results[k]
            else:
                results_global = results
        for k in results_global:
            results_global[k] /= runs_count
        results = results_global | self.results_exm

        print('EXM:')
        print("{:<15} | {:<30}".format('Method', 'GasUsed'))
        print('-'*30)
        for k, v in results.items():
            print("{:<15} | {:<30}".format(k, v))
        print('-'*30)

        results_global = dict()
        for i in range(runs_count):
            results = self.measure_mint_and_burn(self.sol_contract)
            results = self.measure_transfer_and_mint(
                self.sol_contract) | results
            results = self.measure_mint_approve_transfer_from(
                self.sol_contract) | results
            results = self.measure_setApprovalForAll_transferFrom(
                self.sol_contract) | results
            
            if i > 0:
                for k in results:
                    results_global[k] += results[k]
            else:
                results_global = results
        for k in results_global:
            results_global[k] /= runs_count
        results = results_global | self.results_sol

        print('SOL: ')
        print("{:<15} | {:<30}".format('Method', 'GasUsed'))
        print('-'*30)
        for k, v in results.items():
            print("{:<15} | {:<30}".format(k, v))
        print('-'*30)


    def measure_transfer_and_mint(self, contract):
        addr = web3.Account.create().address
        results = dict()
        token_id = random.randint(1, 2 ** 256 - 1)

        tx = contract.functions.mint(
            self.acc.address, token_id, '').build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        results["mint"] = receipt["gasUsed"]

        tx = contract.functions.transferFrom(
            self.acc.address, addr, token_id).build_transaction(tx_stub(self))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        results["transferFrom"] = receipt["gasUsed"]

        return results

    def measure_mint_and_burn(self, contract):
        acc_1 = web3.Account.create()
        results = dict()
        uri = randomword(72)
        token_id = random.randint(0, 2 ** 256 - 1)

        tx = contract.functions.mint(acc_1.address, token_id, uri).build_transaction(
            tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        results["mint"] = receipt["gasUsed"]

        send_funds(self, acc_1.address)
        tx = contract.functions.burn(
            token_id).build_transaction(tx_stub_new(self, acc_1))
        stx = acc_1.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        results["burn"] = receipt["gasUsed"]

        return results

    def measure_mint_approve_transfer_from(self, contract):
        acc_1 = web3.Account.create()
        send_funds(self, acc_1.address)
        results = dict()

        token_id = random.randint(1, 2 ** 256 - 1)

        tx = contract.functions.mint(
            acc_1.address, token_id, '').build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        results['mint'] = receipt['gasUsed']

        tx = contract.functions.approve(
            self.acc.address, token_id).build_transaction(tx_stub_new(self, acc_1))
        stx = acc_1.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        results['approve'] = receipt['gasUsed']

        addr = web3.Account.create().address
        tx = contract.functions.transferFrom(acc_1.address, addr, token_id).build_transaction(
            tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        results['transferFrom'] = receipt['gasUsed']

        return results

    def measure_setApprovalForAll_transferFrom(self, contract):
        acc_1 = web3.Account.create()
        send_funds(self, acc_1.address)
        results = dict()

        tx = contract.functions.setApprovalForAll(self.acc.address, True).build_transaction(
            tx_stub_new(self, acc_1))
        stx = acc_1.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        results['setApprovalForAll'] = receipt['gasUsed']

        token_id = random.randint(1, 2 ** 256 - 1)

        tx = contract.functions.mint(
            acc_1.address, token_id, '').build_transaction(tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        results['mint'] = receipt['gasUsed']

        addr = web3.Account.create().address

        tx = contract.functions.transferFrom(acc_1.address, addr, token_id).build_transaction(
            tx_stub_new(self, self.acc))
        stx = self.acc.sign_transaction(tx)
        tx_hash = self.w3.eth.send_raw_transaction(stx.rawTransaction)
        receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        results['transferFrom'] = receipt['gasUsed']
        return results

# benchmark = ERC20Benchmark()
benchmark = ERC721Benchmark()
benchmark.run_all_measures()
