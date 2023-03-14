//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract pass{
    bytes32  public password;

    function genPass(string memory _pass)public {
        password = keccak256(abi.encodePacked(_pass));
    }

    function chekPass(string memory _pass) public view{
        require(password == keccak256(abi.encodePacked(_pass)),'passwornd not matched....' );
    }
}