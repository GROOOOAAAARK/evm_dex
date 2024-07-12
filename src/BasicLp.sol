// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import "lib/openzeppelin-contracts/contracts/utils/math/Math.sol";

contract BasicLp is ReentrancyGuard {
    IERC20 token0;
    IERC20 token1;

    mapping(address => DepositSummary) public detailedBalances;

    struct DepositSummary {
        uint256 token0Amount;
        uint256 token1Amount;
    }

    event OrderApplied(address indexed user, uint256 amount1, string token0, uint256 amount2, string token1);

    constructor(
        address _token0Contract,
        address _token1Contract
    ) {
        token0 = IERC20(_token0Contract);
        token1 = IERC20(_token1Contract);
    }

    function mint(uint256 amount0, uint256 amount1) payable external nonReentrant() {

        require(amount0 > 0, "Token quantity of negative or null...");

        require(amount1 > 0, "Token quantity negative or null...");

        require(token0.balanceOf(msg.sender) >= amount0, "Not enough external token in user wallet");

        require(token0.transferFrom(msg.sender, address(this), amount0), "Transfer failed");

        detailedBalances[msg.sender].token0Amount += amount0;

        require(token1.balanceOf(msg.sender) >= amount1, "Not enough external token in user wallet");

        require(token1.transferFrom(msg.sender, address(this), amount1), "Transfer failed");

        detailedBalances[msg.sender].token1Amount += amount1;

    }

    function exchangeWithEth() payable external nonReentrant {
        // Deposit ETH
        uint ethAmount = msg.value;

        uint256 externalTokenAmountToSend = rateTokenVsEth(ethAmount);

        require(externalToken.balanceOf(address(this)) >= externalTokenAmountToSend, "Not enough external token in contract");

        // Transfer external token to user
        require(externalToken.transferFrom(address(this), msg.sender, externalTokenAmountToSend), "Transfer failed");

        emit OrderApplied(msg.sender, ethAmount, "ETH", externalTokenAmountToSend, externalToken._symbol);
    }

    function exchangeWithToken(uint256 externalTokenAmount) external nonReentrant {
        // Check balance
        require(externalToken.balanceOf(msg.sender) >= externalTokenAmount, "Not enough external token in user wallet");

        // Get Rate
        uint256 ethAmountToSend = Math.tryDiv(rateTokenVsEth(1, externalTokenAmount));

        require(address(this).balance >= ethAmountToSend, "Not enough ETH in contract");

        require(externalToken.transferFrom(msg.sender, address(this), externalTokenAmount), "Transfer failed");

        payable(msg.sender).transfer(ethAmountToSend);
    }

    function rateTokenVsEth(uint256 tokenAmount) private pure returns (uint256) {
        // Return rate of external token to ETH
        // Temp function, will be replaced by oracle
        return tokenAmount.mul(2).div(4);
    }

    function totalEth() external view returns (uint256) {
        // Return total ETH deposited
        return address(this).balance;
    }

    // Return total external token deposited
    function totaltoken0() external view returns (uint256) {
        return token0.balanceOf(address(this));
    }

        // Return total external token deposited
    function totaltoken1() external view returns (uint256) {
        return token1.balanceOf(address(this));
    }
}
