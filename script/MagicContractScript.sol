// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {MagicContract} from "../src/MagicContract.sol";

contract MagicContractTest is Script {
    function setUp() public {}

    function run() external returns (MagicContract) {
        vm.startBroadcast();

        // Example parameters
        string memory tokenName = "MagicCoinToken";
        string memory tokenSymbol = "MCT";
        uint256 totalSupply = 10_000_000;

        // Deploy the MagicContract contract with the specified parameters
        MagicContract magicContract = new MagicContract(
            tokenName,
            tokenSymbol,
            totalSupply
        );

        vm.stopBroadcast();
        return magicContract;
    }
}