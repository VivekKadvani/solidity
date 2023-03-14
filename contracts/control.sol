//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract sample {
    uint256[] public arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function checkNum() public view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] % 2 == 0) {
                count++;
            }
        }
        return count;
    }

    function chekowner() public view returns(bool){
        return(msg.sender == owner);
    }
}
