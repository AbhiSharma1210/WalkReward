// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract WalkReward is ERC721, Ownable {
    uint256 public tokenCounter;

    constructor(
        string memory tokenName,
        string memory tokenSymbol
    ) public ERC721(tokenName, tokenSymbol) {}
}
