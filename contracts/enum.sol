//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
contract sample{
    enum size{SMALL , MEDIUM, BIG}
    size public choice = size.MEDIUM;

    function setSizeSMALL() public {
        choice=size.SMALL;
    }
    function setSizeMEDIUM() public{
        choice=size.MEDIUM;
    }
    function setSizeBIG () public{
        choice= size.BIG;
    }

    function getSize() public view returns(size){
        return choice;
    }
}