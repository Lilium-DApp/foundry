// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {ForestReserveArgs} from "@utils/storage/NewForestReserveArgs.sol";

contract SetupForestReserve is Script {
    ForestReserveArgs public forestReserveArgs;

    constructor() {
        forestReserveArgs = getNewCompanyArgs();
    }

    function getNewCompanyArgs() internal view returns (ForestReserveArgs memory _forestReserveArgs) {
        _forestReserveArgs = ForestReserveArgs({
            geographicLocation: "Brazil",
            vegetation: "Amazon",
            carbonCreditsEmitted: 10000000000000,
            weatherConditions: "Sunny",
            hourlyCompensation: 10000,
            agent: vm.envAddress("ADDRESS_FOREST_AGENT_TESTNET")
        });
    }
}
