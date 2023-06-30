// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

 contract casino {
     ERC20 private token;
     uint256 private nonce;
     address owner;
     uint256 option;
     uint256 amount;
     uint256 public number ;

    constructor(address _token){
        owner =msg.sender;
        token = ERC20(_token);
    }


     function getRandomNumber() private returns (uint256) {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 10;
        nonce++;
        number=randomNumber;
        return randomNumber;
    }
    function bet(uint256 _option,uint256 _amount) public {
        require(token.balanceOf(address(this))>_amount *2 , "Currently Betting is risky.");
        option = _option;
        amount = _amount;
        uint256 win = (amount*2);
        token.transferFrom(msg.sender,address(this),_amount);
        if(compareNum(_option,getRandomNumber())){
            require(token.transfer(msg.sender , win),"Contract have not inough balance.");
        }
    }

   function compareNum(uint256 argument, uint256 num) private pure returns (bool) {
        if (argument == 1) {
            return (num > 5);
        } else if (argument == 2) {
            return (num < 5);
        } else if (argument == 3) {
            return (num == 5);
        } else {
            revert("Invalid argument");
        }
    }

    function collectTokenOwner() public {
        require(msg.sender == owner , "You are Not an Owner");
        token.transfer(msg.sender,token.balanceOf(address(this)));
    }
}