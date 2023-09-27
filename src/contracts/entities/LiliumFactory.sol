// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Lilium} from "@contracts/entities/Lilium.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {LiliumFactoryData} from "@structs/LiliumFactoryData.sol";
import {CarbonCredit} from "@contracts/token/ERC20/CarbonCredit.sol";

contract LiliumFactory is AccessControl {
    LiliumFactoryData public liliumFactory;

    bytes32 public constant AGENT_ROLE = keccak256("AGENT_ROLE");

    mapping(address => address) public tokens;

    error Unouthorized();

    event NewCertifier(address _certifier, address _token);

    constructor(
        address _InputBox,
        address _EtherPortal,
        address _ERC20Portal,
        address _DAppAddressRelay,
        address _PriceFeed,
        address _agent
    ) {
        liliumFactory.cartesiInputBox = _InputBox;
        liliumFactory.cartesiEtherPortal = _EtherPortal;
        liliumFactory.cartesiERC20Portal = _ERC20Portal;
        liliumFactory.cartesiDAppAddressRelay = _DAppAddressRelay;
        liliumFactory.parityRouter = _PriceFeed;
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
     * @notice Get Cartesi Certifier Contract Address
     * @dev This function get cartesi certifier contract address. This function is external because it is called by certifier contract
     * @return address of cartesi certifier contract
     */
    function getToken(address _certifier) external view returns (address) {
        address token = tokens[_certifier];
        return token;
    }

    /**
     * @notice Create new certifier
     * @dev This function create new certifier contract and token contractaddress
     * @param _agent agent address
     * @param tokenName token name
     * @param tokenSymbol token symbol
     * @param decimals token decimals
     */
    function newLilium(address _agent, string memory tokenName, string memory tokenSymbol, uint8 decimals)
        public
        onlyRole(AGENT_ROLE)
        returns (address, address)
    {
        Lilium lilium = new Lilium(
            address(this),
            liliumFactory.cartesiInputBox,
            liliumFactory.cartesiEtherPortal,
            liliumFactory.cartesiERC20Portal,
            liliumFactory.cartesiDAppAddressRelay,
            _agent
        );
        CarbonCredit token = new CarbonCredit(
            tokenName,
            tokenSymbol,
            decimals,
            address(lilium),
            liliumFactory.parityRouter
        );
        tokens[address(lilium)] = address(token);
        emit NewCertifier(address(lilium), address(token));
        return (address(lilium), address(token));
    }
}
