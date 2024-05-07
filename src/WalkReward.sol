// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@Openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@Openzeppelin/contracts/utils/Base64.sol";

contract WalkReward {
    //errors
    error ColorNft__CantFlipColorIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_blackSvgImageUri;
    string private s_purpleSvgImageUri;

    enum Color {
        BLACK,
        PURPLE
    }

    mapping(uint256 => Color) private s_tokenIdToColor;

    constructor(
        string memory blackSvgImageUri,
        string memory purpleSvgImageUri
    ) ERC721("Ethereum Color NFT", "EC") {
        s_tokenCounter = 0;
        s_blackSvgImageUri = blackSvgImageUri;
        s_purpleSvgImageUri = purpleSvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToColor[s_tokenCounter] = Color.BLACK;
        s_tokenCounter++;
    }

    function flipColor(uint256 tokenId) public {
        //1 - Only the NFT owner can change the color
        address addressFrom = _ownerOf(tokenId);
        _checkAuthorized(addressFrom, msg.sender, tokenId);

        if (s_tokenIdToColor[tokenId] == Color.BLACK) {
            s_tokenIdToColor[tokenId] = Color.PURPLE;
        } else {
            s_tokenIdToColor[tokenId] = Color.BLACK;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToColor[tokenId] == Color.BLACK) {
            imageURI = s_blackSvgImageUri;
        } else {
            imageURI = s_purpleSvgImageUri;
        }

        // We can use string.concat or abi.encodePacked
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"Ethereum Logo"',
                                ', "description": "An NFT that changes Ethereum logo color. 100% on chain.", ',
                                '"attributes": [{"trait_type": "Logo size", "value": "100"}], "image": "',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    // getter
    function getColor(uint256 tokenId) external view returns (Color) {
        return s_tokenIdToColor[tokenId];
    }
}
