# Reentrancy Defender

A gas-efficient reentrancy protection implementation using EIP-1153 transient storage opcodes.

## Overview

ReentrancyDefender demonstrates how to protect smart contracts from reentrancy attacks using transient storage (TSTORE/TLOAD), which is significantly more gas-efficient than traditional storage-based locks (SSTORE/SLOAD).

## Key Features

- **Gas Efficient**: Uses transient storage (~100 gas) instead of persistent storage (~2100+ gas)
- **Automatic Cleanup**: Transient storage automatically clears after transaction completion
- **Simple Implementation**: Clean modifier-based approach
- **Production Ready**: Follows Checks-Effects-Interactions pattern

## How It Works

### Transient Storage Lock

The contract uses a `lock()` modifier that leverages EIP-1153 transient storage:

```solidity
modifier lock() {
    assembly {
        // Check if already locked
        if iszero(eq(tload(0x00), 0)) {
            revert(0x00, 0x00)
        }
        // Set lock
        tstore(0x00, 1)
    }
    _;
    assembly {
        // Clear lock after function execution
        tstore(0x00, 0)
    }
}
```

**Gas Savings:**

- Traditional SSTORE/SLOAD: 2100+ gas per operation
- Transient TSTORE/TLOAD: ~100 gas per operation
- **Savings: ~95% reduction in gas costs for reentrancy protection**

## Functions

### `deposit()`

Allows users to deposit ETH into the contract.

```solidity
function deposit() external payable
```

### `withdraw()`

Allows users to withdraw their entire balance. Protected by the `lock` modifier.

```solidity
function withdraw() external lock
```

**Security Features:**

- Reentrancy protection via transient storage lock
- Checks-Effects-Interactions pattern (balance updated before external call)
- Proper error handling

### `getBalance(address account)`

Returns the balance of a specific address.

```solidity
function getBalance(address account) external view returns (uint256)
```

## Usage Example

```solidity
// Deploy the contract
ReentrancyDefender defender = new ReentrancyDefender();

// Deposit ETH
defender.deposit{value: 1 ether}();

// Check balance
uint256 balance = defender.getBalance(msg.sender);

// Withdraw
defender.withdraw();
```

## Reentrancy Attack Prevention

This contract prevents the classic reentrancy attack pattern:

1. Attacker calls `withdraw()`
2. Contract sends ETH to attacker
3. Attacker's fallback function calls `withdraw()` again
4. **BLOCKED**: The `lock` modifier detects the reentrant call and reverts

Traditional vulnerable pattern:

```solidity
// ❌ VULNERABLE
function withdraw() external {
    uint256 amount = balances[msg.sender];
    (bool success, ) = msg.sender.call{value: amount}("");
    balances[msg.sender] = 0; // Too late!
}
```

Protected pattern:

```solidity
// ✅ PROTECTED
function withdraw() external lock {
    uint256 amount = balances[msg.sender];
    balances[msg.sender] = 0; // Update first
    (bool success, ) = msg.sender.call{value: amount}("");
}
```

## EIP-1153: Transient Storage

Transient storage was introduced in EIP-1153 and provides:

- **Temporary Storage**: Data exists only for the duration of the transaction
- **Automatic Cleanup**: No manual cleanup required
- **Gas Efficiency**: Much cheaper than persistent storage
- **Perfect for Locks**: Ideal for temporary flags like reentrancy guards

## Requirements

- **Solidity**: 0.8.30 or higher (for transient storage support)
- **EVM**: Cancun upgrade or later (EIP-1153 support)
- **Networks**: Ethereum mainnet (post-Cancun), Arbitrum, Optimism, and other L2s with EIP-1153 support

## Comparison: Traditional vs Transient Storage

| Feature                | Traditional (SSTORE/SLOAD) | Transient (TSTORE/TLOAD) |
| ---------------------- | -------------------------- | ------------------------ |
| Gas Cost               | ~2100+ gas                 | ~100 gas                 |
| Cleanup                | Manual required            | Automatic                |
| Cross-call Persistence | Yes                        | Yes (within transaction) |
| After Transaction      | Persists                   | Automatically cleared    |
| Use Case               | Permanent data             | Temporary flags/locks    |

## Security Considerations

✅ **Double Protection**: Uses both transient storage lock AND Checks-Effects-Interactions pattern  
✅ **Multi-call Safe**: Lock clears after each protected function, allowing multiple calls in one transaction  
✅ **Gas Efficient**: Minimal overhead for security  
⚠️ **Network Compatibility**: Requires EIP-1153 support (Cancun upgrade)

## Author

Ivan Zemko

## License

MIT License

## Learn More

- [EIP-1153: Transient Storage Opcodes](https://eips.ethereum.org/EIPS/eip-1153)
- [Reentrancy Attack Explained](https://owasp.org/www-project-smart-contract-top-10/2025/en/src/SC05-reentrancy-attacks.html)
- [Checks-Effects-Interactions Pattern](https://docs.soliditylang.org/en/latest/security-considerations.html#use-the-checks-effects-interactions-pattern)
