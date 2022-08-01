// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.14;

/**
* @title Diamond Contract.
* @author Anthony (fps) https://github.com/0xfps.
* @dev  Inspired by https://eips.ethereum.org/EIPS/eip-2535.
*       This contract seeks to take a practical outlook
*       into the EIP-2535 standard. 
*       Although not implementing the EIP, it simply
*       shows how the Diamond works with Facets.
*       Diamonds are simply contracts that work with external 
*       functions of other contracts using delegatecall and their
*       function signature.
*       The contracts containing these external functions are
*       called Facets.
*
* @notice   Importing a contract makes the importing contract to
*           share Solidity storage slots with the imported
*           contract.
*           So, importing a Facet means, the Facet and this 
*           contract will share the same Solidity storage slots.
*           Hence, some data stored in the Facet [Facets can have
*           their own data, which they can read, modify, delete etc,
*           they are stored in a struct in the Facet, for ease of 
*           access], will be shared with the Diamond in a special 
*           storage, [set and assigned in the Facet using assembly's
*           `struct`.slot = `position`], and we don't want them to 
*           be clobbered when we add a new Facet.
*/
contract Diamond {
    /// @dev Number of selectors registered in the Diamond.
    uint256 private selectorCount;
    /// @dev Array of all function selectors used.
    bytes4[] private selectorArray;
    /// @dev    Create a mapping of function selectors to the
    ///         Facet addresses.
    mapping(bytes4 => address) private facetSelectorMap;
    /// @dev Struct of each individual Facet and their selectors.
    struct Facets {
        address _facetAddress;
        bytes4[] _facetSelectors;
    }
}