// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title MagicContract: A basic ERC-20 token contract
/// @author https://github.com/Merlin2100
/// @dev This contract implements the ERC-20 standard for a basic token functionality.
contract MagicContract {
    /// @dev The name of the token.
    string private tokenName;

    /// @dev The symbol of the token.
    string private tokenSymbol;

    /// @dev The total supply of the token.
    uint256 private totalSupply;

    /// @dev A private mapping that assigns the balance of each account.
    mapping(address => uint256) private balances;

    /// @dev A public mapping that allows each account to grant a certain amount of tokens to another account.
    mapping(address => mapping(address => uint256)) public allowances;

    /// @notice An event emitted when tokens are transferred.
    /// @param from The address tokens are transferred from.
    /// @param to The address tokens are transferred to.
    /// @param value The amount of tokens transferred.
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    /// @notice An event emitted when approval is granted for spending tokens.
    /// @param owner The address granting approval for spending tokens.
    /// @param spender The address allowed to spend tokens.
    /// @param amount The amount of tokens approved for spending.
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    /// @dev Constructor to initialize the token with a name, symbol, and total supply.
    /// @param _tokenName The name of the token.
    /// @param _tokenSymbol The symbol of the token.
    /// @param _totalSupply The total supply of the token.
    constructor(         
        string memory _tokenName,
        string memory _tokenSymbol,
        uint256 _totalSupply
    )  {
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        totalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    /// @dev Get the name of the token.
    /// @return The name of the token.
    function getTokenName() public view  returns (string memory)  {
        return tokenName;
    }

    /// @dev Get the symbol of the token.
    /// @return The symbol of the token.
    function getTokenSymbol() public view  returns (string memory)  {
        return tokenSymbol;
    }

    /// @dev Get the total supply of the token.
    /// @return The total supply of the token.
    function getTotalSupply() public view  returns (uint256)  {
        return totalSupply;
    }

    /// @dev Get the balance of the specified owner.
    /// @param _owner The address of the owner.
    /// @return The balance of the specified owner.
    function balanceOf(address _owner) public view returns(uint256) {
        return balances[_owner];
    }

    /// @dev Get the sender's address.
    /// @return The address of the sender.
    function getSender() public view returns(address) {
        return msg.sender;
    }

    /// @dev Transfer tokens from the sender to the specified recipient.
    /// @param recipient The address to which tokens are transferred.
    /// @param amount The amount of tokens to transfer.
    /// @return A boolean indicating whether the transfer was successful or not.
    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(amount <= balances[msg.sender], "You don't have enough tokens to transfer.");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    /// @dev Transfer tokens from a specified address to another address.
    /// @param from The address from which tokens are transferred.
    /// @param to The address to which tokens are transferred.
    /// @param amount The amount of tokens to transfer.
    /// @return A boolean indicating whether the transfer was successful or not.
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(amount <= balances[from], "You don't have enough tokens to transfer.");
        require(allowances[msg.sender][from] >= amount, "Insufficient allowance");
        balances[from] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    /// @dev Approve the specified spender to spend a certain amount of tokens on behalf of the owner.
    /// @param spender The address to which spending approval is granted.
    /// @param amount The amount of tokens the spender is allowed to spend.
    /// @return A boolean indicating whether the approval was successful or not.
    function approve(address spender, uint256 amount) public returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
}

