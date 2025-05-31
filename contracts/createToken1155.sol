// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ERC1155.sol";

contract createToken1155 is ERC1155 {

  constructor(uint256 id, uint256 amount)
    {
        _mint(msg.sender, id, amount, "");
    }
}