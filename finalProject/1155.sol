// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.7; 

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol"; 
import "@openzeppelin/contracts/utils/Counters.sol"; 

contract marketplace1155 is ERC1155 {
    mapping (uint256 => string) private _tokenURIs;
    using Counters for Counters.Counter; 
    Counters.Counter private _tokenIds; 

    constructor() ERC1155("") {}

    function mintToken(string memory tokenURI, uint256 amount) public returns(uint256) { 
        uint256 newItemId = _tokenIds.current(); 
        _mint(msg.sender, newItemId, amount, "");
        _setTokenUri(newItemId, tokenURI); 
        _tokenIds.increment(); 
        return newItemId; 
    } 

    function uri(uint256 tokenId) override public view returns (string memory) { 
        return _tokenURIs[tokenId]; 
    } 

    function _setTokenUri(uint256 tokenId, string memory tokenURI) private {
        _tokenURIs[tokenId] = tokenURI; 
    } 

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == 0xd9b67a26;
    }
}