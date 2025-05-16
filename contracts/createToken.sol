// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ERC20.sol";

contract createToken is ERC20 {

  constructor(string memory name_, string memory symbol_, uint256 initialSupply)
        ERC20(name_, symbol_)
    {
        mint(msg.sender, initialSupply);
    }

    function _mint(uint256 amount) external {
        mint(msg.sender, amount);
    }
}