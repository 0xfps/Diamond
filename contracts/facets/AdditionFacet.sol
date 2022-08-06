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
    /// @dev Hold total variable.
    uint public totalVariable;

    /**
    * @dev Adds two numbers and stores them at the location specified.
    *
    * @param _a First number.
    * @param _b Second number.
    */
    function add(uint256 _a, uint256 _b) public {
        /// @dev Add and store from the library.
        AdditionStorage.add(_a, _b);
    }

    /// @dev Returns the total stored in the diamond.
    function returnTotal() public view returns(uint256) {
        /// @dev Return stored total from library.
        return AdditionStorage.getTotal();
    }

    /// @dev Return hash of add(uint256,uint256) function.
    /// @return bytes4 hash.
    function getAddHash() public pure returns(bytes4) {
        /// @dev Return hash.
        return bytes4(abi.encodeWithSignature("add(uint256,uint256)"));
    }

    /// @dev Return hash of returnTotal() function.
    /// @return bytes4 hash.
    function getReturnTotalHash() public pure returns(bytes4) {
        /// @dev Return hash.
        return bytes4(abi.encodeWithSignature("returnTotal()"));
    }
}