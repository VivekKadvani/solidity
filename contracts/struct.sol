//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
contract sample{

    struct student{
        string name;
        uint age;
    }
    student[] public allstudent;
    function setStudent(string memory _name,uint _age) public {
        student memory newstudent = student({name: _name,age : _age});
       
        allstudent.push(newstudent);
    } 
    
}