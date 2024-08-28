pragma solidity ^0.8.25;

import { Script, console } from "forge-std/Script.sol";
import { BasicLp } from "../src/BasicLp.sol";
import { ERC20 } from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { ERC20_impl } from "../src/ERC20_1.sol";

contract BasicLpScript is Script {
    function setUp() public {}

    function run() external {
        vm.startBroadcast();

        // Deploy ERC20 tokens
        ERC20 token0 = new ERC20_impl("Token Uno", "ABC");
        ERC20 token1 = new ERC20_impl("Token Dos", "XYZ");

        // Deploy BasicLp contract
        BasicLp basicLpContract = new BasicLp(address(token0), address(token1));

        vm.stopBroadcast();
    }
}
