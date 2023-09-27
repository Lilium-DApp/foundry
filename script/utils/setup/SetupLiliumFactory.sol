// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {LiliumFactoryArgs} from "@utils/storage/NewLiliumFactoryArgs.sol";

contract SetupLiliumFactory {
    LiliumFactoryArgs public liliumFactoryArgs;

    mapping(uint256 => LiliumFactoryArgs) public chainIdToNetworkConfig;

    constructor() {
        chainIdToNetworkConfig[11155111] = getSepoliaLiliumArgs();
        chainIdToNetworkConfig[80001] = getMumbaiLiliumArgs();
        liliumFactoryArgs = chainIdToNetworkConfig[block.chainid];
    }

    function getSepoliaLiliumArgs() internal pure returns (LiliumFactoryArgs memory sepoliaNetworkConfig) {
        sepoliaNetworkConfig = LiliumFactoryArgs({
            inputBox: 0x5a723220579C0DCb8C9253E6b4c62e572E379945,
            etherPortal: 0xA89A3216F46F66486C9B794C1e28d3c44D59591e,
            erc20Portal: 0x4340ac4FcdFC5eF8d34930C96BBac2Af1301DF40,
            dappAddressRelay: 0x8Bbc0e6daB541DF0A9f0bDdA5D41B3B08B081d55,
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // ETH / USD
        });
    }

    function getMumbaiLiliumArgs() internal pure returns (LiliumFactoryArgs memory mumbaiNetworkConfig) {
        mumbaiNetworkConfig = LiliumFactoryArgs({
            inputBox: 0x5a723220579C0DCb8C9253E6b4c62e572E379945,
            etherPortal: 0xA89A3216F46F66486C9B794C1e28d3c44D59591e,
            erc20Portal: 0x4340ac4FcdFC5eF8d34930C96BBac2Af1301DF40,
            dappAddressRelay: 0x8Bbc0e6daB541DF0A9f0bDdA5D41B3B08B081d55,
            priceFeed: 0x0715A7794a1dc8e42615F059dD6e406A6594651A // ETH / USD
        });
    }
}
