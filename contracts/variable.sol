//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract variable{
    int256 public Myint256 = 1;
    uint public Myuint = 1;
    uint256 public Myuint256 = 1;
    uint8 public Myuint8 = 1;

    string public str= "hello solidity";
    bytes32 public str32 = "hello ether";

    uint8 public v=128;
    address public mydd = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    struct Mystruct{
        uint256 n;
        string strl;
    }

    Mystruct public mystruct = Mystruct(1, "vivek") ;
}