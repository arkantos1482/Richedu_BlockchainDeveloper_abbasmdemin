pragma solidity ^0.8;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract NedToken is ERC20 {
    
 constructor() ERC20("Nedward", "NED") {
        _mint(address(this), 100 * 10 ** decimals());
    }
}
