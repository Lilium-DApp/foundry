// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ILilium} from "@interfaces/ILilium.sol";
import {LiliumData} from "@structs/LiliumData.sol";
import {ICarbonCredit} from "@interfaces/ICarbonCredit.sol";
import {ForestReserveData} from "@structs/ForestReserveData.sol";
import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";
import {ForestReserve} from "@contracts/entities/ForestReserve.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title Lilium
 * @notice This contract is responsible for create new company contract
 */
contract Lilium is AccessControl {
    LiliumData public lilium;

    bytes32 public constant AGENT_ROLE = keccak256("AGENT_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event NewCompany(address _company);

    constructor(
        address _factory,
        address _cartesiInputBox,
        address _cartesiEtherPortal,
        address _cartesiERC20Portal,
        address _cartesiDAppAddressRelay,
        address _agent
    ) {
        lilium.factory = _factory;
        lilium.cartesiInputBox = _cartesiInputBox;
        lilium.cartesiERC20Portal = _cartesiERC20Portal;
        lilium.cartesiEtherPortal = _cartesiEtherPortal;
        lilium.cartesiDAppAddressRelay = _cartesiDAppAddressRelay;
        _grantRole(DEFAULT_ADMIN_ROLE, _agent);
        _grantRole(AGENT_ROLE, _agent);
    }

    /**
     * @notice This function is responsible for add new agent
     * @param _newAgent New agent address
     */
    function addAgent(address _newAgent) public onlyRole(AGENT_ROLE) {
        _grantRole(DEFAULT_ADMIN_ROLE, _newAgent);
        _grantRole(AGENT_ROLE, _newAgent);
    }

    /**
     * @notice This function is responsible for create new forest reserve contract
     * @param _geographicLocation Forest reserve geographic location
     * @param _vegetation Forest reserve vegetation
     * @param _carbonCreditsEmitted Forest reserve carbon credits emitted
     * @param _weatherConditions Forest reserve weather conditions
     * @param _hourlyCompensation Forest reserve hourly compensation
     * @param _agent Forest reserve agent
     */
    function newForestReserve(
        string memory _geographicLocation,
        string memory _vegetation,
        uint256 _carbonCreditsEmitted,
        string memory _weatherConditions,
        uint256 _hourlyCompensation,
        address _agent
    ) public onlyRole(AGENT_ROLE) returns (address) {
        ForestReserve forestReserve = new ForestReserve(
            ILilium(lilium.factory).getToken(address(this)),
            _geographicLocation,
            _vegetation,
            _carbonCreditsEmitted,
            _weatherConditions,
            _hourlyCompensation,
            lilium.cartesiInputBox,
            lilium.cartesiEtherPortal,
            lilium.cartesiERC20Portal,
            lilium.cartesiDAppAddressRelay,
            _agent
        );
        _grantRole(DEFAULT_ADMIN_ROLE, _agent);
        _grantRole(AGENT_ROLE, _agent);
        ICarbonCredit(ILilium(lilium.factory).getToken(address(this))).grantRole(MINTER_ROLE, address(forestReserve));
        emit NewCompany(address(forestReserve));
        return (address(forestReserve));
    }
}
