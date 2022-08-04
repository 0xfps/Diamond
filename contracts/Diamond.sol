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
    mapping(bytes4 => address) private selectorToFacetMap;

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
    function addFunctionBySelector(address _facet, bytes4 _selector) public {
        /// @dev Require _facet is not a zero address.
        require(_facet != address(0), "Error: Invalid Facet Address.");
        /// @dev Require _seletor isn't already owned by _facet.
        require(
            !selectorExists(_selector), 
            "Error: Selector Already Exists."
        );
        /// @dev Add to selector to Facet map.
        selectorToFacetMap[_selector] = _facet;
        /// @dev Emit {AddNewFacetSelector} event.
        emit AddNewFacetSelector(_facet, _selector);
    }

    /**
    * @dev  Adds a function string `_func` and its address `_facet`
    *       to the Facet mapping.
    *
    * @param _facet Facet address where the `_selector` is located.
    * @param _func  Function name to be added.
    */
    function addFunctionByString(address _facet, string memory _func) public {
        /// @dev Get Function Selector.
        bytes4 _selector = bytes4(abi.encodeWithSignature(_func));
        /// @deb Add function selector.
        addFunctionBySelector(_facet, _selector);
    }

    /**
    * @dev  Removes a function selector `_selector` and its address `_facet`
    *       from the Facet mapping.
    *       Emits the {RemoveFacetSelector} event.
    *       This function will run on the condition that:
    *       - The `_selector` exists and owned by the `_facet` address.
    *       - The `_facet` address is vald.
    *
    * @param _facet     Facet address where the `_selector` is located.
    * @param _selector  Selector of function to be called.
    */
    function removeFunctionBySelector(address _facet, bytes4 _selector) public {
        /// @dev Require _facet is not a zero address.
        require(_facet != address(0), "Error: Invalid Facet Address.");
        /// @dev Require _seletor isn't already owned by _facet.
        require(
            selectorExists(_selector), 
            "Error: Selector Doesn't Exist."
        );
        /// @dev Add to selector to Facet map.
        delete selectorToFacetMap[_selector];
        /// @dev Emit {RemoveNewFacetSelector} event.
        emit RemoveFacetSelector(_facet, _selector);
    }

    /**
    * @dev  Adds a function string `_func` and its address `_facet`
    *       to the Facet mapping.
    *
    * @param _facet Facet address where the `_selector` is located.
    * @param _func  Function name to be added.
    */
    function removeFunctionByString(address _facet, string memory _func) public {
        /// @dev Get Function Selector.
        bytes4 _selector = bytes4(abi.encodeWithSignature(_func));
        /// @deb Remove function selector.
        removeFunctionBySelector(_facet, _selector);
    }

    /**
    * @dev Adds using the Addition Facet.
    *
    * @param _a First number.
    * @param _b Second number.
    */
    function add(uint256 _a, uint256 _b) public{
        bytes4 _s = bytes4(abi.encodeWithSignature("add(uint256,uint256)"));
        require(selectorExists(_s), "Inexistent Selector.");
        (bool sent, bytes memory data) = selectorToFacetMap[_s].delegatecall(
            abi.encodeWithSelector(
                _s,
                _a,
                _b
            )
        );
        require(sent, "Not Sent.");
    }

    /**
    * @dev Returns true if the `_selector` exists and is owned by `_facet`.
    *
    * @param _selector  Selector of function to be called.
    *
    * @return exists True or False, depending.
    */
    function selectorExists(bytes4 _selector)
    private 
    view 
    returns(bool exists) 
    {
        /// @dev Return true if the _selector is already owned by _facet.
        exists = selectorToFacetMap[_selector] != address(0);
    }
}