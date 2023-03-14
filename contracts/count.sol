//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract sample{
    uint count;

 
    function getcount() public view returns(uint){
        return count;
    }
    function incrementcount() public{
        count++;
    }

}