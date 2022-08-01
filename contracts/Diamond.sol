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
    /// @dev Struct of each individual Facet and their selectors.
    struct Facets {
        /// @dev Facet address.
        address _facetAddress;
        /// @dev Array of selectors in the Facet address.
        bytes4[] _facetSelectors;
    }

    /// @dev Number of selectors registered in the Diamond.
    uint256 private selectorCount;
    /// @dev Array of all function selectors used.
    bytes4[] private selectorArray;
    /// @dev    Create a mapping of function selectors to the
    ///         Facet addresses.
    mapping(bytes4 => address) private selectorToFacetMap;
    /// @dev    Mapping Facet addresses to Facet struct for 
    ///         comprehension and Facet analysis.
    mapping(address => Facets) private facetStruct;

    /// @dev Emitted when a new Facet selector is added.
    event AddNewFacetSelector(
        address indexed _facetAddress, 
        bytes4 indexed _selector
    );
    /// @dev Emitted when a Facet selector is removed or deleted.
    event RemoveFacetSelector(
        address indexed _facetAddress, 
        bytes4 indexed _selector
    );
    /// @dev    In rare cases, this will be emitted when a large number
    ///         of Facet selectors are added.
    event AddArrayOfNewFacetSelectors(
        address indexed _facetAddress, 
        bytes4[] indexed _selector
    );
    /// @dev    Also, in rare cases, this will be emitted when a large 
    ///         number of Facet selectors are removed.
    event RemoveArrayOfNewFacetSelectors(
        address indexed _facetAddress, 
        bytes4[] indexed _selector
    );

    /**
    * @dev  Adds a function selector `_selector` and its address `_facet`
    *       to the Facet mapping.
    *       Emits the {AddNewFacetSelector} event.
    *       This function will run on the condition that:
    *       - The `_selector` doesn't exist and owned by the `_facet` address.
    *       - The `_facet` address is vald.
    *
    * @param _facet     Facet address where the `_selector` is located.
    * @param _selector  Selector of function to be called.
    */
    function addFunction(address _facet, bytes4 _selector) public {
        /// @dev Require _facet is not a zero address.
        require(_facet != address(0), "Error: Invalid Facet Address.");
        /// @dev Require _seletor isn't already owned by _facet.
        require(
            facetSelectorExists(_facet, _selector), 
            "Error: Facet Already Exists."
        );
        /// @dev Add to selector to Facet map.
        selectorToFacetMap[_selector] = _facet;
        /// @dev Add to Facet address struct at Facet.
        facetStruct[_facet]._facetAddress = _facet;
        /// @dev Push the selector to the array at Facet struct.
        facetStruct[_facet]._facetSelectors.push(_selector);
        /// @dev Contiue......
    }

    /**
    * @dev Returns true if the `_selector` exists and is owned by `_facet`.
    *
    * @param _facet     Facet address where the `_selector` is located.
    * @param _selector  Selector of function to be called.
    *
    * @return exists True or False, depending.
    */
    function facetSelectorExists(address _facet, bytes4 _selector)
    private 
    view 
    returns(bool exists) 
    {
        /// @dev Return true if the _selector is already owned by _facet.
        exists = selectorToFacetMap[_selector] == _facet;
    }
}