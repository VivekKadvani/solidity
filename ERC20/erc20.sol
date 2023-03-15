// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
 contract MyToken{

    string public name = "vkToken";
    string public symbol = "vk";
    uint public decimal =10;
    uint256 public totalSupply= 1000;

    mapping(address => uint256) public balanceof;
    mapping(address => mapping(address => uint256)) public allowence ; 

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(){
        balanceof[msg.sender]=1000;
    }
    function transfer(address _to, uint256 _value) public returns (bool success){
        require(_value <= balanceof[msg.sender], "not enough token");
        balanceof[msg.sender]-=_value;
        balanceof[_to]+=_value;
        emit Transfer(msg.sender, _to,_value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(allowence[_from][msg.sender]>=_value,"not approved to transfer");
        require(balanceof[_from]>=_value, "not enough amount ");
        balanceof[_to]+=_value;
        balanceof[_from]-=_value;
        allowence[_from][msg.sender] -=_value;
        return true;


    }
    function approve(address _spender, uint256 _value) public returns (bool success){
        allowence[msg.sender][_spender]=_value;
        emit Approval(msg.sender, _spender, _value);
        return true;    
    }

 }