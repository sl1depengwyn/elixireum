// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract Test {
    event event_simple(string[] indexed a, int256 b);

    function example() public {
        string[] memory a = new string[](3);
        a[0] = "1";
        a[1] = "2";
        a[2] = "3";
        emit event_simple(a, 123);
    }
}
