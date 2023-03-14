//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract sample {
    address payable public owner;

    constructor (){
        owner=payable(msg.sender);
    }


    function pay() public payable {
        owner.transfer(msg.value);
    }

}