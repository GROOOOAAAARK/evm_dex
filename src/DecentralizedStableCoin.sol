// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// Goals:
// 1. Relative stability to the USD => Anchored or Pegged
//   a. Chainlink Price Feeds
//   b. Set a function to exchange ETH & BTC => USD Price
// 2. Stability Mechanism (Minting): Algorithmic (Decentralized)
//   a. People can only mint the stablecoin with enought collateral (coded)
// 3. Collateral: Exogenous (Crypto)
//   a. wEth
//   b. wBtc

import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/*
    @title DecentralizedStableCoin
    @author @grk
    @notice This is a decentralized stablecoin that is pegged to the USD
    @notice Minting: Algorithmic (Decentralized)
    @notice Collateral: Exogenous (Crypto)
    @notice Stability Mechanism: Relative (pegged to the USD)
*/
contract DecentralizedStableCoin is ERC20Burnable, Ownable{
    constructor() ERC20("DecentralizedStableCoin", "DSC") Ownable(msg.sender) {}

}