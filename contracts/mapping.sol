//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract sample {
    mapping(uint => string) public names;

    constructor(){
        names[1]="vivek";
        names[2]="mayur";
        names[3]="div";
    }

   
    struct Book{
        string title;
        string author;
    }

    mapping(uint => Book) public books;
    function addBook(uint _id, string memory _title, string memory _author) public{
        books[_id]=Book(_title , _author);
    }


    mapping(address => mapping(uint => Book)) public Mybook;
    function addMyBook(uint _id, string memory _title, string memory _author) public{
        Mybook[msg.sender][_id]=Book(_title , _author);
    }
}
