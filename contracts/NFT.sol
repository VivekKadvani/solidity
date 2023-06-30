//SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
interface ERC721TokenReceiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

pragma solidity ^0.8.0;

contract Mytoken is ERC721 {
     constructor() ERC721("MyToken", "MTK") {}


    function transferToOtherContract(address recipientContract, uint256 tokenId, bytes memory data) external {
        // Check if the recipient contract supports ERC721 token transfers
        require(
            ERC721TokenReceiver(recipientContract).onERC721Received(address(this), msg.sender, tokenId, data) == 
            bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")),
            "Recipient contract does not support ERC721 token transfers"
        );

        // Perform the token transfer
       
    }


}