# Introducing Proof of Contract Stake (PoCS)

First Developer-Centric Contract Staking Module for Substrate Chains.

**Author**: [jobyreuben](https://github.com/jobyreuben)

- [Introducing Proof of Contract Stake (PoCS)](#introducing-proof-of-contract-stake-pocs)
- [Ownable Scarcity as Stake](#ownable-scarcity-as-stake)
- [Research \& Simulations](#research--simulations)
    - [PoCS Simulations (Ethereum PoCS)](#pocs-simulations-ethereum-pocs)
- [First Implementation](#first-implementation)
  - [Substrate-PoCS](#substrate-pocs)
  - [Grant Support - W3F](#grant-support---w3f)
  - [Staking Contracts](#staking-contracts)
    - [Contract Deployment and Bonding](#contract-deployment-and-bonding)
    - [Managing Delegate Information](#managing-delegate-information)
    - [Updating Delegate Information](#updating-delegate-information)
      - [Purging Stake Score](#purging-stake-score)
  - [PoCS x NPoS](#pocs-x-npos)
  - [Running a PoCS Multi-Node](#running-a-pocs-multi-node)
  - [Map Verification ink! contract](#map-verification-ink-contract)
  - [Security Report](#security-report)
  - [Future](#future)

# Ownable Scarcity as Stake

The concept that security or stake equals scarcity in popular consensus models like Proof of Work (PoW) and Proof of Stake (PoS) laid a foundational principle that the limited availability of a resource serves as a deterrent against malicious actors in an open-public network. 

1. **Proof of Work (PoW)**:
   - In PoW, the scarce resource is computational power. Miners compete with each other to find an expected resultant hash by computing to secure their block in the ledger.
   - The concentration of computational power within major organizations and massive increase in difficulty level to secure their blocks makes it economically unfeasible for small time attackers to overpower the network, as they would need an immense amount of computational resources, which are costly to acquire.
   - This scarcity of computational power acts as a barrier against attacks, ensuring the security of the network.

2. **Proof of Stake (PoS)**:
   - PoS relies on validators who are required to lock up a certain amount of cryptocurrency as stake to participate in block validation.
   - The scarce resource in PoS is the cryptocurrency itself, which validators must own and lock up. This requirement makes it economically challenging for malicious actors to accumulate enough stake to attack the network.
   - Yet, PoS introduces a vulnerability when a few minority holds majority concentration of stake which could potentially lead to centralization and security risks.

3. **Proof of Contract Stake (PoCS)**:
   - PoCS introduces a novel approach where the scarce resource for staking is tied to the history of computational units, such as gas units or time, used by individual contracts, owned by contract deployers.
   - This scarcity is not based on accumulating a specific token but rather on the usage history of contracts, which makes it more resistant to centralization and concentration and allows wider participation.
   - By tying the cost of acquiring the scarce resource to block time and transaction fees, PoCS aims to prevent accumulation and inequality among validators, promoting a more decentralized and secure network.

# Research & Simulations

Research in the context of Proof of Contract Stake (PoCS) provided in the [PoCS Research Page]() involves both theoretical analysis and practical simulations.

During the research phase, the theoretical underpinnings of PoCS and its potential applications is well documented. The conceptual framework of PoCS, its design principles, and its comparative advantages and disadvantages over other consensus mechanisms such as Proof of Work (PoW) and Proof of Stake (PoS) is provided publicly.

Following the research phase, the simulation phase is proceeded, where scripts are employed to simulate the behavior of PoCS in a real-world scenario. This phase involves the collection of relevant data, the development of simulation algorithms, and the execution of simulation experiments. Various simulation techniques are used to verify the theoretical result expectation of PoCS protocol design.

### PoCS Simulations (Ethereum PoCS)

The PoCS simulations on Ethereum's transaction history involve:

1. Analyzing the total network stake supply over time to understand the evolution of Ethereum's PoCS stake distribution.
2. Assessing the stake distribution of specific contracts, like Uniswap, on the Ethereum network running PoCS to evaluate decentralization and security implications.
3. Simulating potential 51% majority stake attacks on Ethereum PoCS to evaluate its resilience against malicious attacks.

These simulations provide empirical evidence supporting the viability and security of implementing PoCS if blockchain networks like Ethereum adopted PoCS as its genesis consensus model, facilitating confident advocacy for its adoption as a robust consensus mechanism.

> **Note:** Simulation results and analysis are based on hypothetical scenarios and assumptions and may not fully reflect uncertain real-world conditions. Additionally, the effectiveness of PoCS may vary depending on specific network parameters and external factors.

# First Implementation

Detailed Implementation of modifications done to `pallet_contracts` & `pallet-staking` are provided in sections [Staking Contracts](#staking-contracts) & [PoCS x NPoS](#pocs-x-npos)

## Substrate-PoCS

Substrate was chosen as our primary platform for implementing PoCS due to several compelling reasons:

1. **WASM Benefits**: Leveraging WASM Runtime and contracts allows for faster execution speeds, lower resource consumption, and broader language support, enhancing the overall performance and scope of PoCS.

2. **Modularity**: Substrate is highly modular, allowing developers to customize and configure custom components according to specific requirements. 

## Grant Support - W3F

We are grateful for the support and funding provided by the Web3 Foundation (W3F) for the development and implementation of PoCS on Substrate.

For detailed information on our grant application for PoCS development on Substrate, please refer to [PoCS Grant Application](). This document outlines our project proposal, objectives, and milestones for successfully executing the PoCS implementation on Substrate.

## Staking Contracts

Staking contracts play a crucial role in the Proof of Contract Stake (PoCS) consensus mechanism. Individuals, Developers or entities stake their contracts to participate in the PoCS-based network's consensus mechanism. Specifically in PoCS-Substrate-Implementation, users can stake contracts via the pallet-contracts module. This module allows contract owners to deploy contracts through popular Substrate contracts UI application.

### Contract Deployment and Bonding

Upon deploying a contract via the pallet-contracts module, the contract is automatically bonded to the contract deployer by default. This default bonding mechanism automatically designates the contract deployer as a nominator and the `stake_score` of the contract as the bond value. Nominator, in this context, act as a delegator who delegate their bond to validators.

### Managing Delegate Information

When a contract is deployed, default delegate information and the contract's scarcity information, including stake score (the individual stake units a contract holds), are stored. However, contract deployer have the flexibility to update the delegate (validator) information associated with the contract.

### Updating Delegate Information

Contract deployer can update the delegate information by constructing an extrinsic and calling the function `update_delegate()`, which is available as a PoCS specific function in contracts pallet. In this extrinsic, the deployer provides the address of the validator to whom they want to bond the contract.

#### Purging Stake Score

Each time the deployer updates the delegate information, the stake score associated with the contract is purged. This purging mechanism ensures that the stake score cannot be reused or accumulated over time, thereby maintaining the integrity and security of the PoCS consensus mechanism.

Through proper management of delegate information and stake scores, stakeholders i.e., contract owners can actively engage in the operation of PoCS-based-Substrate networks.

# PoCS x NPoS

[Nominated Proof of Stake (NPoS)]() is a staking module developed by [Parity Technologies]() where nominators delegate their bonds to validators for an era (epoch) and receive block rewards in return. 

Nominators are participants who hold tokens and wish to participate in the network's staking process. They delegate their bonds (locked tokens) to validators, entrusting them to participate in block production and transaction validation on their behalf.

## Integration of PoCS into NPoS

In PoCS, the stake score of a contract serves as the bond's value. PoCS integrates with NPoS by allowing contracts to bond to validators using the `update_delegate()` function call available in the `pallet-contracts` module. This function enables contract deployers to specify the validator to whom they want to delegate their bonds.

### Stake Score Dynamics

1. **Execution Time as a Scarce Resource**: PoCS considers execution time, measured in substrate's weight based transaction fees, as a scarce resource. The weight of a transaction is calculated based on the anticipated processing time in a fixed hardware environment.

2. **Stake Score per call**: The stake score of a contract is updated for every call made to the contract, reflecting the utilization of execution time as a scarce resource. This dynamic adjustment ensures that contracts with higher execution demands contribute proportionally more to the network's security.

3. **Contract Reputation**: In addition to bond value and execution time, PoCS also incorporates contract reputation into the stake score calculation. Contract reputation, as detailed in the [PoCS research paper](), factors in the historical performance of contracts within the network to analyze its reputation to avoid malicious intents.

This integration leverages the unique properties of both PoCS and NPoS to create a robust and resilient staking ecosystem.

## Running a PoCS Multi-Node

TBD (Milestone 3)

## Map Verification ink! contract

TBD (Milestone 3)

## Security Report

TBD (Milestone 3)

## Future

TBD (Milestone 3)

