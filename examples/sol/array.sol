// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {

    function qwe(uint[] memory qbe) public returns (uint256[] memory) {
        for (uint i = 0; i < qbe.length; i++) {
            qbe[i] += 1;
        }
        
        
        return qbe;
    }
}