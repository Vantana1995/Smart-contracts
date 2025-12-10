// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {DynamicNFT} from "../src/erc721.sol";
import {DeployNFT} from "../script/DeployNFT.s.sol";

contract TestNFT is Test {
    DynamicNFT public dynamicNFT;
    address user1 = makeAddr("user1");
    DeployNFT public deployer;

    function setUp() public {
        deployer = new DeployNFT();
        dynamicNFT = deployer.deployForTest();
    }

    function testNFTMint() public {
        vm.prank(user1);
        uint256 tokenId = dynamicNFT.mintNFT();
        string memory json = dynamicNFT.tokenURI(tokenId);
        console.log(json);
    }

    function testConvertSvgToUri() public view {
        string
            memory expectedUri = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0MDAgMzAwIj48c3R5bGU+LmNpcmNsZSB7dHJhbnNpdGlvbjogYWxsIDFzIGVhc2UtaW4tb3V0O3N0cm9rZS1kYXNoYXJyYXk6IDczLjI2IDczLjI2O3N0cm9rZS1kYXNob2Zmc2V0OiAzMTQ7fS5jaXJjbGU6aG92ZXIge3N0cm9rZS1kYXNob2Zmc2V0OiAwO308L3N0eWxlPjxjaXJjbGUgcj0iMTAwIiBmaWxsPSIjY2YxMjIxIiBjeD0iNTAlIiBjeT0iNTAlIi8+ICA8Y2lyY2xlIGNsYXNzPSJjaXJjbGUiIHI9IjcwIiBmaWxsPSIjY2YxMjIxIiBjeD0iNTAlIiBjeT0iNTAlIiBzdHJva2U9ImdvbGQiIHN0cm9rZS13aWR0aD0iMzAiLz48Y2lyY2xlIHI9IjIwIiBjeD0iNTAlIiBjeT0iNTAlIiBmaWxsPSJnb2xkIiAvPiAgPC9zdmc+";
        string
            memory svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 300"><style>.circle {transition: all 1s ease-in-out;stroke-dasharray: 73.26 73.26;stroke-dashoffset: 314;}.circle:hover {stroke-dashoffset: 0;}</style><circle r="100" fill="#cf1221" cx="50%" cy="50%"/>  <circle class="circle" r="70" fill="#cf1221" cx="50%" cy="50%" stroke="gold" stroke-width="30"/><circle r="20" cx="50%" cy="50%" fill="gold" />  </svg>';
        string memory convertedUri = deployer.svgToImageURI(svg);
        assert(
            keccak256(abi.encodePacked(convertedUri)) ==
                keccak256(abi.encodePacked(expectedUri))
        );
    }
}
