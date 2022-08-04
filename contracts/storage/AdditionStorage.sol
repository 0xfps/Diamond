// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.14;

/**
* @title Addition Storage.
* @author Anthony (fps) https://github.com/0xfps.
* @dev Simple addition storage library.
*
*/
library AdditionStorage {
    /// @dev Location to read from.
    bytes32 constant LOCATION = keccak256(abi.encodePacked("addition.storage"));

    struct Numbers {
        uint256 a;
        uint256 b;
        uint256[] c;
        uint256 total;
    }

    function myStorage() private pure returns(Numbers storage nm) {
        bytes32 location = LOCATION;

        assembly {
            nm.slot := location
        }
    }

    function add(uint256 _a, uint256 _b) external returns(uint256) {
        Numbers storage nm = myStorage();
        nm.a = _a;
        nm.b = _b;
        nm.total = _a + _b;
        return nm.total;
    }
}