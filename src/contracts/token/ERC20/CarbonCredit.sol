// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {CarbonCreditData} from "@structs/CarbonCreditData.sol";
import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/interfaces/AggregatorV3Interface.sol";

/**
 * @title Set Cartesi Cer
 * @dev This contract is a insterface to interact with certifier cartesi machine, and other attributes of carbon credit
 */
contract CarbonCredit is AccessControl, ERC20 {
    CarbonCreditData public token;

    bytes32 constant MINTER_ROLE = keccak256("MINTER_ROLE");

    error InsufficientAmount(uint256 _amount);

    event Retire(address _sender, uint256 _amount);

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint8 _decimals,
        address _certifier,
        address _priceFeed
    ) ERC20(_tokenName, _tokenSymbol) {
        token.decimals = _decimals;
        token.parityRouter = _priceFeed;
        _grantRole(DEFAULT_ADMIN_ROLE, _certifier);
    }

    /**
     * @notice ETH-USD parity price
     * @dev This function stream onchain ETH-USD parity price with chainlink Data Feed
     * @return int256 ETH-USD parity price
     */
    function quoteParity() public view returns (int256) {
        (, int256 price,,,) = AggregatorV3Interface(token.parityRouter).latestRoundData();
        return price / 1e8;
    }

    /**
     * @notice Token Decimals
     * @dev This function returns token (CarbonCredit) decimals
     * @return uint8 token decimals
     */
    function decimals() public pure override returns (uint8) {
        return 2;
    }

    /**
     * @notice Mint Token
     * @dev This function mint token (CarbonCredit) to an address intermediated by company contract
     * @param _to company agent address to mint token
     * @param _amount amount of token to mint
     */
    function mint(address _to, uint256 _amount) public onlyRole(MINTER_ROLE) {
        _mint(_to, _amount);
    }

    /**
     * @notice Retire/Burn Token
     * @dev This function retire/burn token (CarbonCredit) from an address
     * @param _amount amount of token to retire/burn
     */
    function retire(uint256 _amount) external {
        if (balanceOf(msg.sender) < _amount) {
            revert InsufficientAmount(_amount);
        } else {
            _burn(msg.sender, _amount);
            emit Retire(msg.sender, _amount);
        }
    }
}
