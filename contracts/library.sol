//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
library fun{
    function add()public pure returns(int){
        return 4+4;
    }
}

contract sample {
    function call()public pure returns(int){
        return fun.add();
    }
}