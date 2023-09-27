// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {LiliumArgs} from "@utils/storage/NewLiliumArgs.sol";

contract SetupLilium is Script {
    LiliumArgs public liliumArgs;

    constructor() {
        liliumArgs = getNewCertifierArgs();
    }

    function getNewCertifierArgs() internal view returns (LiliumArgs memory _liliumArgs) {
        _liliumArgs = LiliumArgs({
            agent: vm.envAddress("ADDRESS_LILIUM_AGENT_TESTNET"),
            tokenName: "LILIUM",
            tokenSymbol: "LLM",
            tokenDecimals: 18
        });
    }
}
