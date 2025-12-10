// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

import {ERC721} from "@openzeppelin/contracts/token/erc721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DynamicNFT is ERC721 {
    uint256 s_tokenCounter;
    string private s_imgSVGUri;

    constructor(string memory imgSVGuri) ERC721("DynamicNFT", "DNFT") {
        s_tokenCounter = 0;
        s_imgSVGUri = imgSVGuri;
    }

    function mintNFT() public returns (uint256 tokenId) {
        tokenId = s_tokenCounter;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory tokenMetadata = string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '", "description":"Action svg image on-chain", "attributes": [{"trait_type": "dangerous"}], "image": "',
                            s_imgSVGUri,
                            '"}'
                        )
                    )
                )
            )
        );
        return tokenMetadata;
    }
}
