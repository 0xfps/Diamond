// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.14;

import "../storage/AdditionStorage.sol";

/**
* @title Addition Facet.
* @author Anthony (fps) https://github.com/0xfps.
* @dev  Simple addition facet that adds two numbers 
*       and returns the total.
*/
contract AdditionFacet {
    uint public j;

    function add(uint256 a, uint256 b) public returns(uint256) {
        j = AdditionStorage.add(a, b);
        return j;
    }
}