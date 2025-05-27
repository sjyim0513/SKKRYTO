// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ojNFT is ERC721 {
    constructor(string memory name_, string memory symbol_, uint256 tokenId_)
        ERC721(name_, symbol_)
    {
        _mint(msg.sender, tokenId_);
    }

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}