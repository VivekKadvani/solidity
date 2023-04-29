// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Vesting {
ERC20 public token;
address owner;
address contractAddress;
constructor() {
    // token = ERC20(_token);
    owner = msg.sender;
    // contractAddress = _token;

}
struct VestingSchedule {
    uint256 amount;
    uint256 start;
    uint256 duration;
    bool locked;
    uint8 slice_period;
    uint8 cliff;
    uint256 recive_on_interval;
    address beneficiaries;
    uint256 temp;
}


mapping(address => VestingSchedule[]) public vestings;
mapping(address => bool) public whitelist;

modifier onlyOwner() {
    require(msg.sender == owner , "Only the contract owner can call this function");
    _;
}
function addWhitelist (address _add) public onlyOwner{
    whitelist[_add]=true;
} 

event VestingLocked(address beneficiary, uint256 amount, uint256 duration, uint8 slice_period, uint256 start, uint8 cliff);
event VestingWithdrawn(address beneficiary, uint256 index, uint256 amount);

modifier lock_rules(uint256 _amount,
    uint256 _duration,
    uint8 _cliff,
    address addressOfToken){
    require(_amount>0,"Amount not be Zero");
    require(whitelist[addressOfToken], "You are not allowed to use this contract.");
    require(_cliff < _duration, "Cliff must me less than duration");
    _;
}

function lock(
    uint256 _amount,
    uint256 _duration,
    uint8 _slice_period,
    uint8 _cliff,
    address _beneficiaries,
    address addressOfToken
) external lock_rules( _amount, _duration, _cliff, addressOfToken){
   
    VestingSchedule memory newVesting = VestingSchedule({
        amount: _amount,
        cliff: _cliff,
        start: block.timestamp,
        duration: _duration,
        locked: true,
        slice_period: _slice_period,
        beneficiaries: _beneficiaries,
        recive_on_interval: (_slice_period * _amount) / _duration,
        temp: 0
    });
    vestings[msg.sender].push(newVesting);
    token = ERC20(addressOfToken);
    token.transferFrom(msg.sender, address(this), _amount);

    emit VestingLocked(msg.sender, _amount, _duration, _slice_period, block.timestamp, _cliff);
}

function withdraw(uint256 index) external {
    VestingSchedule storage vesting = vestings[msg.sender][index];
    require(vesting.locked, "Funds have not been locked");
    require(getTime() > vesting.start, "Token under locking please wait..");
    require((vesting.cliff+vesting.start)< getTime(),"Cliff is not ended yet.");
    uint withdrawable = calculate_available_withdraw_token(index);
    require(withdrawable > 0 , "Not enough amount for withdraw");
    token.transfer(msg.sender, withdrawable);
    vesting.temp += withdrawable;
    vesting.amount -= withdrawable;
    if(vesting.amount==0)vesting.locked=false ;
    emit VestingWithdrawn(msg.sender, index, withdrawable);
}

function calculate_available_withdraw_token(uint256 index) public view returns(uint256) {
    VestingSchedule storage vesting = vestings[msg.sender][index];
    uint256 total_slice_count = (getTime() - vesting.start) / vesting.slice_period;
    uint256 total_mul_withdraw = (total_slice_count * vesting.recive_on_interval) - vesting.temp;
    if(total_mul_withdraw < vesting.amount){
        return total_mul_withdraw;
    }
    else{
        return vesting.amount;
    }
}

function getTime() public view returns (uint256) {
    return block.timestamp;
}
}