// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

contract demoAdvance {
    uint num;

    function increment() public {
        num++;
    }

    function decrement() public {
        num--;
    }

    function mutiply() public {
        num = num + 2;
    }

    function show() public view returns (uint) {
        return num;
    }
}
