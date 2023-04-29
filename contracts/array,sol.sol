//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract array{
    uint[] public myarray = [1,2,3];
    string[]public myfruite=["apple","banana","keri"];
    string [] public temp =["hrllo","vk"];
    uint256 [][]public arr_2d = [[1,2,3],[4,5,6]];

    function pushdata(string memory _value ) public{
        temp.push(_value);
    } 
    function valueVCount() public view returns(string[] memory){
        for(uint i=0;i<temp.length;i++){
          temp[i];
        }
        return temp;
    }
}