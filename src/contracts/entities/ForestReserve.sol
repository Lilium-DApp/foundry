//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ICarbonCredit} from "@interfaces/ICarbonCredit.sol";
import {ForestReserveData} from "@structs/ForestReserveData.sol";
import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ICartesiDApp} from "@cartesi/contracts/dapp/ICartesiDApp.sol";
import {IEtherPortal} from "@cartesi/contracts/portals/IEtherPortal.sol";
import {IERC20Portal} from "@cartesi/contracts/portals/IERC20Portal.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {IDAppAddressRelay} from "@cartesi/contracts/relays/IDAppAddressRelay.sol";

/**
 * @title forestReserve
 * @notice This contract is a insterface to interact with verifier and auction cartesi machine, and other attributes of forestReserve
 */
contract ForestReserve is AccessControl {
    ForestReserveData public forestReserve;

    bytes32 constant AGENT_ROLE = keccak256("AGENT_ROLE");
    bytes32 constant DEVICE_ROLE = keccak256("DEVICE_ROLE");
    bytes32 constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");

    error InsuficientAllowance(uint256 _amount);
    error GrantAllowanceFailed(address _cartesiERC20Portal, address _sender, uint256 _amount);
    error BidFailed(address _sender, uint256 _value, uint256 _interestedQuantity);
    error InsufficientBalance(address _sender, uint256 _balance);

    event NewAuction(
        bytes4 _function, address _sender, uint256 _amount, uint256 _duration, uint256 _reservePricePerToken
    );
    event NewBid(address _sender, uint256 _value, uint256 _interestedQuantity);
    event AgentAdded(address _agent);
    event DeviceAdded(address _device);
    event Stake(address _sender, uint256 _amount);
    event Withdraw(address _sender, uint256 _amount);
    event VerifyRealWorldState(string _realWorldData);
    event FinishAuction(address _sender, uint256 _timestamp);

    constructor(
        address _token,
        string memory _geographicLocation,
        string memory _vegetation,
        uint256 _carbonCreditsEmitted,
        string memory _weatherConditions,
        uint256 _hourlyCompensation,
        address _cartesiInputBox,
        address _cartesiERC20Portal,
        address _cartesiEtherPortal,
        address _cartesiDAppAddressRelay,
        address _agent
    ) {
        forestReserve.token = _token;
        forestReserve.geographicLocation = _geographicLocation;
        forestReserve.vegetation = _vegetation;
        forestReserve.carbonCreditsEmitted = _carbonCreditsEmitted;
        forestReserve.weatherConditions = _weatherConditions;
        forestReserve.hourlyCompensation = _hourlyCompensation;
        forestReserve.cartesiInputBox = _cartesiInputBox;
        forestReserve.cartesiERC20Portal = _cartesiERC20Portal;
        forestReserve.cartesiEtherPortal = _cartesiEtherPortal;
        forestReserve.cartesiDAppAddressRelay = _cartesiDAppAddressRelay;
        _grantRole(DEFAULT_ADMIN_ROLE, _agent);
        _grantRole(AGENT_ROLE, _agent);
    }

    /**
     * @notice Set Cartesi Certifier Contract
     * @dev This function set cartesi verifier and auction contract address after deploy, because it is not possible to set it before deploy since the cartesi machine is deployed later. In addition, it grant verifier and auction role to the contracts and send cartesi machine address to cartesi dapp via relay
     * @param _cartesiAuction address of cartesi auction contract
     * @param _cartesiVerifier address of cartesi verifier contract
     */
    function setCartesiMachines(address _cartesiAuction, address _cartesiVerifier) public onlyRole(AGENT_ROLE) {
        forestReserve.cartesiAuction = _cartesiAuction;
        forestReserve.cartesiVerifier = _cartesiVerifier;
        _grantRole(VERIFIER_ROLE, _cartesiVerifier);
        IDAppAddressRelay(forestReserve.cartesiDAppAddressRelay).relayDAppAddress(_cartesiAuction);
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
     * @notice Decrease allowance to mint token
     * @dev This function decrease allowance to mint token. This function is private because only mint function can call this function
     * @param _amount amount of token to decrease allowance
     */
    function _decreaseAllowance(address _sender, uint256 _amount) private {
        forestReserve.carbonCreditsEmitted -= _amount;
        forestReserve.ledger[_sender] += _amount;
    }

    /**
     * @notice Stake tokens
     * @dev This function stake tokens. Only agent can call this function
     * @param _amount amount of token to stake
     */
    function stake(uint256 _amount) public onlyRole(AGENT_ROLE) {
        if (forestReserve.carbonCreditsEmitted < _amount) {
            revert InsuficientAllowance(_amount);
        } else {
            _decreaseAllowance(msg.sender, _amount);
            ICarbonCredit(forestReserve.token).mint(address(this), _amount);
            emit Stake(msg.sender, _amount);
        }
    }

    /**
     * @notice Withdraw tokens
     * @dev This function withdraw tokens. Only agent can call this function
     * @param _amount amount of token to withdraw
     */
    function withdraw(uint256 _amount) public onlyRole(AGENT_ROLE) {
        if (forestReserve.ledger[msg.sender] < _amount) {
            revert InsufficientBalance(msg.sender, forestReserve.ledger[msg.sender]);
        } else {
            forestReserve.ledger[msg.sender] -= _amount;
            IERC20(forestReserve.token).transfer(msg.sender, _amount);
            emit Withdraw(msg.sender, _amount);
        }
    }

    /**
     * @notice Increase allowance to mint token
     * @dev This function increase allowance to mint token. Only verifier cartesi machine can call this function
     */
    function increaseAllowance() external onlyRole(VERIFIER_ROLE) {
        forestReserve.carbonCreditsEmitted += forestReserve.hourlyCompensation;
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

    /**
     * @notice Create new auction
     * @dev This function create new auction. Only agent can call this function. In the process, the function gives permission for the ERC20Portal contract to transfer the wallet value from msg.sender to the cartesi dapp and then calls the ERC20Portal sending in addition to the value an _executelayerdata in bytes containing the duration of the auction and the _reservePricePerToken
     * @param _amount amount of token to auction
     * @param _duration duration of auction in hours
     * @param _reservePricePerToken reserve price per token
     */
    function newAuction(uint256 _amount, uint256 _duration, uint256 _reservePricePerToken)
        public
        onlyRole(AGENT_ROLE)
    {
        bool approve = IERC20(forestReserve.token).approve(forestReserve.cartesiERC20Portal, _amount);
        if (!approve) {
            revert GrantAllowanceFailed(forestReserve.cartesiERC20Portal, msg.sender, _amount);
        } else {
            bytes memory _execLayerData =
                abi.encodePacked(msg.sig, msg.sender, _duration * 1 hours, _reservePricePerToken);
            IERC20Portal(forestReserve.cartesiERC20Portal).depositERC20Tokens(
                IERC20(forestReserve.token), forestReserve.cartesiAuction, _amount, _execLayerData
            );
            emit NewAuction(msg.sig, msg.sender, _amount, _duration * 1 hours, _reservePricePerToken);
        }
    }

    /**
     * @notice Create new bid
     * @dev this function transfer an amount in ether to Auction Cartesi Machine calling EtherPortal contract sending in addition to the value an _executelayerdata in bytes containing the interestedQuantity of the amount offered
     * @param _interestedQuantity interested quantity of the amount offered
     */
    function newBid(uint256 _interestedQuantity) public payable {
        bytes memory _executeLayerData = abi.encodePacked(msg.sig, msg.sender, _interestedQuantity);
        (bool success,) = address(forestReserve.cartesiEtherPortal).call{value: msg.value}(
            abi.encodeWithSignature("depositEther(address,bytes)", forestReserve.cartesiAuction, _executeLayerData)
        );
        if (!success) {
            revert BidFailed(msg.sender, msg.value, _interestedQuantity);
        } else {
            emit NewBid(msg.sender, msg.value, _interestedQuantity);
        }
    }

    /**
     * @notice finishAuction to Auction Cartesi Machine
     * @dev This function send a finish command to Auction Cartesi Machine. This function need be called by the same person who called newAuction function.
     */
    function finishAuction() public {
        bytes memory _executeLayerData = abi.encodePacked(msg.sig);
        IInputBox(forestReserve.cartesiInputBox).addInput(forestReserve.cartesiAuction, _executeLayerData);
        emit FinishAuction(msg.sender, block.timestamp);
    }
}
