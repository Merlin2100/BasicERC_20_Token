// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, StdAssertions, Vm} from "../lib/forge-std/src/Test.sol";
import {MagicContract} from "../src/MagicContract.sol";

/// @title MagicContractTest: A test suite for the MagicContract contract
/// @author https://github.com/Merlin2100
contract MagicContractTest is Test {
    MagicContract public magicContract;
    
    address addr1 = vm.addr(0x1);
    address addr2 = vm.addr(0x2);
    
    string tokenName = "MagicCoinToken";
    string tokenSymbol = "MCT";
    uint256 totalSupply = 10_000_000;

    /// @dev Set up the MagicContract instance before each test.
    function setUp() public {
        magicContract = new MagicContract(
            tokenName,
            tokenSymbol,
            totalSupply
        );
    }

    /// @dev Test the functionality to get the token name.
    function testTokenName() public {
        assertEq(magicContract.getTokenName(), tokenName);
    }

    /// @dev Test the functionality to get the token symbol.
    function testTokenSymbol() public {
        assertEq(magicContract.getTokenSymbol(), tokenSymbol);
    }

    /// @dev Test the functionality to get the total supply of the token.
    function testTotalSupply() public {
        assertEq(magicContract.getTotalSupply(), totalSupply);
    }

    /// @dev Test the balance of the sender.
    function testBalanceOfSender() public view {
        address sender = magicContract.getSender();
        uint256 balance = magicContract.balanceOf(sender);
        assert(balance == totalSupply);
    }

    /// @dev Test the balance of other addresses.
    function testBalanceOf() public view {
        uint256 balance1 = magicContract.balanceOf(addr1);
        assert(balance1 == 0);

        uint256 balance2 = magicContract.balanceOf(addr2);
        assert(balance2 == 0);
    }

    /// @dev Test the transfer of tokens between addresses.
    function testTransfer() public {
        address sender = magicContract.getSender();
        uint256 value = 1_000;

        assertTrue(magicContract.transfer(addr1, value));
        assertEq(magicContract.balanceOf(sender), totalSupply - value);
        assertEq(magicContract.balanceOf(addr1), value);
    }

    /// @dev Test the failure of transfer when there are not enough tokens.
    function testTransferNotEnoughTokens() public {
        vm.expectRevert("You don't have enough tokens to transfer.");
        vm.prank(addr1);
        uint256 value = 250;
        magicContract.transfer(addr2, value);
    }

    /// @dev Test for failure when sender has insufficient balance
    function testFailInsufficientBalanceTransfer() public {
        vm.expectRevert("You don't have enough tokens to transfer.");
        uint insufficientBalance = magicContract.balanceOf(address(this)) + 1;
        magicContract.transfer(addr1, insufficientBalance);
    }

    /// @dev Test the transfer of tokens from one address to another with approval.
    function testTransferFrom() public {
        uint256 value = 500;

        magicContract.transfer(addr1, 1_000);
        uint256 value1before = magicContract.balanceOf(addr1);

        assertTrue(magicContract.approve(addr1, value));
        assertTrue(magicContract.transferFrom(addr1, addr2, value));
        assertEq(magicContract.balanceOf(addr1), value1before - value);
        assertEq(magicContract.balanceOf(addr2), value);
    }

    /// @dev Test the failure of transferFrom when there are not enough tokens.
    function testTransferFromNotEnoughTokens() public {
        uint256 value = 500;
        vm.expectRevert("You don't have enough tokens to transfer.");
        magicContract.transferFrom(addr2, addr1, value);
    }

    /// @dev Test the failure of transferFrom when there is insufficient allowance.
    function testTransferFromInsufficientAllowance() public {
        magicContract.transfer(addr1, 1_000);
        assertTrue(magicContract.approve(addr1, 500));
        vm.expectRevert("Insufficient allowance");
        uint256 value = 750;
        magicContract.transferFrom(addr1, addr2, value);
    }
}
