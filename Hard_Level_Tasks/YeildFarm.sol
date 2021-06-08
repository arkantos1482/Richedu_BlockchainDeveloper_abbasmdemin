// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "./IUniswap.sol";

contract NedToken is ERC20 {
    constructor() ERC20("Nedward", "NED") {
        _mint(msg.sender, 100 * 10 ** decimals());
    }
}

contract FooToken is ERC20 {
    constructor() ERC20("FooToken", "FOO") {
        _mint(msg.sender, 500 * 10 ** decimals());
    }
}

contract YieldFarm {
  address private constant FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
  address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
//   address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  
  struct Balances {
      uint amountA;
      uint amountB;
      uint liquidity;
  }
  
  mapping (address => Balances) userBalances; 

 function addLiquidity (address _tokenA,address _tokenB,
                        uint256 _amountA,uint256 _amountB) external {
    IERC20(_tokenA).transferFrom(msg.sender, address(this), _amountA);
    IERC20(_tokenB).transferFrom(msg.sender, address(this), _amountB);

    IERC20(_tokenA).approve(ROUTER, _amountA);
    IERC20(_tokenB).approve(ROUTER, _amountB);

    (uint256 amountA, uint256 amountB, uint256 liquidity) =
      IUniswapV2Router(ROUTER).addLiquidity(
        _tokenA,_tokenB,
        _amountA,_amountB,
        1,1,
        address(this),
        block.timestamp
      );
    
    Balances memory b = userBalances[msg.sender];
    userBalances[msg.sender] = Balances(b.amountA+amountA, b.amountB+amountB, b.liquidity+liquidity);
  }
  
  function myLiquidity() public view returns (uint) {
      return userBalances[msg.sender].liquidity;
  }

  function removeLiquidity(address _tokenA, address _tokenB, uint liquidity) external {
    address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);

    IERC20(pair).approve(ROUTER, liquidity);

    (uint256 amountA, uint256 amountB) =
      IUniswapV2Router(ROUTER).removeLiquidity(
        _tokenA,_tokenB,
        liquidity,
        1,1,
        address(this),
        block.timestamp
      );
      
    Balances memory b = userBalances[msg.sender];
    userBalances[msg.sender] = Balances(b.amountA-amountA, b.amountB-amountB, b.liquidity-liquidity);
  }
}

