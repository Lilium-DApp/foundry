// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {ForestReserve} from "@contracts/ForestReserve.sol";

contract DeployLilium is Script {
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY_LILIUM_AGENT_TESTNET"));
        ForestReserve forestReserve = new ForestReserve(0x5a723220579C0DCb8C9253E6b4c62e572E379945, 0xA08f2A571d48465B7b82b5B3CBe90C0892D16111);
        vm.stopBroadcast();

        console.log("Forest Reserve address:", address(forestReserve));
    }
}
