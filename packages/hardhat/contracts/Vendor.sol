pragma solidity >=0.6.0 <0.7.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable{

  YourToken yourToken;
  uint256 public constant tokensPerEth = 100;
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);


  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }


  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    require(msg.value > 0, "Need to send ETH to buy tokens");

    address buyer = msg.sender;
    uint256 amountOfETH = msg.value;
    uint256 amountOfTokens = msg.value * tokensPerEth;
    uint256 vendorBalance = yourToken.balanceOf(address(this));
    //require(vendorBalance >= amountOfTokens, "Vendor does not have enough tokens");

    (bool sent) = yourToken.transfer(buyer, amountOfTokens);
    require(sent, "Failed to transfer token to user");

    emit BuyTokens(buyer, amountOfETH, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw(uint256 withdrawAmount) public onlyOwner {
    payable(msg.sender).transfer(withdrawAmount);
  }


  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 amountOfTokens) public {
    require(amountOfTokens <= yourToken.balanceOf(msg.sender), "You don't have enough tokens");
    uint256 amountOfETH = amountOfTokens / tokensPerEth;
    require(amountOfETH <= address(this).balance, "Not enough ETH in contract");
    yourToken.transferFrom(msg.sender, address(this), amountOfTokens);
    payable(msg.sender).transfer(amountOfETH);
  }


}
