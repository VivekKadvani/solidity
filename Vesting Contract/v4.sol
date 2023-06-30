// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract VestingContract {
    ERC20 public token;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    struct VestingParams {
        uint256 amount;
        uint256 start;
        uint256 duration;
        uint256 slice_period;
        uint256 cliff;
        uint256 recive_on_interval;
        address beneficiaries;
        address TokenAddress;
    }

    struct VestingSchedule {
        uint256 VestingId;
        bool locked;
        uint256 claimed;
        VestingParams params;
    }

    mapping(address => VestingSchedule[]) public vestings;
    mapping(address => bool) public CheckWhitelist;
    address[] public WhiteListTokens;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    function addWhitelist(address _add) public onlyOwner {
        require(!CheckWhitelist[_add], "Token already added to whitelist");
        CheckWhitelist[_add] = true;
        WhiteListTokens.push(_add);
    }

    function removeWhitelist(address _add) public onlyOwner {
        require(CheckWhitelist[_add], "Token is not in whitelist");
        CheckWhitelist[_add] = false;
        delete CheckWhitelist[_add];
    }

    event VestingLocked(
        address beneficiary,
        uint256 amount,
        uint256 duration,
        uint256 slice_period,
        uint256 start,
        uint256 cliff,
        address Token
    );

    event VestingWithdrawn(address beneficiary, uint256 index, uint256 amount);

    modifier lock_rules(VestingParams memory params) {
        require(params.amount > 0, "Amount must not be zero");
        require(
            params.start > getTime(),
            "Start Time must be greater than current time."
        );
        require(
            params.start < (getTime() +params.start + params.duration),
            "Start Time must be less than End time."
        );
        require(
            CheckWhitelist[params.TokenAddress],
            "You are not allowed to use this contract."
        );
        require(
            params.cliff < (params.start +params.duration) ,
            "Cliff must be less than duration"
        );
        require(
            params.cliff > params.start,
            "Cliff must be greater than start time"
        );
        _;
    }

    function lock(
        uint256 _amount,
        uint256 _start,
        uint256 _duration,
        uint256 _slice_period,
        uint256 _cliff,
        address _beneficiaries,
        address _addressOfToken
    )
        external
        lock_rules(
            VestingParams({
                amount: _amount,
                start: _start + getTime(),
                duration: _duration,
                slice_period: _slice_period,
                cliff: _cliff + getTime(),
                recive_on_interval: (_slice_period * _amount) / _duration,
                beneficiaries: _beneficiaries,
                TokenAddress: _addressOfToken
            })
        )
    {
        VestingSchedule memory newVesting = VestingSchedule({
            VestingId: vestings[_beneficiaries].length,
            locked: true,
            claimed: 0,
            params: VestingParams({
                amount: _amount,
                start: _start+getTime(),
                duration: _duration,
                slice_period: _slice_period,
                cliff: _cliff,
                recive_on_interval: (_slice_period * _amount) / _duration,
                beneficiaries: _beneficiaries,
                TokenAddress: _addressOfToken
            })
        });
        vestings[_beneficiaries].push(newVesting);
        token = ERC20(_addressOfToken);
        token.transferFrom(msg.sender, address(this), _amount);

        emit VestingLocked(
            _beneficiaries,
            _amount,
            _duration,
            _slice_period,
            _start,
            _cliff,
            _addressOfToken
        );
    }

    function withdraw(uint256 index) external {
        VestingSchedule storage vesting = vestings[msg.sender][index];
        require(vesting.locked, "Funds have not been locked");
        require(
            getTime() > vesting.params.start,
            "Token under locking, please wait.."
        );
        require(
            (vesting.params.cliff + vesting.params.start) < getTime(),
            "Cliff period has not ended yet."
        );
        uint256 withdrawable = calculate_available_withdraw_token(index);
        require(withdrawable > 0, "Not enough amount available for withdrawal");
        ERC20(vesting.params.TokenAddress).transfer(msg.sender, withdrawable);
        vesting.claimed += withdrawable;
        vesting.params.amount -= withdrawable;
        if (vesting.params.amount == 0) {
            vesting.locked = false;
        }
        emit VestingWithdrawn(msg.sender, index, withdrawable);
    }

    function calculate_available_withdraw_token(uint256 index)
        public
        view
        returns (uint256)
    {   
        VestingSchedule memory vesting = vestings[msg.sender][index];
        require(getTime() > vesting.params.start,"Vesting not started yet");
        uint256 total_slice_count = (getTime() - vesting.params.start) /
            vesting.params.slice_period;
        uint256 total_mul_withdraw = (total_slice_count *
            vesting.params.recive_on_interval) - vesting.claimed;
        if (total_mul_withdraw < vesting.params.amount) {
            return total_mul_withdraw;
        } else {
            return vesting.params.amount;
        }
    }

    function getTime() public view returns (uint256) {
        return block.timestamp;
    }

    function getTotalVesting() public view returns (uint256) {
        return vestings[msg.sender].length;
    }

    function getTotalWhitelist() public view returns (uint256) {
        return WhiteListTokens.length;
    }
}