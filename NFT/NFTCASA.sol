// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTCASA is ERC721URIStorage, Ownable {

    constructor() ERC721("NFTcasa", "NCS"){}

    function mint(address _to,uint256 _tokenId,string memory _uri)external onlyOwner {
        _mint(_to,_tokenId);
        _setTokenURI(_tokenId, _uri);
    }
}