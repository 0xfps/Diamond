# Diamond

### EIP-2535

An practical outlook into the Diamond contract structure.

<br/>

For more information on Diamonds and Facets:
- https://eips.ethereum.org/EIPS/eip-2535.
- https://soliditydeveloper.com/eip-2535.
- [Diamond Contract Codebase](https://github.com/mudgen/diamond-2-hardhat).

###
## WHY DO WE USE A LIBRARY FOR DIAMOND STORAGE?
Personally, I think that using libraries with internal functions gives us that opportunity to interact with the library imported when  the facet is imported. 

As the library functions are internal, they are added to the bytecode of the Diamond contract hence the library's `myStorage()` can share the same storage with the Diamond, giving it the ability to write, read and modify a particular storage slot in the Diamond, hence storages can be easily read and modified.

Because, if we used a contract, we cannot explicitly interact with it, unless we initialize a new contract which makes things difficult.


## STEPS

- Deploy `facets/AdditionFacet.sol`.
- Get selectors using `getAddHash` and `getReturnTotalHash`.
- Set the selectors in the `Diamond.sol` using the `addFunctionBySelector` or `addFunctionByString`.
- > Set the `"add(uint256,uint256)"` and `"returnTotal()"`.
- Call the `add` function in the `Diamond.sol`.
- Check the `testTotal` variable.
