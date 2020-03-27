pragma solidity ^0.5.0;

// Buys and sells tokens for a fixed price!

import 'openzeppelin-solidity/contracts/token/ERC20/IERC20.sol';
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';

contract FixedPriceTrader {

    using SafeMath for uint256;

    IERC20 public token;
    uint256 public tokenWeiPrice;

    constructor(address _token, uint256 _tokenWeiPrice) public payable {
    	token = IERC20(_token);
    	tokenWeiPrice = _tokenWeiPrice;
    }

    function buy() public payable {

    	require(msg.value % tokenWeiPrice == 0, "Only exact multiple of token price is accepted.");

    	uint256 numTokens = msg.value.div(tokenWeiPrice);

    	require(numTokens > 0, "Amount of Ether sent is too small.");
    	require(token.transfer(address(this), numTokens));
    }

    function sell(uint256 numTokens) public {
    	require(token.transferFrom(msg.sender, address(this), numTokens));
    	msg.sender.transfer(tokenWeiPrice.mul(numTokens));
    }

    function () external payable {
    }

}