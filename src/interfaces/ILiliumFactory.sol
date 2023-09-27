// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/**
 * @title ILiliumFactory
 * @dev ILiliumFactory interface to interact with Lilium contract
 */
interface ILiliumFactory {
    function getToken(address _certifier) external view returns (address);
}
