#  Developer Guide for PoCS

## Introduction 

This Substrate Node is an adaptation of the substrate-stencil framework, customized to integrate the Proof of Contract Stake (PoCS) protocol. The PoCS protocol introduces a developer-centric consensus mechanism that combines elements of Proof-of-Stake (PoS) and Proof-of-Work (PoW), leveraging smart contract activity as a core component of staking and network security.

The node integrates modified versions of pallet_contracts and pallet_staking, enabling contract staking features while maintaining interoperability with Substrate's existing NPoS-BABE-GRANDPA consensus infrastructure. This approach aligns developer incentives with network security, creating a secure and developer-focused blockchain environment.

The node template also serves as a starting point for experimentation and customization, ensuring compatibility with the Polkadot ecosystem and facilitating cross-chain interoperability through parachains. It is designed to support features like contract-based reputation scoring, contract delegation, validator selection, and reward distribution, forming the foundation for a robust PoCS-enabled blockchain.

### What is PoCS ?

Proof of Contract Stake (PoCS) is an innovative, developer-centric blockchain consensus mechanism designed to place smart contracts at the core of network security and functionality. It introduces a staking system that uses contract gas history to select block producers, integrating elements of both Proof-of-Work (PoW) and Proof-of-Stake (PoS).

Key features of PoCS include:

- **Code-Mining:** Incentivizes developers by aligning their participation with network security, making smart contract creators vital to the consensus process.
- **Stake Scoring:** Considers factors like contract age, reputation, and gas utilization to determine staking power, ensuring fairness and resistance to collusion.
- **Mitigation of 'Nothing at Stake':** Introduces non-fungible, non-transferable staking units, addressing a common weakness in traditional PoS systems.
- **Defense Against Stake Accumulation Attacks:** Implements a time-constrained and patterned stake accumulation process, making attacks costly and easily detectable.

Overall, PoCS ensures a secure, fair, and developer-oriented blockchain environment, creating a new paradigm in consensus design.

### How Contract Staking works ?

Contract Staking integrates the functionalities of pallet-staking and pallet-contracts to enable smart contracts to actively participate in the blockchain consensus mechanism. Below is a detailed summary of how the process works:

![PoCS_working](https://github.com/auguth/dot_org/blob/gh-pages/assets/pocs/images/PoCS_working.png?raw=true)

**Stake Score Calculation:** Developers deploy smart contracts with a `stake_score`, derived from the contract's execution time (refTime) and reputation.

**Validator Nomination:** Developers nominate a validator for their contract using the `update_delegate()` extrinsic. Contracts must meet a minimum reputation (set at 10 during development, adjustable) to nominate a validator.

**Stake Purge on Delegate Change:** Changing a contract's delegated validator resets its stake_score to 0.

**Validator Activation:** Validators require a minimum number of delegators (i.e., bonded contracts) to start validating. The min_delegates threshold is set at 3 during development, adjustable.

This system ensures that only reputable contracts and sufficiently supported validators participate in consensus.

Extended details available in [PoCS-Research Document](https://auguth.org/PRESS/pocs).

### Why PoCS ?

Proof of Contract Stake (PoCS) addresses a critical gap in blockchain technology by introducing a developer-centric consensus mechanism that places smart contracts at the core of network security. While traditional consensus mechanisms like Proof-of-Stake (PoS) and Proof-of-Work (PoW) prioritize validators and miners, PoCS shifts the focus to smart contract creators, aligning their interests with the security and functionality of the network.

Key Benefits of PoCS:

- **Developer Incentivization:** PoCS uses a unique stake scoring system based on contract execution, age, reputation, and gas utilization to reward active developers.
- **Enhanced Security:** By tying consensus to contract activity, PoCS mitigates risks like 'nothing at stake' attacks and stake accumulation through time-constrained mechanisms.
- **Fairness and Decentralization:** PoCS integrates contract activity and validator reputation into staking, creating a fairer environment resistant to collusion attacks.
- **Interoperability and Innovation:** Built on Substrate, PoCS is designed to integrate seamlessly into the Polkadot ecosystem, enabling cross-chain compatibility and a robust developer framework.

PoCS represents a paradigm shift in blockchain consensus, transforming smart contract creators into key stakeholders while fostering a secure, scalable, and inclusive network.

## Project Setup using `pocs.sh`

Ensure your system meets the following requirements:

- Linux, macOS, or Windows (with `winget` or `choco` package managers).
- Bash shell environment.
- `curl`, `cargo`, and `rustup` installed.
- Sufficient disk space for Substrate and Ink! builds.

### Initial Setup

Make sure you are in the root node.
Before using the script, ensure it has execution permissions:

```bash
chmod +x pocs.sh
```

#### Build

To build the PoCS Substrate node in `--release` mode with environment setup:

```bash
./pocs.sh --build --node
```

#### Run

To start the PoCS Substrate node:

```bash
./pocs.sh --run
```

**Use [Polkadot-JS-App](https://polkadot.js.org/apps/) and [Contracts UI](https://contracts-ui.substrate.io/) to interact with the Node. Refer to [Testing Guide.md](/TESTING-GUIDE.md) for extended information.**


### Actions and Targets

Check other action and target flags that are supported and their use.

| Action     | Target      | Description                                |
|------------|-------------|--------------------------------------------|
| `--build`  | `--contracts`| Build all Ink! contracts and bundle them.  |
|            | `--node`    | Build the PoCS Substrate node.             |
| `--test`   | `--contracts`| Run all Ink! contract tests and E2E tests. |
|            | `--node`    | Run tests for the PoCS Substrate node.     |
| `--run`    |             | Start the PoCS Substrate node.             |
| `--clean`  | `--contracts`| Clean all Ink! contract artifacts.         |
|            | `--node`    | Clean Substrate node build and targets |



## Working of PoCS 

The Proof of Contract Stake (PoCS) mechanism innovatively combines smart contract interactions with staking, aligning developer contributions with network security. PoCS operates by integrating key Substrate pallets, namely `pallet_contracts` and `pallet_staking`, and is further extended through a validator contract to manage rewards and validator behavior.

### Pallets Used in PoCS

1. Pallet Contracts

- Handles smart contract interactions, including execution, reputation management, and staking score computation.
- Documentation: [Pallet Contracts Documentation](https://auguth.github.io/pocs/target/doc/pallet_contracts/index.html)

2. Pallet Staking

- Implements staking logic, allowing validators to be selected based on contract stake scores.
- Documentation: [Pallet Staking Documentation](https://auguth.github.io/pocs/target/doc/pallet_staking/)


### Contract Staking (pallet_contracts)

The contract staking mechanism revolves around smart contracts deployed by developers. Each contract is associated with a stake score, determined by the following factors:

- Execution Time: Reflects the computational cost of contract calls.
- Reputation: Based on user interactions, frequency of calls, and gas utilization.

**Key Features of Contract Staking:**

- Contracts with sufficient reputation can nominate validators using the `update_delegate()` extrinsic.
- Stake scores reset when contracts change their delegated validators.
- Validators must meet a minimum threshold of nominating contracts to begin validating.

For implementation details, visit the repository: [Contract Staking (pallet_contracts)](https://shorturl.at/zDocL)

### Validator Reward Contract

#### Overview

The Validator Reward Contract is an integral component of the PoCS system. It is designed to manage the distribution of rewards to validators by leveraging smart contract capabilities provided by ink! and integrating closely with PoCS’s unique staking mechanism. This contract enforces a cooldown period between reward claims to ensure fair and secure reward distribution and lays the groundwork for more sophisticated reward logic based on validator performance and smart contract activity.


#### How to build and test the ink! contracts with `test.sh`

The `test.sh` script automates end-to-end (E2E) testing for Ink! smart contracts integrated with the PoCS node. It validates critical functionalities by deploying contracts and verifying chain extension behaviors.

#### Workflow

1. Starts the PoCS Substrate node in development mode (`--dev`).
2. Uploads and instantiates key Ink! contracts, including:
   - Flipper Contract (dummy testing contract)
   - Update Delegate Contract (for delegating validators)
   - Delegate At Contract (for fetching delegate information)
   - Reputation Contract (for testing contract reputation)
   - Stake Score Contract (for testing stake-related logic)
   - Delegate To Contract (for retrieving delegate targets)
   - Owner Contract (for validating contract ownership)
3. Executes a series of assertions:
   - Ensures successful contract deployments.
   - Validates outputs of critical chain extension calls.
   - Checks dynamic updates such as stake and reputation.
4. Terminates the PoCS node upon completion.

#### Key Assertions

The script performs multiple validation checks:

| Assertion                               | Purpose                                      |
|-----------------------------------------|----------------------------------------------|
| `update_delegate_upload_code_hash`      | Verifies contract upload and code hashing.   |
| `delegate_at_chain_extension_works`     | Ensures delegate retrieval for valid contracts. |
| `reputation_chain_extension_works`      | Confirms reputation increments after contract calls. |
| `stake_score_chain_extension_works`     | Validates stake score updates post-delegation. |
| `delegate_to_chain_extension_works`     | Ensures delegate mapping before and after delegation. |
| `owner_chain_extension_works`           | Validates ownership tracking.                |

#### Running the Tests

Ensure the script has execution permissions:

```bash
chmod +x test.sh
```

Run the test script:

```bash
./test.sh
```

If contract bundles are missing, the script prompts whether to rebuild them using `pocs.sh --build --contracts`.

#### Test Summary

The script provides a test summary:

```bash
Test results: 20 passed; 0 failed; total 20
All tests passed successfully.
```

In case of failures, diagnostic information is displayed for debugging.

#### Workflow Integration

1. **Initial Setup:**
    - Ensure the environment is set up using `pocs.sh`.
2. **Build Contracts and Node:**
    - Use `pocs.sh --build` with appropriate targets.
3. **Run Tests:**
    - Execute `pocs.sh --test --contracts` or `test.sh` directly.
4. **Debug Failures:**
    - Use the logs from `test.sh` for debugging failed assertions.

By integrating these scripts, you maintain a consistent and automated process for testing and validating PoCS features, ensuring accuracy and reliability across deployments.

### Example Workflow

1. **Set Up the Environment:**

```bash
chmod +x pocs.sh test.sh
./pocs.sh --build --node
./pocs.sh --build --contracts
```

2. **Run the PoCS Node:**

```bash
./pocs.sh --run
```

3. **Execute E2E Contract Tests:**

```bash
./pocs.sh --test --contracts
```

4. **Stop the Node and Clean Artifacts:**

```bash
pkill -f pocs  # Stop the PoCS node
./pocs.sh --clean --node
./pocs.sh --clean --contracts
```

This workflow ensures a comprehensive and repeatable process for developing, testing, and maintaining the PoCS ecosystem.

#### Features and Future Extensions

- **Cooldown Mechanism:**
The contract enforces a cooldown period (e.g., requiring at least 10 blocks between successive claims) to prevent abuse and ensure fair reward distribution.

- **Reward Calculation:**
Currently, rewards are fixed. Future improvements can integrate more nuanced calculations that factor in:

    - Contract reputation and activity.
    - Stake and staking score based on smart contract interactions.
    - Dynamic adjustment of the reward amount based on network conditions.

- **Integration with PoCS:**

    - **Validator Selection:** Validators in PoCS are selected based on contract staking and reputation. This reward contract complements that system by providing incentives.
    - **Interoperability:** Built on the Substrate framework, this contract can easily interact with other pallets (like pallet_contracts and pallet_staking) ensuring a robust, cross-chain compatible ecosystem.
    - **Scalability:** The modular design allows developers to extend the reward logic as the PoCS protocol evolves, enabling a more dynamic incentive structure.

- **Developer-Centric Design:**
By integrating smart contract activity into the consensus process, PoCS and this reward contract align developer interests with network security, fostering a more engaged and innovative ecosystem.