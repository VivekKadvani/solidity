//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract bank {
    
    string public name = "vkToken";
    string public symbol = "vk";
    uint public decimal =10;
    uint256 public totalSupply= 1000;

    //mapping of Token
    mapping(address => uint256) public TokenBalanceof;
    mapping(address=> uint256) public BalanceInContract;
    mapping(address => mapping(address => uint256)) public allowence ; 
    //maping for ETH
    mapping(address => uint)private balance;
    mapping(address => uint)private TotalContractToken;
    mapping(address => uint)private Tokenbalance;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(){
        TokenBalanceof[msg.sender]=1000;
    }

    function transfer(address _to, uint256 _value) public returns (bool success){
        require(_value <= TokenBalanceof[msg.sender], "not enough token");
        TokenBalanceof[msg.sender]-=_value;
        TokenBalanceof[_to]+=_value;
        emit Transfer(msg.sender, _to,_value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(allowence[_from][msg.sender]>=_value,"not approved to transfer");
        require(TokenBalanceof[_from]>=_value, "not enough amount ");
        TokenBalanceof[_to]+=_value;
        TokenBalanceof[_from]-=_value;
        allowence[_from][msg.sender] -=_value;
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        allowence[msg.sender][_spender]=_value;
        emit Approval(msg.sender, _spender, _value);
        return true;    
    }

    function depositToken(uint256 _token) public {
        require(TokenBalanceof[msg.sender] > _token,"not sufficent token");
        TokenBalanceof[msg.sender]-=_token;
        TotalContractToken[address(this)] +=_token;
        BalanceInContract[msg.sender]+=_token;
    }

    function withdrawToken(uint256 _token) public { 
        require(BalanceInContract[msg.sender] > _token ,"insufficent Funds");
        TotalContractToken[address(this)]-=_token;
        BalanceInContract[msg.sender]-=_token;
        TokenBalanceof[msg.sender]+=_token;
    }
    
    function CheckTokenBal() public view returns(uint256){
        return TotalContractToken[address(this)];
    }
    
    function deposit() public payable  {
        balance[msg.sender] +=msg.value;
    }

    function withdrawETH(uint _amount) public{
        require (balance[msg.sender]>= _amount, "Insufficent Funds");
        balance[msg.sender]-=_amount;
        payable(msg.sender).transfer(_amount);
    }

    function checkETHBalance() public view returns(uint){
        return balance[msg.sender];
    }
    
}    