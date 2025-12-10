// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

import {Script, console2} from "forge-std/Script.sol";
import {DynamicNFT} from "../src/erc721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployNFT is Script {
    function run() external returns (DynamicNFT) {
        string memory svg = vm.readFile("./image/image.svg");

        vm.startBroadcast();
        DynamicNFT dynamicNft = new DynamicNFT(svgToImageURI(svg));
        vm.stopBroadcast();
        return dynamicNft;
    }

    function deployForTest() public returns (DynamicNFT) {
        string memory svg = vm.readFile("./image/image.svg");

        DynamicNFT dynamicNFT = new DynamicNFT(svgToImageURI(svg));
        return dynamicNFT;
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory uri) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );

        uri = string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

    
}
