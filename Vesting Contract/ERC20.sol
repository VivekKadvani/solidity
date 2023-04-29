// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 { 
    constructor(uint256 initialsupply) ERC20("myToken","vk"){
        _mint(msg.sender,initialsupply ** decimals());
    }
        function decimals() public view virtual override returns (uint8) {
        return 10;
    }
}