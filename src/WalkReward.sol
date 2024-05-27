// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract DiceRoller is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    address public owner;

    event DiceRolled(uint256 randomResult);

    constructor(
        address vrfCoordinator,
        address linkToken,
        bytes32 _keyHash,
        uint256 _fee
    ) VRFConsumerBase(vrfCoordinator, linkToken) {
        keyHash = _keyHash;
        fee = _fee;
        owner = msg.sender;
    }

    function rollDice() public returns (bytes32 requestId) {
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK - fill contract with faucet"
        );
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(
        bytes32 requestId,
        uint256 randomness
    ) internal override {
        randomResult = (randomness % 20) + 1; // To get a number between 1 and 20
        emit DiceRolled(randomResult);
    }

    function withdrawLink() external {
        require(msg.sender == owner, "Only the owner can withdraw");
        LINK.transfer(msg.sender, LINK.balanceOf(address(this)));
    }
}
