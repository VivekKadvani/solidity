// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract demo {
    uint num;

    function increment() public {
        num++;
    }

    function decrement() public {
        num--;
    }

    function show() public view returns (uint) {
        return num;
    }
}
