# ink-contracts

This directory contains all **Ink! smart contracts** used in the PoCS (Proof-of-Concept Substrate) project. You can build, test, and clean these contracts using the `pocs.sh` script.

Some contracts may include custom Chain Extension from [solo-substrate-chain](../solo-substrate-chain/pallets/contracts/src/chain_extension.rs).

## Setup Instructions
Ensure you have the following prerequisites:

- **Rust** (via `rustup`)
- **cargo-contract** (for Ink! compilation)
- **Protobuf Compiler** (for building the Substrate node)

If these are missing, the `pocs.sh` script will handle the setup automatically.

## Usage Guide

### 1️⃣ Build Contracts

To compile all Ink! contracts and bundle the `.contract` files into the `contracts-bundle/` directory:

```bash
./pocs.sh --build --contracts
```

### 2️⃣ Test Contracts (Unit + E2E)

Run unit tests and perform end-to-end (E2E) tests for all contracts:

```bash
./pocs.sh --test --contracts
```

### 3️⃣ Clean Contracts

Remove all compiled artifacts:

```bash
./pocs.sh --clean --contracts
```

This will:
- Clean the build cache for each contract (`cargo clean`)
- Delete the `contracts-bundle` folder

