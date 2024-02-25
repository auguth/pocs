# Testing Guidelines for PoCS (Milestone 2 - W3F)

## Overview:
In Milestone 2, [pallet-staking](https://auguth.github.io/pocs/target/doc/pallet_staking/index.html) has been integrated into pallet-contract to enable Proof of Contract Stake (PoCS) functionality with [Parity's](https://parity.io) Nominated Proof of Stake (NPoS). This document outlines the implementation details and testing procedures for PoCS.

## Implementation Details
- `pallet-contracts` and `pallet-staking` have been integrated.
- Key functionalities include:
  - Bonding initial stake upon contract deployment.
  - Increasing stake score upon contract execution.
  - Removing stake score when the developer changes their `delegate_to`.

## How PoCS Works
- Developers deploy smart contracts and become nominators by default.
- Developers can only nominate one validator at a time.
- Stake score represents the stake used to nominate the validator.
- Stake score increases upon contract execution.
- Stake score becomes zero when the developer changes their nominated validator.

## Unit Tests & Benchmarking Tests

Firstly [Build and Run Node](/README.md#pocs-node-set-up) or [Build and Run using Docker Compose](/README.md#docker-compose)

1. Unit Tests for `pallet-contracts`

    ```bash
    cargo test -p pallet-contracts
    ```

2. Run `pallet-contracts` Unit Tests with Benchmarks

    ```bash
    cargo test -p pallet-contracts --features=runtime-benchmarks
    ```

3. Unit Tests for `pallet-staking`

    ```bash
    cargo test -p pallet-staking
    ```

4. Run `pallet-staking` Unit Tests with Benchmarks

    ```bash
    cargo test -p pallet-staking --features=runtime-benchmarks
    ```

## PoCS Functionalities

### Functions

1. **[Instantiate_with_code()](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/struct.Pallet.html#method.instantiate_with_code):**

   - **Description:** Used in pallet_contracts to deploy wasm-contracts to chain storage. Modified to initialize [AccountStakeinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.AccountStakeinfo.html) and [ContractScarcityinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.ContractScarcityInfo.html) values during deployment, and call the [bond()` function](https://auguth.github.io/pocs/target/doc/pallet_staking/dispatchables/fn.bond.html) in pallet-staking to bond the contract deployer address with default stake score.
   - **Expected Output:** [ContractStakeinfoMap](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/type.ContractStakeinfoMap.html) and [AccountStakeInfoMap](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/type.AccountStakeinfoMap.html) are updated for the new contract address with default values. The contract deployer's address appears in the validator list with zero stake.

2. **[run()]():**
   - **Description:** Executed when a contract is called. Modified to update [ContractScarcityinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.ContractScarcityInfo.html) values during the call, call [bond_extra()` function](https://auguth.github.io/pocs/target/doc/pallet_staking/dispatchables/fn.bond_extra.html) in pallet-staking, and increments the new stake score. 
   - **Expected Output:** During contract execution:
     - `reputation` is incremented by 1.
     - `recent_block_height` is updated.
     - `stake_score` is calculated using a formula 
        $$\text{NewStakeScore} = \text{oldStakeScore} + ( \text{weight} \times \text{reputation})$$
     - `stake_score `is added to the nominator's bonded stake.
     
3. **[update_delegate()](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/dispatchables/fn.update_delegate.html):**
   - **Description:** PoCS specific function called by the contract owner to update delegate information of a contract (`AccountStakeinfo`). Calls a PoCS specific [function `new_unbond()](https://auguth.github.io/pocs/target/doc/pallet_staking/struct.Pallet.html#method.new_unbond) in pallet-staking to purge the stake for the nominator.
   - **Expected Output:** Delegate address (`delegateTo`) is changed. Nominator's stake is purged to zero.

### Structs

Incorporating PoCS-related features into `pallet_contracts`, including reputation values, delegate designation, and stake score.

The [gasstakeinfo.rs](/pallets/contracts/src/gasstakeinfo.rs) file in pallet-contracts introduces two key structs:

- [AccountStakeinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.AccountStakeinfo.html): Manages delegate information, contract owner address, contract address, and delegated stake score address.
- [ContractScarcityinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.ContractScarcityInfo.html): Handles stake score, contract reputation, and last updated block height.

Integration with `pallet-contracts` adds two essential maps:

- [AccountStakeInfoMap](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/type.AccountStakeinfoMap.html): Maps contract address to corresponding `AccountStakeinfo`.
- [ContractStakeinfoMap](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/type.ContractStakeinfoMap.html): Maps contract address to associated `ContractScarcityinfo`.

#### Default values 

Upon initial contract deployment are as follows:

   - **[AccountStakeinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.AccountStakeinfo.html):**
     - `Owner`: Account address of the contract deployer.
     - `Delegate_to`: By default, set to the `owner`.
     - `Delegate_at`: Current block height at the contract deployment.

   - **[ContractScarcityinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.ContractScarcityInfo.html):**
     - `Reputation`: Initialized to 1 by default.
     - `Recent_blockheight`: Current block height at contract deployment.
     - `Stake_score` : 0

### Tight-Coupling of Pallets

To integrate `pallet_contracts` and `pallet_staking` in PoCS protocol:

1. **Pallet-Staking Dependency:** Added `pallet-staking` to `pallet_contracts` dependencies.
2. **Configuration Inheritance:** `Config` of `pallet_staking` inherited in `pallet_contracts`.
3. **Type Name Changes:** Renamed `Currency` to `ContractCurrency` and `WeightInfo` to `ContractsWeightInfo` to resolve conflicts.

For details, refer to [GitHub Pull Request #10](https://github.com/auguth/pocs/pull/10/commits/b19898ed7ea1d22027b5abbdae3d2681d96e0dd1).

### PoCS Custom Events

1. **[AccountStakeinfoevent](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/enum.Event.html#variant.AccountStakeinfoevent):**
   - **Output:** 
     - `contractAddress`: Address of the deployed contract.
     - `owner`: Contract Deployer's Address.
     - `delegateTo`: Address that the stake is delegated to.
     - `delegateAt`: Block height at which the delegation occurred.

2. **[ContractStakeinfoevent](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/enum.Event.html#variant.ContractStakeinfoevent):**
   - **Output:** 
     - `contractAddress`: Address of the deployed contract.
     - `reputation`.
     - `recent_block_height`.
     - `stake_score`: Current Stake Score of the contract.


## Test Using Front-End

- Firstly [Build and Run Node](/README.md#pocs-node-set-up) or [Build and Run using Docker Compose](/README.md#docker-compose)
- Use sample ink! contracts from [auguth/ink-contracts-for-testing](https://github.com/auguth/ink-contracts-for-testing) 
- We used [flipper contract](https://github.com/auguth/ink-contracts-for-testing/blob/main/flipper.contract) below. 
- For advanced testing, [flipper](https://github.com/auguth/ink-contracts-for-testing/blob/main/flipper.contract) and [caller](https://github.com/auguth/ink-contracts-for-testing/blob/main/caller.contract) contract for testing contract delegate calls to test automated stake_score update across calls.

### Using Contracts UI and Polkadot-JS

1. **Deploying Contracts**

    1. Upload a contract e.g., [flipper contract](https://github.com/auguth/ink-contracts-for-testing) using [Contracts UI](https://contracts-ui.substrate.io/)
    
        ![Instantiate_with_code()](/assets/gifs/instantiate_with_code().gif)

    2. Should expect outputs - [two custom events](#pocs-custom-events) with [default values](#default-values)
    
        ![Instantiate_with_code() events](/assets/gifs/instantiate_with_code()-events.gif)

    3. In Validator List (alias nominator), the deployer address will be added
    
        ![Deployer as Nominator](/assets/gifs/deployer_as_nominator.gif)

2. **Executing Contracts**

    1. When executing contract, Emits [custom event](#pocs-custom-events) i.e., [ContractStakeinfoevent](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/enum.Event.html#variant.ContractStakeinfoevent) 
    2. In validator list of bonds, the stake score will be reflected
    
        ![Execute bond_extra()](/assets/gifs/execute_bond_extra().gif)

3. **Updating Delegate Info**

    1. Construct an extrinsic via `contracts` pallet with [update_delegate()]() function
  
        ![Update_delegate()](/assets/gifs/update_delegate().gif)
    
    2. In [AccountStakeinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.AccountStakeinfo.html), `delegateTo` and `delegateAt` will be updated and in [ContractStakeinfo](), the `stake_score` will be updated to 0 reflected in the validator list of bonds to zero. 
    
        ![Unbond events](/assets/gifs/unbond-events.gif)

    3. Can be verified that `delegateTo` address would be under waiting for nomination until `stake_score` updates and increases the bond value. 
    
        ![Update_delegate() Validator List](/assets/gifs/update_delegate()-validator-list.gif)

## Conclusion

These testing guidelines ensure proper integration and functioning of PoCS with [pallet-contracts](https://auguth.github.io/pocs/target/doc/pallet_contracts/index.html) & [pallet-staking](https://auguth.github.io/pocs/target/doc/pallet_staking/index.html). By following these steps, developers/reviewers can verify the correctness and reliability of the implemented features.