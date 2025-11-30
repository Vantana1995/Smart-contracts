# Smart Contracts Collection

A collection of production-ready, gas-optimized smart contracts for various blockchain applications. Each contract is thoroughly tested and deployed on mainnet.

## Overview

This repository contains a curated set of Solidity smart contracts, each designed with a focus on gas efficiency, security, and real-world usability. All contracts are written using advanced optimization techniques including inline assembly where appropriate.

## Contracts

### [AirDrop](./airdrop/airdropAssembly.sol/)

A gas-optimized airdrop contract for ERC20 and ERC721 tokens with provably fair winner selection.

- **Network:** Arbitrum One
- **Contract:** `0xd14ff57ea51555fb0fdab7b462f2e05eadc3177e`
- **Features:**
  - Multi-token support (ERC20/ERC721)
  - Provably fair randomness
  - IPFS integration
  - Assembly-optimized for minimal gas costs

[📖 Full Documentation](./airdrop-assembly/README.md)

### [Transient storage for Reentrancy prevention](./reentrancy/reentrancy.sol/)

A gas-efficient Reentrancy protection implementation using EIP-1153 transient storage opcodes
[📖 Full Documentation](./reentrancy/README.md)

---

## Repository Structure

```
.
├── airdrop-assembly/
│   ├── airdropAssembly.sol
│   └── README.md
├── [future-contract-folder]/
│   ├── contract.sol
│   └── README.md
└── README.md (this file)
```

## Development

All contracts in this repository are:

- ✅ Production-tested
- ✅ Gas-optimized
- ✅ Documented with comprehensive READMEs
- ✅ Licensed under MIT

## Contributing

Feel free to explore, use, or contribute to any of the contracts. Each contract folder contains its own detailed documentation and usage examples.

## License

MIT License - see individual contract folders for specific details.

## Contact

For questions or collaborations, feel free to reach out via GitHub issues or connect on [LinkedIn](your-linkedin-url).

---

⭐ If you find these contracts useful, please consider starring the repository!
