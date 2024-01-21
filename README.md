# Proof of Contract Stake (W3F Grant Project)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![Substrate version](https://img.shields.io/badge/Substrate-2.0.0-brightgreen?logo=Parity%20Substrate)](https://substrate.dev/) ![Cargo doc](https://github.com/auguth/pocs/actions/workflows/cargodoc.yml/badge.svg?branch=master) ![Build & Test](https://github.com/auguth/pocs/actions/workflows/rust.yml/badge.svg?branch=master)  

## Abstract

Proof of Contract Stake (PoCS) is a staking system utilizing contract gas history introducing **code-mining** by incentivizing developers to secure the network. Contracts’ stake scores depend on age, reputation, and gas use, deterring collusion attacks. Further information on PoCS Protocol Design are detailed in the [PoCS Research Page](https://jobyreuben.in/JOURNALS/pocs)

## Implementation

This [Substrate](https://substrate.io) Node is an adaptation of the [substrate-stencil](https://github.com/kaichaosun/substrate-stencil) to integrate PoCS protocol, which includes modified [pallet_contracts](#contract-staking-pallet_contracts) and [pallet_staking](#nominated-proof-of-contract-stake-npocs) that supports Contract Staking Feature interoperable with current Substrate **NPoS-BABE-GRANDPA** public node infrastructure. 

## Contract Staking (`pallet_contracts`)

[Crate Documentation](https://auguth.github.io/pocs/target/doc/pallet_contracts/index.html)

### Gas Stake Info

[Crate Documentation for gasstakeinfo.rs](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/index.html)

The primary objective of the initial preparation phase in the PoCS involves incorporating PoCS-related features into [pallet_contracts](https://docs.rs/pallet-contracts/latest/pallet_contracts/). These features encompass reputation values, the designated delegate for the contract, and the stake score value.

A newly introduced [gasstakeinfo.rs](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/index.html) file within the pallet contract accommodates two key structs: `AccountStakeinfo` and `ContractScarcityinfo`.

- **AccountStakeinfo:**

  [Crate Documentation for AccountStakeInfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.AccountStakeinfo.html)

  This struct retains delegate information, including the address of the contract owner, the contract address, and the address to which the stake score is delegated.

- **ContractScarcityinfo:**

  [Crate Documentation for ContractScarcityInfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.ContractScarcityInfo.html)

  This struct manages stake score-related details, such as the stake score itself, the contract's reputation, and the last block height at which the stake score was updated.

Integration with `pallet-contracts` involves the addition of two essential maps:

- **AccountStakeinfoMap:**
  
  [Crate Documentation for AccountStakeinfoMap](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/type.AccountStakeinfoMap.html)

  Utilized to map the contract address to its corresponding `AccountStakeinfo` object.

- **ContractStakeinfoMap:**

  [Crate Documentation for AccountStakeinfoMap](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/type.ContractStakeinfoMap.html)

  Employed to map the contract address to its associated `ContractScarcityinfo` object.

### Edited Functions in `pallet-contracts`

1. **`instantiate_with_code()` Function:**

   [Crate Documentation for instantiate_with_code()](https://silvernberry.github.io/pocs-forked/target/doc/pallet_contracts/pallet/struct.Pallet.html#method.instantiate_with_code)

   This function facilitates the deployment of contracts to the chain for PoCS. The modification ensures that when a contract is deployed, it is added to both maps with initial default values for `AccountStakeinfo` and `ContractScarcityinfo`.

   Default values upon initial contract deployment are as follows:

   - **AccountStakeinfo:**
     - `Owner`: Address of the contract deployer.
     - `Delegate_to`: By default, set to the owner.
     - `Delegate_at`: Current block height at the contract deployment.

   - **ContractScarcityinfo:**
     - `Reputation`: Initialized to 1 by default.
     - `Recent_blockheight`: Current block height at contract deployment.

2. **`update_delegate()` Function:**

   [Crate Documentation for update_delegate()](https://silvernberry.github.io/pocs-forked/target/doc/pallet_contracts/pallet/struct.Pallet.html#method.update_delegate)

   This PoCS-specific function is dedicated to updating the delegate of a contract. It resets `ContractScarcityinfo` to default values. Only the contract owner can modify the delegate, and the `Delegate_to` information in `AccountStakeinfo` is updated accordingly.

3. **`run` in `exe.rs` Function:**

   This function is modified to check the address of the called contract and updates its `ContractScarcityinfo` with new values once the contract is executed through the `run` function. Specifically, the reputation is increased by 1, and the recent block height is set to the current block height when the contract was called.

   [Refer to Code](https://github.com/auguth/pocs/blob/d5ddfea4c992bab36832d1bf0aad7afaa2cb9a7b/pallets/contracts/src/exec.rs#L928)

### Tight Coupling Integration of Pallets
In preparation for the integration of `pallet_contracts` and `pallet_staking` in the PoCS protocol, tight coupling has been established between the two pallets. This decision was made due to the interdependence of both pallets, as they function collaboratively within the PoCS protocol.

To achieve this integration, the following steps were taken:

1. **Pallet-Staking Dependency:**
   - `pallet-staking` has been added to the list of dependencies for `pallet_contracts`.

2. **Configuration Inheritance:**
   - The `Config` of `pallet_staking` is inherited in `pallet_contracts`. This allows seamless communication and coordination between the two pallets.

3. **Type Name Changes:**
   - To prevent potential errors arising from differing types of `Currency` and `WeightInfo` in both pallets, the trite names have been modified throughout `pallet_contracts`. The changes made are as follows:
     - `Currency` is renamed to `ContractCurrency`.
     - `WeightInfo` is renamed to `ContractsWeightInfo`.

   For a detailed reference, please visit: [GitHub Pull Request #10](https://github.com/auguth/pocs/pull/10/commits/b19898ed7ea1d22027b5abbdae3d2681d96e0dd1)

### Testing
To test the functionality of added mappings and functions, 4 tests have been added to `test.rs`
1. `contract_stake_event` - Tests the ContractStakeInfo mapping has been updated and the emitted event reflects correct values.
2. `account_stake_event` - Tests the AccountStakeInfo mapping has been updated and the emitted event reflects correct values.
3. `update_delegate_invalid_owner` - Test to check the update_delegate function for a contract does not succeed if not called by the contract owner.
4. `update_delegate_valid_owner` - Test to check that update_delegate when called by owner updates the ContractStakeInfo and AccountStakeInfo and emitted events reflect correct values.

[Test Code]()

Additionally for successful test execution, the following pallets have been implemented in the test environment:

1. `pallet_staking`
2. `pallet_sessions`

For additional details and code references, please review the changes made in the test environment by visiting: [GitHub Pull Request #11](https://github.com/auguth/pocs/pull/11/commits/5787cd104f2aed59c0fd0a049c32e56a050d5557)

## Nominated Proof of Contract Stake (NPoCS - `pallet_staking`)
TBD (Milestone 2)

## BABE Interoperability
TBD (Milestone 2)

## Reward Verification via Chain Extensions
TBD (Milestone 3)

## Running a PoCS Node
TBD (Milestone 3)

## PoCS Alpha Testing
TBD (Milestone 3)

## Future Goals
TBD (Milestone 3)

## Acknowledgment

Sincere Thanks to the [Web3 Foundation](https://web3.foundation) for their vital grant support, enabling the progress of PoCS Substrate Implementation project. For project application details, visit the [PoCS W3F Grant Application](https://grants.web3.foundation/applications/PoCS)
