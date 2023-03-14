//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 contract error{
     address public owner;
     uint public count;

     constructor (){
         owner=msg.sender;
     }

     function call()public payable{
         count++;
         require(msg.sender==owner, "caller is not owner");
     }

     function call2()public payable{
         count++;
         assert(msg.sender==owner);
     }
      
      
      function call3()public payable{
         count++;
         if(msg.sender!=owner){
             revert('caller is not owner');
         }
     }
 }