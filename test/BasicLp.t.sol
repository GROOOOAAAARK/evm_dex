pragma solidity 0.8.25;

import { Test, console } from "forge-std/Test.sol";
import { BasicLp } from "../src/BasicLp.sol";
import { BasicLpScript } from "../scripts/BasicLp.deploy.sol";

contract BasicLpTest is Test {
    BasicLp private liquidityPool;
    ERC20 private tokenA;
    ERC20 private tokenB;

    function setUp() public {

        BasicLpScript script = new BasicLpScript();

        script.run();

        liquidityPool = BasicLp(script.basicLp);
        tokenA = ERC20(script.tokenA);
        tokenB = ERC20(script.tokenB);

    }
}