// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Constructor {

    string uri_1;
    uint256 number;
    address owner;

    constructor(uint256 num, string memory qwe) public {
        number = num;
        uri_1 = qwe;
        owner = msg.sender;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }

}