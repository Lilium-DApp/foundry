// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/**
 * @title Forest Reserve Data
 * @dev Forest Reserve struct store Forest data
 */
struct ForestReserveData {
    address token;
    string geographicLocation;
    string vegetation;
    uint256 carbonCreditsEmitted;
    string weatherConditions;
    uint256 hourlyCompensation;
    address cartesiAuction;
    address cartesiVerifier;
    address cartesiInputBox;
    address cartesiERC20Portal;
    address cartesiEtherPortal;
    address cartesiDAppAddressRelay;
    mapping(address => uint256) ledger;
}
