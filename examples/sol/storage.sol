// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {

    uint16 number = 100;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function storeblabla(uint16 num) public {
        number = num;
    }

    function qwe() public returns (bool) {
        storeblabla(retrieveBlaBla());
        return true;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieveBlaBla() public view returns (uint16){
        return number;
    }
}

