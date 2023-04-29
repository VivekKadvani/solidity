//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// Step 1: Create an ERC20 token. You can use OpenZeppelin to create the contract code for the token.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 1000);
    }
}

// Step 2: Create another contract for Bank
contract Bank {
    MyToken public token;

    constructor(address tokenAddress) {
        token = MyToken(tokenAddress);
    }

    // Step 3: Make sure the address that is going to deposit the ERC20 token into Bank has some balance.
    function deposit(uint256 amount) external {
        require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        // Step 4: The depositor has to approve the Bank contract to spend some tokens.
        require(token.allowance(msg.sender, address(this)) >= amount, "Must approve token transfer");

        // Step 5: In the deposit function of the Bank contract, you have to use the transferFrom function to transfer the tokens from the depositor's address to the Bank contract address.
        token.transferFrom(msg.sender, address(this), amount);
    }

    // Step 6: After the deposit is successful, you can use the balanceOf function in the token contract to check if the deposited balance is reflecting in the Bank contract.
    function getBankBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    // In the withdraw function of the Bank contract, you can use the transfer function to transfer tokens from the contract address to the msg.sender.
    function withdraw(uint256 amount) external {
        require(token.balanceOf(address(this)) >= amount, "Insufficient balance");
        token.transfer(msg.sender, amount);
    }
}
