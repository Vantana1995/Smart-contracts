# AirDrop Contract

A gas-optimized Solidity smart contract for managing token airdrops (ERC20 and ERC721) with provably fair winner selection.

## Overview

MrPiculeAirDrop is a smart contract that enables trustless airdrop campaigns for both fungible (ERC20) and non-fungible (ERC721) tokens. The contract implements a provably fair randomness mechanism for winner selection and stores participant data on IPFS for transparency and verification.

## Deployment

**Network:** Arbitrum One (Mainnet)  
**Contract Address:** `0xd14ff57ea51555fb0fdab7b462f2e05eadc3177e`

The contract has been deployed and thoroughly tested on Arbitrum One mainnet, ensuring reliability and production-readiness.

## Features

- **Multi-token Support**: Works with both ERC20 and ERC721 tokens
- **Provably Fair Selection**: Uses multiple entropy sources (block data, transaction data, participant hash) for winner selection
- **IPFS Integration**: Stores participant data on IPFS for transparency
- **Gas Optimized**: Written in inline assembly for maximum efficiency
- **Event Emission**: Comprehensive event logging for off-chain tracking
- **Owner-only Controls**: Protected functions ensure only authorized operations

## Contract Architecture

### State Variables

- `owner`: Address of the contract owner
- `airdropCount`: Counter for total airdrops created
- `airdrop`: Mapping of airdrop ID to Airdrop struct

### Airdrop Struct

```solidity
struct Airdrop {
    address token;              // ERC20/ERC721 token address
    address winner;             // Selected winner address
    uint256 amountToReceive;    // Amount for ERC20 or token ID for ERC721
    uint256 id;                 // Token ID (0 for ERC20)
    bool isCompleted;           // Completion status
    string airdropAddress;      // X/Twitter page or campaign identifier
    string ipfsData;            // IPFS hash with participant data
}
```

## Functions

### `createAirdrop`

Creates a new airdrop campaign.

```solidity
function createAirdrop(
    address _ercToken,
    uint256 _amountToReceive,
    uint256 _id,
    string memory _airdropAddress
) public
```

**Parameters:**
- `_ercToken`: Address of the ERC20 or ERC721 token
- `_amountToReceive`: Amount of tokens (for ERC20) or 0 (for ERC721)
- `_id`: Token ID (for ERC721) or 0 (for ERC20)
- `_airdropAddress`: Campaign identifier (e.g., X/Twitter page)

**Access Control:** Owner only

**Process:**
1. Validates caller is contract owner
2. Increments airdrop counter
3. Stores airdrop details in storage
4. Transfers tokens from caller to contract via `transferFrom`
5. Emits `AirdropCreated` event

**Events Emitted:**
```solidity
event AirdropCreated(
    uint256 indexed airdropId,
    address indexed token,
    uint256 id,
    uint256 amount,
    string xPage
)
```

### `getWinner`

Selects a winner from the participant list and distributes tokens.

```solidity
function getWinner(
    address[] calldata participants,
    uint256 numOfAirdrop,
    string memory _ipfsData
) public
```

**Parameters:**
- `participants`: Array of participant addresses
- `numOfAirdrop`: ID of the airdrop campaign
- `_ipfsData`: IPFS hash containing participant data

**Access Control:** Owner only

**Randomness Sources:**
- Hash of all participant addresses
- Airdrop ID
- Token address
- Amount to receive
- `block.timestamp`
- `block.prevrandao`
- `block.number`
- `tx.origin`
- `msg.sender`

**Process:**
1. Validates caller is contract owner
2. Generates random number using multiple entropy sources
3. Selects winner: `winnerIndex = randomHash % participantCount`
4. Stores IPFS data hash
5. Marks airdrop as completed
6. Transfers tokens to winner (ERC20: `transfer`, ERC721: `transferFrom`)
7. Emits `WinnerSelected` event

**Events Emitted:**
```solidity
event WinnerSelected(
    uint256 indexed airdropId,
    address indexed winner,
    uint256 participantCount,
    string ipfsData
)
```

## Usage Example

### Creating an ERC20 Airdrop

```solidity
// 1. Approve the contract to spend your tokens
IERC20(tokenAddress).approve(airdropContractAddress, amount);

// 2. Create airdrop
airdropContract.createAirdrop(
    tokenAddress,      // ERC20 token address
    1000 * 10**18,    // Amount (1000 tokens with 18 decimals)
    0,                 // 0 for ERC20
    "https://x.com/campaign"  // Campaign identifier
);
```

### Creating an ERC721 Airdrop

```solidity
// 1. Approve the contract to transfer your NFT
IERC721(nftAddress).approve(airdropContractAddress, tokenId);

// 2. Create airdrop
airdropContract.createAirdrop(
    nftAddress,        // ERC721 token address
    0,                 // 0 for ERC721
    tokenId,           // NFT token ID
    "https://x.com/campaign"  // Campaign identifier
);
```

### Selecting a Winner

```solidity
// Participants collected off-chain and stored on IPFS
address[] memory participants = [
    0x1234...,
    0x5678...,
    // ... more addresses
];

airdropContract.getWinner(
    participants,
    0,  // Airdrop ID
    "QmXYZ..."  // IPFS hash with participant data
);
```

## Frontend Integration

The contract is designed to work with a frontend application that:

1. **Collects Participants**: Gathers participant addresses from social media or other sources
2. **IPFS Upload**: Uploads participant list as JSON to IPFS before winner selection
3. **One-Click UX**: Handles all operations with a single user confirmation
4. **IPFS Fetching**: Retrieves participant data from IPFS and passes it to the contract
5. **Event Monitoring**: Listens for contract events to display results

## Security Considerations

### Randomness

The contract uses multiple on-chain entropy sources for randomness. While this provides basic unpredictability, it's important to note:

- Block data (`prevrandao`, `timestamp`, `number`) can be influenced by miners/validators to some degree
- For high-value airdrops, consider using Chainlink VRF or similar oracle solutions
- The current implementation is suitable for promotional airdrops and community distributions

### Access Control

- Only the contract owner can create airdrops and select winners
- Ensures centralized control over the airdrop process
- Consider implementing multi-sig ownership for production use

### Token Handling

- Contract requires token approval before creating airdrops
- Tokens are held in the contract until winner selection
- Ensure proper token approval flows in your frontend

## Gas Optimization

The contract is written in inline assembly for maximum gas efficiency:

- Direct storage slot manipulation
- Optimized string handling
- Minimal memory allocation
- Efficient event emission

## Error Codes

- `0x82b42900`: Unauthorized - Caller is not the owner
- `0xbf7e4b28`: TransferFailed - Token transfer failed during airdrop creation
- `0x5cb71482`: TransferAtAirdropFailed - Token transfer to winner failed

## Events

### AirdropCreated
Emitted when a new airdrop is created.

### WinnerSelected
Emitted when a winner is selected and tokens are distributed.

## License

MIT License

## Version

Solidity: 0.8.28

## Disclaimer

This contract is provided as-is. Always conduct thorough testing and auditing before deploying to mainnet with real assets.