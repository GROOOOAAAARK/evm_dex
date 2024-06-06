// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import "lib/openzeppelin-contracts/contracts/utils/math/Math.sol";

contract BasicLpEthVsToken is ReentrancyGuard {
    IERC20 externalToken;

    struct Position {
        uint256 ethAmount;
        uint256 externalTokenAmount;
    }

    mapping(address => Position) public detailedBalances;

    event OrderApplied(address indexed user, uint256 amount1, string token1, uint256 amount2, string token2);

    constructor(
        address _externalTokenContract
    ) {
        externalToken = IERC20(_externalTokenContract);
    }

    function addLiquidity(uint256 units) payable external nonReentrant() {
        if (msg.value > 0) {
            require(msg.sender.balance >= msg.value, "Not enough balance");

            detailedBalances[msg.sender].ethAmount += msg.value;
        }
        else {
            require(externalToken.balanceOf(msg.sender) >= units, "Not enough external token in user wallet");

            require(externalToken.transferFrom(msg.sender, address(this), units), "Transfer failed");

            detailedBalances[msg.sender].externalTokenAmount += units;
        }
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

    function totalExternalToken() external view returns (uint256) {
        // Return total external token deposited
        return externalToken.balanceOf(address(this));
    }
}
