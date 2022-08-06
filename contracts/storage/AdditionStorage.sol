// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.14;

/**
* @title Addition Storage.
* @author Anthony (fps) https://github.com/0xfps.
* @dev  Simple addition storage library.
*       WHY DO WE USE A LIBRARY FOR STORAGE?
*       Personally, I think that using libraries with
*       internal functions gives us that opportunity
*       to interact with the library imported when 
*       the facet is imported.
*
*       As the library functions are internal, they are 
*       added to the bytecode of the Diamond contract
*       hence the library's `myStorage()` can share the
*       same storage with the Diamond, hence storages
*       can be easily read and modified.
*
*       Because, if we used a contract, we cannot explicitly
*       interact with it, unless we initialize a new contract
*       which makes things difficult.
*/
library AdditionStorage {
    /// @dev Location to read from.
    bytes32 constant LOCATION = keccak256(abi.encodePacked("addition.storage"));

    /// @dev Storage struct.
    struct Numbers {
        uint256 a;
        uint256 b;
        uint256 total;
    }

    /// @dev    Returns assigns the Numbers struct to a location and returns
    ///         the struct at that location.
    /// @return nm Numbers struct at location.
    function myStorage() private pure returns(Numbers storage nm) {
        /// @dev Move LOCATION to storage.
        bytes32 location = LOCATION;

        // Assembly starts here.
        assembly {
            /// @dev Load nm from slot `location`.
            nm.slot := location
        }
    }

    /**
    * @dev Adds two numbers and stores them at the location specified.
    *
    * @param _a First number.
    * @param _b Second number.
    */
    function add(uint256 _a, uint256 _b) external {
        /// @dev Load Numbers struct at specified storage location/slot.
        Numbers storage nm = myStorage();
        /// @dev Assign _a to a at slot.
        nm.a = _a;
        /// @dev Assign _b to b at slot.
        nm.b = _b;
        /// @dev Calculate total and store at _total at slot.
        nm.total = _a + _b;
    }

    /**
    * @dev Returns the total saved to slot.
    *
    * @return uint256
    */
    function getTotal() external view returns(uint256) {
        /// @dev Load Numbers struct at specified storage location/slot.
        Numbers storage nm = myStorage();
        /// @dev Return total.
        return nm.total;
    }
}