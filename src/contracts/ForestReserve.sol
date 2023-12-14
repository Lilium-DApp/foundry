//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ForestReserveData} from "@structs/ForestReserveData.sol";
import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title forestReserve
 * @notice This contract is a insterface to interact with verifier and auction cartesi machine, and other attributes of forestReserve
 */
contract ForestReserve is AccessControl {
    ForestReserveData public forestReserve;

    bytes32 constant AGENT_ROLE = keccak256("AGENT_ROLE");
    bytes32 constant DEVICE_ROLE = keccak256("DEVICE_ROLE");
    bytes32 constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");

    event AgentAdded(address _agent);
    event DeviceAdded(address _device);
    event VerifyRealWorldState(string _realWorldData);

    constructor(
        address _cartesiInputBox,
        address _agent
    ) {
        forestReserve.cartesiInputBox = _cartesiInputBox;
        _grantRole(DEFAULT_ADMIN_ROLE, _agent);
        _grantRole(AGENT_ROLE, _agent);
    }

    /**
     * @notice Set Cartesi DApps Contracts
     * @dev This function set cartesi verifier and auction contract address after deploy, because it is not possible to set it before deploy since the cartesi machine is deployed later. In addition, it send cartesi machine auction address to cartesi dapp via relay
     * @param _cartesiVerifier address of cartesi verifier contract
     */
    function setCartesiDapp(address _cartesiVerifier) public onlyRole(AGENT_ROLE) {
        forestReserve.cartesiVerifier = _cartesiVerifier;
        _grantRole(VERIFIER_ROLE, _cartesiVerifier);
    }

    /**
     * @notice Add agent
     * @dev This function add agent address. Only agent can call this function
     * @param _newAgent address of agent
     */
    function addAgent(address _newAgent) public onlyRole(AGENT_ROLE) {
        _grantRole(DEFAULT_ADMIN_ROLE, _newAgent);
        _grantRole(AGENT_ROLE, _newAgent);
        emit AgentAdded(_newAgent);
    }

    /**
     * @notice Add hardware device
     * @dev This function add hardware device address. Only agent can call this function
     * @param _newDevice address of hardware device
     */
    function addDevice(address _newDevice) public onlyRole(AGENT_ROLE) {
        _grantRole(DEVICE_ROLE, _newDevice);
        emit DeviceAdded(_newDevice);
    }

    /**
     * @notice Verify real world state
     * @dev This function verify real world state. Only hardware device can call this function
     * @param _RealWorldData real world data. Which will be a json in bytes
     */
    function verifyRealWorldState(string memory _RealWorldData) public onlyRole(DEVICE_ROLE) {
        bytes memory _payload = abi.encodePacked(msg.sig, _RealWorldData);
        IInputBox(forestReserve.cartesiInputBox).addInput(forestReserve.cartesiVerifier, _payload);
        emit VerifyRealWorldState(_RealWorldData);
    }
}
