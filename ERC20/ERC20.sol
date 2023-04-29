// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 { 
    constructor() ERC20("LatestVkToken2","vk2"){
        _mint(msg.sender,10 ** decimals());
    }
        function decimals() public view virtual override returns (uint8) {
        return 10;
    }
}