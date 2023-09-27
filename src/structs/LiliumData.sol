// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/**
 * @title Lilium
 * @dev Lilium struct store Certifier data
 */
struct LiliumData {
    address factory;
    address cartesiInputBox;
    address cartesiERC20Portal;
    address cartesiEtherPortal;
    address cartesiDAppAddressRelay;
}
