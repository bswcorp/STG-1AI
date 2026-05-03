// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract STGCore {
    string public name = "Sovereign Titan Genesis";
    uint256 public totalSupply;

    event Mint(address indexed to, uint256 amount);

    function mint(uint256 amount) public {
        totalSupply += amount;
        emit Mint(msg.sender, amount);
    }
}
