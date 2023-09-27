// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title ICarbonCredit
 * @dev ICarbonCredit interface to interact with CarbonCredit contract
 */
interface ICarbonCredit {
    function mint(address _company, uint256 _amount) external;

    function grantRole(bytes32 role, address account) external;
}
