// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

struct ForestReserveArgs {
    string geographicLocation;
    string vegetation;
    uint256 carbonCreditsEmitted;
    string weatherConditions;
    uint256 hourlyCompensation;
    address agent;
}
