// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Storage {

    string uri_1;
    uint256 number;

    function store(uint256 num) public {
        number = num;
    }

    function store_1(string memory qwe) public {
        uri_1 = qwe;
    }

    function retrieve() public view returns (uint256){
        return number;
    }

    function retrieve_1() public view returns (string memory){
        return uri_1;
    }

}