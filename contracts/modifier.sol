//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 contract error{
     address public owner;
     uint public count;

     constructor (){
         owner=msg.sender;
     }

modifier onlyOwner {
    require(owner == msg.sender,"caller is not owner ");
    _;
}
     function call()public onlyOwner{
        
     }
 }