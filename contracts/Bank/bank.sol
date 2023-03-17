// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20 {
    function transferFrom(address sender,address recipient,uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns(bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Bank {
    mapping(address => uint256) public balances;
    ERC20 public token;

    constructor(address _token) {
        token = ERC20(_token);
    }
    //Token Part
    function depositToken(uint256 amount) external {
        require(token.transferFrom(msg.sender, address(this), amount),"Transfer failed");
        balances[msg.sender] += amount;
    }
    function withdrawToken(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(token.balanceOf(address(this)) >= amount,"Contract balance is insufficient");
        require(token.transfer(msg.sender, amount), "Transfer failed");
        balances[msg.sender] -= amount;
    }
    function getContractBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
    //ETH part
    mapping(address => uint256) public balance;

    function depositETH() external payable {
        balance[msg.sender] += msg.value;
    }

    function withdrawETH(uint256 _amount) external {
        require(balance[msg.sender] >= _amount, "Insufficent Funds");
        payable(msg.sender).transfer(_amount);
        balance[msg.sender] -= _amount;
        
    }
    function contractBalance() external view returns(uint){
        return address(this).balance;
    }
   
}
