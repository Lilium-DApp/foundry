// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Lilium} from "@contracts/entities/Lilium.sol";
import {SetupLilium} from "@utils/setup/SetupLilium.sol";
import {LiliumFactory} from "@contracts/entities/LiliumFactory.sol";
import {ForestReserve} from "@contracts/entities/ForestReserve.sol";
import {SetupForestReserve} from "@utils/setup/SetupForestReserve.sol";
import {SetupLiliumFactory} from "@utils/setup/SetupLiliumFactory.sol";
import {SetupDeployerAccounts} from "@utils/setup/SetupDeployerAccounts.s.sol";

contract DeployLilium is Script {
    SetupLilium helperConfigLilium = new SetupLilium();
    SetupDeployerAccounts deployerAccounts = new SetupDeployerAccounts();
    SetupForestReserve helperConfigForestReserve = new SetupForestReserve();
    SetupLiliumFactory helperConfigLiliumFactory = new SetupLiliumFactory();

    function run() external {
        (uint256 _liliumAgent, uint256 _forestAgent) = deployerAccounts.deployerAccountsArgs();

        (address _InputBox, address _EtherPortal, address _ERC20Portal, address _DAppAddressRelay, address _PriceFeed) =
            helperConfigLiliumFactory.liliumFactoryArgs();

        (address _liliumAgentAddress, string memory _tokenName, string memory _tokenSymbol, uint8 _tokenDecimals) =
            helperConfigLilium.liliumArgs();

        (
            string memory _geographicLocation,
            string memory _vegetation,
            uint256 _carbonCreditsEmitted,
            string memory _weatherConditions,
            uint256 _hourlyCompensation,
            address _forestAgentAddress
        ) = helperConfigForestReserve.forestReserveArgs();

        // Create Lilium Factory
        vm.startBroadcast(_liliumAgent);
        LiliumFactory liliumFactory = new LiliumFactory(
            _InputBox,
            _EtherPortal,
            _ERC20Portal,
            _DAppAddressRelay,
            _PriceFeed,
            _liliumAgentAddress
        );
        vm.stopBroadcast();

        // Create Lilium
        vm.startBroadcast(_liliumAgent);
        (address lilium,) = liliumFactory.newLilium(_liliumAgentAddress, _tokenName, _tokenSymbol, _tokenDecimals);
        vm.stopBroadcast();

        // Create Forest Reserve
        vm.startBroadcast(_liliumAgent);
        address forestReserve = Lilium(lilium).newForestReserve(
            _geographicLocation,
            _vegetation,
            _carbonCreditsEmitted,
            _weatherConditions,
            _hourlyCompensation,
            _forestAgentAddress
        );
        vm.stopBroadcast();

        // Initial interactions with Forest Reserve
        vm.startBroadcast(_forestAgent);
        ForestReserve(forestReserve).addDevice(vm.envAddress("ADDRESS_DEVICE_TESTNET"));
        ForestReserve(forestReserve).stake(1000);
        vm.stopBroadcast();

        console.log("Lilium Factory Address: %s; Lilium Address: %s; Forest Reserve Address: %s", address(liliumFactory), address(lilium), address(forestReserve));
    }
}
