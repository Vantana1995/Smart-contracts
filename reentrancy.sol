// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// Nat spec documentation was created with help of Claude.ai Sonnet 4.5
/// @title Reentrancy Guard using Transient Storage
/// @author Ivan Zemko
/// @notice This contract demonstrates reentrancy protection using EIP-1153 transient storage opcodes
/// @dev Uses TSTORE/TLOAD for gas-efficient reentrancy protection. Transient storage automatically clears after transaction completion.

contract ReentrancyDefender {
    /// @notice Mapping of user addresses to their ETH balances
    mapping(address => uint256) public balances;

    /// @notice Prevents reentrancy attacks using transient storage
    /// @dev Uses transient storage slot 0x00 as a lock flag. Much cheaper than SSTORE/SLOAD (100 gas vs 2100+ gas)
    modifier lock() {
        assembly {
            // Check if already locked (tload returns non-zero if locked)
            if iszero(eq(tload(0x00), 0)) {
                revert(0x00, 0x00)
            }
            // Set lock
            tstore(0x00, 1)
        }
        _;
        assembly {
            // Clear lock after function execution because there can be a few function call in one transaction
            tstore(0x00, 0)
        }
    }

    /// @notice Allows users to deposit ETH into the contract
    /// @dev Increases the caller's balance by the sent value
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    /// @notice Allows users to withdraw their entire balance
    /// @dev Protected by lock modifier to prevent reentrancy attacks
    function withdraw() external lock {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance!");

        // Update balance before external call (Checks-Effects-Interactions pattern)
        balances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed!");
    }

    /// @notice Returns the balance of a specific address
    /// @param account The address to check
    /// @return The balance of the account
    function getBalance(address account) external view returns (uint256) {
        return balances[account];
    }
}
