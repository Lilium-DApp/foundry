// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {DeployerAccountsArgs} from "@utils/storage/DeployerAccountsArgs.sol";

contract SetupDeployerAccounts is Script {
    DeployerAccountsArgs public deployerAccountsArgs;

    mapping(uint256 => DeployerAccountsArgs) public deployerAccountByChainId;

    constructor() {
        deployerAccountByChainId[80001] = getMumbaiDeployerAccount();
        deployerAccountByChainId[11155111] = getSepoliaDeployerAccount();
        deployerAccountsArgs = deployerAccountByChainId[block.chainid];
    }

    function getSepoliaDeployerAccount() internal view returns (DeployerAccountsArgs memory sepoliaDeployerAccount) {
        sepoliaDeployerAccount = DeployerAccountsArgs({
            liliumAgent: vm.envUint("PRIVATE_KEY_LILIUM_AGENT_TESTNET"),
            forestAgent: vm.envUint("PRIVATE_KEY_FOREST_AGENT_TESTNET")
        });
    }

    function getMumbaiDeployerAccount() internal view returns (DeployerAccountsArgs memory mumbaiDeployerAccount) {
        mumbaiDeployerAccount = DeployerAccountsArgs({
            liliumAgent: vm.envUint("PRIVATE_KEY_LILIUM_AGENT_TESTNET"),
            forestAgent: vm.envUint("PRIVATE_KEY_FOREST_AGENT_TESTNET")
        });
    }
}
