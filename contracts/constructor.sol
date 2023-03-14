//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract sample {
    int public amount;
    constructor(int amt){
        amount= amt;
    }

}
contract derived is sample{
    constructor() sample(10){}
}