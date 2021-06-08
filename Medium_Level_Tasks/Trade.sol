// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";


contract NedToken is ERC20 {
    
 constructor() ERC20("Nedward", "NED") {
        _mint(msg.sender, 100 * 10 ** decimals());
    }
}

contract Trade {
    
    NedToken private ned;
    
    constructor() {
        ned = new NedToken();
    }
    
    function getUserTokenBalance() public view returns (uint) {
        return ned.balanceOf(msg.sender);
    }
    
    
    function remainedToken() public view returns (uint) {
        return ned.balanceOf(address(this));
    }

// user needs to approve this contract the amount of token (maybe the code written in front-end)    
    function sellToken(uint amount) public{
        ned.transferFrom(msg.sender,address(this),amount);
        msg.sender.call{value:amount}("");
    }
    
    function buyToken() public payable{
        ned.transfer(msg.sender,msg.value);
    }
}
