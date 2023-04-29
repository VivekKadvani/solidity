// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Vesting {
ERC20 public token;
address owner;
constructor(address _token) {
    token = ERC20(_token);
    owner = msg.sender;
}
struct VestingSchedule {
    uint256 amount;
    uint256 start;
    uint256 duration;
    uint8 slice_period;
    uint8 cliff;
    uint256 recive_on_interval;
    // uint256 last_timestamp;
    address beneficiaries;
    uint256 total_withdrawable;
    uint256 temp;
    uint remain_token;
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

event VestingLocked(address indexed beneficiary, uint256 amount, uint256 duration, uint8 slice_period, uint256 start, uint8 cliff);
event VestingWithdrawn(address indexed beneficiary, uint256 index, uint256 amount);


function lock(
    uint256 _amount,
    uint256 _duration,
    uint8 _slice_period,
    uint256 _start,
    uint8 _cliff,
    address _beneficiaries
) external {
    require(_start > getTime(),"eneter valid time" );
    require(whitelist[msg.sender], "You are not allowed to use this contract.");
    VestingSchedule memory newVesting = VestingSchedule({
        amount: _amount,
        cliff: _cliff,
        start: _start + _cliff,
        duration: _duration,
        slice_period: _slice_period,
        beneficiaries: _beneficiaries,
        recive_on_interval: (_slice_period * _amount) / _duration,
        // last_timestamp: _start + _cliff,
        total_withdrawable: 0,
        temp: 0,
        remain_token : _amount % (_duration / _slice_period)
    });

    vestings[msg.sender].push(newVesting);

    token.transferFrom(msg.sender, address(this), _amount);

    emit VestingLocked(msg.sender, _amount, _duration, _slice_period, _start, _cliff);
}

function withdraw(uint256 index) external {
    VestingSchedule storage vesting = vestings[msg.sender][index];

    require(vesting.locked, "Funds have not been locked");
    require(getTime() > vesting.start, "Token under locking please wait..");

    
        vesting.total_withdrawable = calculate_available_withdraw_token(index);
        require(vesting.total_withdrawable > 0, "you not able to withdraw during lock");
        token.transfer(msg.sender, vesting.total_withdrawable);
        vesting.temp += vesting.total_withdrawable;
        vesting.amount -= vesting.total_withdrawable;
        if (vesting.amount == 0) {
            vesting.locked = false;
        }
        emit VestingWithdrawn(msg.sender, index, vesting.total_withdrawable);
    
}


function calculate_available_withdraw_token(uint256 index) public returns(uint256) {
    VestingSchedule storage vesting = vestings[msg.sender][index];
    require(vesting.amount>0 , "vesting time over");
    uint256 total_slice_count = (getTime() - vesting.start) / vesting.slice_period;
    uint256 total_mul_withdraw = (total_slice_count * vesting.recive_on_interval) - vesting.temp;
    if(vesting.amount <= vesting.remain_token){
     return calculate_remaining_token(index);

    }
    require(total_mul_withdraw <= vesting.amount, "vesting complete");
    return total_mul_withdraw;
}

function calculate_remaining_token(uint index) private returns(uint256){
    VestingSchedule storage vesting = vestings[msg.sender][index];
    uint256 remain_token;
    remain_token = vesting.amount % (vesting.duration / vesting.slice_period) ;
    token.transfer(msg.sender, vesting.remain_token);
    vesting.temp += vesting.amount;

    vesting.amount = 0;
    return remain_token;
}

function getTime() public view returns (uint256) {
    return block.timestamp;
}
}