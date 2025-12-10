// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {DynamicNFT} from "../src/erc721.sol";

contract TestNFT is Test {
    DynamicNFT public dynamicNFT;
    string private nft =
        "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0MDAgMzAwIj4NCiAgICA8c3R5bGU+DQogICAgICAgIC5jaXJjbGUgew0KICAgICAgICAgICAgdHJhbnNpdGlvbjogYWxsIDFzIGVhc2UtaW4tb3V0Ow0KICAgICAgICAgICAgc3Ryb2tlLWRhc2hhcnJheTogNzMuMjYgNzMuMjY7DQogICAgICAgICAgICBzdHJva2UtZGFzaG9mZnNldDogMzE0Ow0KICAgICAgICB9DQogICAgICAgIA0KICAgICAgICAuY2lyY2xlOmhvdmVyIHsNCiAgICAgICAgICAgIHN0cm9rZS1kYXNob2Zmc2V0OiAwOw0KICAgICAgICB9DQogICAgPC9zdHlsZT4NCiAgICA8Y2lyY2xlIHI9IjEwMCIgZmlsbD0iI2NmMTIyMSIgY3g9IjUwJSIgY3k9IjUwJSIvPiAgDQogICAgPGNpcmNsZSBjbGFzcz0iY2lyY2xlIiByPSI3MCIgZmlsbD0iI2NmMTIyMSIgY3g9IjUwJSIgY3k9IjUwJSIgc3Ryb2tlPSJnb2xkIiBzdHJva2Utd2lkdGg9IjMwIi8+DQogICAgPGNpcmNsZSByPSIyMCIgY3g9IjUwJSIgY3k9IjUwJSIgZmlsbD0iZ29sZCIgLz4gIA0KPC9zdmc+";

    address user1 = makeAddr("user1");

    function setUp() public {
        dynamicNFT = new DynamicNFT(nft);
    }

    function testNFTMint() public {
        vm.prank(user1);
        uint256 tokenId = dynamicNFT.mintNFT();
        string memory json = dynamicNFT.tokenURI(tokenId);
        console.log(json);
    }
}
