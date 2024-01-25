# Proof of Contract Stake (W3F Grant Project)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![Substrate version](https://img.shields.io/badge/Substrate-2.0.0-brightgreen?logo=Parity%20Substrate)](https://substrate.dev/) ![Cargo doc](https://github.com/auguth/pocs/actions/workflows/cargodoc.yml/badge.svg?branch=master) ![Build & Test](https://github.com/auguth/pocs/actions/workflows/rust.yml/badge.svg?branch=master)

## Abstract

Proof of Contract Stake (PoCS) is a staking system utilizing contract gas history introducing **code-mining** by incentivizing developers to secure the network. Contracts’ stake scores depend on age, reputation, and gas use, deterring collusion attacks. Further information on PoCS Protocol Design are detailed in the [PoCS Research Page](https://jobyreuben.in/JOURNALS/pocs)

## Substrate Implementation

This [Substrate](https://substrate.io) Node is an adaptation of the [substrate-stencil](https://github.com/kaichaosun/substrate-stencil) to integrate PoCS protocol, which includes modified [pallet_contracts](https://auguth.github.io/pocs/target/doc/pallet_contracts/index.html) and [pallet_staking](#nominated-proof-of-contract-stake-npocs---pallet_staking) that supports Contract Staking Feature interoperable with current Substrate **NPoS-BABE-GRANDPA** public node infrastructure. 

## Contract Staking (`pallet_contracts`)

### Gas Stake Info

The primary objective of the initial preparation phase in the PoCS involves incorporating PoCS-related features into [pallet_contracts](https://docs.rs/pallet-contracts/latest/pallet_contracts/). These features encompass reputation values, the designated delegate for the contract, and the stake score value.

A newly introduced [gasstakeinfo.rs](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/index.html) file within the pallet contract accommodates two key structs: `AccountStakeinfo` and `ContractScarcityinfo`.

- [AccountStakeinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.AccountStakeinfo.html) : This struct retains delegate information, including the address of the contract owner, the contract address, and the address to which the stake score is delegated.

- [ContractScarcityinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.ContractScarcityInfo.html) : This struct manages stake score-related details, such as the stake score itself, the contract's reputation, and the last block height at which the stake score was updated.

Integration with `pallet-contracts` involves the addition of two essential maps:

- [AccountStakeinfoMap](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/type.AccountStakeinfoMap.html) : Utilized to map the contract address to its corresponding `AccountStakeinfo` object.

- [ContractStakeinfoMap](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/type.ContractStakeinfoMap.html) : Employed to map the contract address to its associated `ContractScarcityinfo` object.

### Modified Functions in `pallet-contracts`

1. [instantiate_with_code()](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/struct.Pallet.html#method.instantiate_with_code) Function:

   This function facilitates the deployment of contracts to the chain for PoCS. The modification ensures that when a contract is deployed, it is added to both maps with initial default values for `AccountStakeinfo` and `ContractScarcityinfo`.

   Default values upon initial contract deployment are as follows:

   - **AccountStakeinfo:**
     - `Owner`: Account address of the contract deployer.
     - `Delegate_to`: By default, set to the `owner`.
     - `Delegate_at`: Current block height at the contract deployment.

   - **ContractScarcityinfo:**
     - `Reputation`: Initialized to 1 by default.
     - `Recent_blockheight`: Current block height at contract deployment.
     - `Stake_score` : 0

2. [update_delegate()](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/struct.Pallet.html#method.update_delegate) Function:

   This PoCS-specific function is dedicated to updating the delegate of a contract. It resets `ContractScarcityinfo` to default values. Only the contract owner can modify the delegate, and the `Delegate_to` information in `AccountStakeinfo` is updated accordingly.

3. `run()` Function in [exe.rs](https://github.com/auguth/pocs/blob/master/pallets/contracts/src/exec.rs):

   This function is modified to check the address of the called contract and updates its `ContractScarcityinfo` with new values once the contract is executed through the `run` function. Specifically, the reputation is increased by 1, and the recent block height is set to the current block height when the contract was called.

### Tight Coupling Integration of Pallets

In preparation for the integration of `pallet_contracts` and `pallet_staking` in the PoCS protocol, tight coupling has been established between the two pallets. This decision was made due to the interdependence of both pallets, as they function collaboratively within the PoCS protocol.

To achieve this integration, the following steps were taken:

1. **Pallet-Staking Dependency:**
   - `pallet-staking` has been added to the list of dependencies for `pallet_contracts`.

2. **Configuration Inheritance:**
   - The `Config` of `pallet_staking` is inherited in `pallet_contracts`. This allows seamless communication and coordination between the two pallets.

3. **Type Name Changes:**
   - To resolve conflicts we have created alias for `Currency` and `WeightInfo` in both pallets, the trait names have been modified throughout `pallet_contracts`. The changes made are as follows:
     - `Currency` is renamed to `ContractCurrency`.
     - `WeightInfo` is renamed to `ContractsWeightInfo`.

   For a detailed reference, please visit: [GitHub Pull Request #10](https://github.com/auguth/pocs/pull/10/commits/b19898ed7ea1d22027b5abbdae3d2681d96e0dd1)

### Testing

PoCS protocol lets smart contract developers use their stake i.e., contract's utility score known as the **stake score** to nominate a validator. This section (Milestone 1) covers the preliminary phase of adding stake/delegate information added to the deployed contracts. These modifications/additions are used in the [modified Staking Pallet (PoCS version)](#nominated-proof-of-contract-stake-npocs---pallet_staking)

For successful test execution, the following pallets have been implemented in the test environment:
1. `pallet_staking`
2. `pallet_sessions`


The `rustc` version used in the [Github CI](/.github/workflows/rust.yml) and local during the development is `rustc 1.77.0-nightly (3d0e6bed6 2023-12-21)`

#### Testing `pallet_contracts` Functions

1. `instantiate_with_code()` Function

   **Description**: This function in `pallet_contracts` is used to deploy wasm-contracts to chain storage. It is modified to initialize the account stake info and contract scarcity info values while the contract is deployed

   ![instantiate_with_code()](https://raw.githubusercontent.com/jobyreuben/test/main/draw.io.svg)

   **Expected Output**: While a contract is deployed the `ContractStakeinfoMap` and `AccountStakeInfoMap` gets updated for the new contract address with the **default** account stake info and contract scarcity info values

   **New Events Emitted**: Tests added to [test.rs](https://github.com/auguth/pocs/blob/1e311f83cd0e59b4b4b6224b7e50b5b983b5f508/pallets/contracts/src/tests.rs#L5888)
      - `contract_stake_event` - Tests the ContractStakeInfo mapping has been updated and the emitted event reflects correct values. 
      - `account_stake_event` - Tests the AccountStakeInfo mapping has been updated and the emitted event reflects correct values.
   
   **Event Output Screenshot**

   ![Instantiate_Test_screenshot](https://raw.githubusercontent.com/auguth/pocs_img_assets/main/instantiate_test.jpeg)

2. `update_delegate()` Function

    **Description**: This is a custom function included in `pallet_contracts` to update the delegate information of a contract (`AccountStakeinfo`). 

    ![update_delegate()](https://raw.githubusercontent.com/auguth/pocs_img_assets/main/delegate_test.svg)

    **Expected Output**: 
      - Only be executed by the `owner` (Deployer of the contract) and updates the `AccountStakeinfo` values. 
      - The contract's scarcity information (`ContractScarcityinfo`) is reset back to default (any `stake_score` accumulated is purged to `0`). 
      - The `new_address` given by the `owner` shall be updated in `delegate_to` and the `delegate_at` is updated to current block height

    **New Events Emitted:** Tests added to [test.rs](https://github.com/auguth/pocs/blob/1e311f83cd0e59b4b4b6224b7e50b5b983b5f508/pallets/contracts/src/tests.rs#L5982)
      - `update_delegate_invalid_owner` - Test to check the update_delegate function for a contract does not succeed if not called by the contract owner.
      - `update_delegate_valid_owner` - Test to check that update_delegate when called by owner updates the ContractStakeInfo and AccountStakeInfo and emitted events reflect correct values.
   
    **Event Output Screenshot**

    ![Update_delegate_Test_screenshot](https://raw.githubusercontent.com/auguth/pocs_img_assets/main/delegate_test.jpeg)

3. `run()` Function

   ![run()](https://raw.githubusercontent.com/auguth/pocs_img_assets/main/run_test.svg)

   **Description**: This is function in `pallet_contracts` is executed when a contract is called. It is modified to update the `ContractScarcityinfo` values while the call is getting executed. 

   **Note:** As of Milestone 1, this feature is not been implemented and shall be included in Milestone 2 due to its dependency on the modified `pallet_staking` in Milestone 2. But, the stake score calculation is done.

   **Expected Output**: During the execution of the contract call - 
      - The `reputation` is incremented by 1. 
      - The `recent_block_height` is updated to `current_block_height`. 
      - The `stake_score` is updated to new stake score (Milestone 2)

   **New Event Emitted:** Tests added to [test.rs](https://github.com/auguth/pocs/blob/1e311f83cd0e59b4b4b6224b7e50b5b983b5f508/pallets/contracts/src/tests.rs#L5888)
      - `contract_stake_event` - Tests the ContractStakeInfo mapping has been updated and the emitted event reflects correct values.
     
   **Event Output Screenshot**

   ![Run_Contract_Test_screenshot](https://raw.githubusercontent.com/auguth/pocs_img_assets/main/run_test.jpeg)

   **Contract Delegate Call :** During Scenario of Contracts calling other contracts (`delegatecall`), the following events are emitted and the Contract Stake information is updated for both caller contract and callee contract
      - Caller Contract (5DJCn75...) - [Compiled](https://github.com/auguth/ink-contracts-for-testing/blob/main/caller.contract) / [Source](https://github.com/auguth/ink-contracts-for-testing/blob/main/caller/lib.rs)
      - Callee Contract(5GxyE5...) - [Compiled](https://github.com/auguth/ink-contracts-for-testing/blob/main/flipper.contract) / [Source](https://github.com/auguth/ink-contracts-for-testing/blob/main/flipper/lib.rs)
 
    ![Cross_Call_Test_screenshot](https://raw.githubusercontent.com/auguth/pocs_img_assets/main/cross_call_test.jpeg)

  
#### Running PoCS Tests

```
cargo build --verbose
cargo test pocs // Will run pocs tests
```

**Note** : Currently we have **170 tests passing** and 64 failing tests. The failing tests from pallet-contract have been failing before the changes. 

### Benchmarks

Currently `storage` is benchmarked. There has not been significant changes in runtime. Check out [benchmarks folder](/benchmarks/) for results.

TBD (Milestone 2) - Since, the modified functions undergo further changes, the weights benchmarking will be continued onto Milestone 2

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
