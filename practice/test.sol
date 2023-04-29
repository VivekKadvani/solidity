//SPDX-License-Identifier: unlicensed

pragma solidity ^0.8.0;
// interface calc{
//     function sum() external view returns(uint);
// }
// // import "./library.sol";
// contract test is calc{
//     function sum()external pure returns(uint){
        
//         uint index=2+2;
//         return index;
//     }

// }


// abstract contract MyAbsContract{
//     function myfunction() external pure virtual  returns(uint) ;
     
// }

// contract mycontract is MyAbsContract{
    
//     function myfunction()external override pure returns(uint) {
//         return 99;
//     }
// }


// contract mycontract{
//     uint public name=10;
//     uint[] public arr=[10,20,30,40];
//     constructor (){
//         name=11;
//     }
//     bytes13 public b3="abc";
//     bytes public bn="vivek";
//     function deposite() public payable{

//     }
//     function withdraw() pure public returns(string memory){
//         // name++;
//         string memory student="vivek";
//         // uint num=88;
//         return student;
//         // payable (msg.sender).transfer(address(this).balance);
//     }
//     function test()public view returns(uint){
//         return name;
//     }
    
// }



contract myContract{
    // student public s1;
    // constructor(){
    //     s1.no=9;
    //     s1.name="vivek";
    // }
    struct student{
        uint no;
        string name;
    }

    student[] public students;
    // students.push(student(2,"vivek"));
    uint public a;
    function addto() public {
    students.push(student(1,'v'));
    }
    // function getname() public view returns(string memory){
    //     return s1.name;
    // }
    // function getno() public view returns(uint){
    //     return s1.no;
    // }
    enum user{yes,no,khabarnai}
    user public u1=user.yes;
}