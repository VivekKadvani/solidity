//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract bank{
    mapping(address => uint)private balance;
    mapping(address=>bytes32) private password;

    function setpassword(string memory _pass) public{
        password[msg.sender]=keccak256(abi.encodePacked(_pass));
    }
    function deposit(uint _bal) public  {
        balance[msg.sender] +=_bal;
    }

    function withdrow(uint _amount, string memory _pass) public{
        require(password[msg.sender]==keccak256(abi.encodePacked(_pass)),"Invalid Password");
        require (balance[msg.sender]>= _amount, "Insufficent Funds");
        balance[msg.sender]-=_amount;
    }

    function checkBalance(string memory _pass) public view returns(uint){
        require(password[msg.sender]==keccak256(abi.encodePacked(_pass)),"Invalid Password");
        return balance[msg.sender];
    }
}    