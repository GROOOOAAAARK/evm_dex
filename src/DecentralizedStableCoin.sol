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
