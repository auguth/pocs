# Alpha Testing Report: Proof of Contract Stake (PoCS)

## Project Overview

**Project Name:** Proof of Contract Stake (PoCS)

**Project Description:** PoCS ties stake score to smart contract execution, ensuring security through verifiable computation. Unlike token-based staking, PoCS
rewards actively executed contracts using reputation score preventing
artificial inflation. Delegation allows contracts to assign validation rights
based on reputation, ensuring Sybil resistance. By aligning computation
with staking, PoCS strengthens economic security and incentivizes long-
term execution. 

**Project version:** v0.1

##  Summary of Changes

### 1. Pallet Modifications

### pallet-contracts

**Path:** [solo-substrate-chain/pallets/contracts](https://github.com/auguth/pocs/tree/bf21e8f7cf119bd69d7ad8f942159d6e399fd08d/solo-substrate-chain/pallets/contracts)

**Description:** The Contracts module provides functionality for the runtime to deploy and execute WebAssembly smart-contracts.

---
**Changes in [`src/lib.rs`](https://github.com/auguth/pocs/blob/bf21e8f7cf119bd69d7ad8f942159d6e399fd08d/solo-substrate-chain/pallets/contracts/src/lib.rs)**

**1. Storage Additions**

- **New Maps for PoCS Tracking:**

  - `DelegateInfoMap` – Stores delegate-related information for each contract.  
  - `StakeInfoMap` – Tracks stake scores of smart contracts.  
  - `ValidatorInfoMap` – Records the number of delegates associated with a validator.  

**Purpose:**  
These maps leverage the `DelegateInfo` and `StakeInfo` structs from `crate::stake` to track stake-related data, enabling contract-based staking and delegation.

**2. Error Handling**

- **New Errors Added:**  

  - `InvalidContractOwner` – Origin is not the valid owner of the contract.  
  - `NoStakeExists` – No stake information available for the contract.  
  - `NoValidatorFound` – Validator for the contract address is not found.  
  - `LowReputation` – Contract does not meet minimum reputation for staking.  
  - `AlreadyDelegated` – Contract is already delegated to the specified address.  
  - `AlreadyOwner` – Contract is already owned by the given account.  
  - `NewBondFailed` – Failure in creating a new bond.  
  - `BondExtraFailed` – Failure in adding extra funds to an existing bond.  
  - `BondRemoveFailed` – Failure in removing an existing bond.  
  - `NominationFailed` – Validator nomination process failed.  
  - `ValidationFailed` – Validator validation criteria check failed.  
  - `InsufficientDelegates` – Minimum delegate count for validation is not met.  

**Purpose:**  
These errors handle edge cases and failures during delegation, stake management, and validator nomination.

**3. Event Additions**

- **New Events for PoCS:**  

  - `Staked` – Emitted when a contract’s stake score is updated.  
  - `Delegated` – Emitted when a contract is delegated to a validator.  
  - `ReadyToStake` – Signals that a contract meets the minimum reputation for staking.  
  - `ValidateInfo` – Provides details about a validator’s status and eligibility.  
  - `StakeOwner` – Emitted when a contract’s stake owner is updated.  

**Purpose:**  
These events ensure transparent tracking of stake updates, delegation actions, and validator status, facilitating better monitoring and debugging.

**4. New Dispatchable Calls**

- **Invocable Functions Added:**  

  1. `delegate()`  
     - **Purpose:** Allows a contract to delegate its validation rights to another account.  
     - **Logic:** Ensures the origin is signed and calls the `delegate()` function from `crate::stake::DelegateRequest`.  

  2. `update_owner()`  
     - **Purpose:** Updates the stake owner for a contract.  
     - **Logic:** Ensures the origin is signed and invokes `update_stake_owner()` from `crate::stake::DelegateRequest`.  

  3. `validate()`  
     - **Purpose:** Allows a contract to register as a validator and set preferences.  
     - **Logic:** Ensures the origin is signed and calls `validate()` from `crate::stake::ValidateRequest`.  

**Purpose:**  
These functions enable smart contracts to interact with the PoCS system by delegating validation, updating contract ownership, and participating as validators.

---

**Changes in [`src/exec.rs`](https://github.com/auguth/pocs/blob/bf21e8f7cf119bd69d7ad8f942159d6e399fd08d/solo-substrate-chain/pallets/contracts/src/exec.rs)**

**1. Additions in `fn run`**

- **Key Additions**
1. Capture Stake Data:

    ```rust
    let account_id = &frame.account_id.clone();
    let gas = frame.nested_gas.gas_consumed().ref_time();
    let caller = self.caller().account_id()?.clone();
    ```
- **`account_id`**: Retrieves the contract account ID from the current frame.
- **`gas`**: Measures the gas consumed during the execution.
- **`caller`**: Retrieves the caller of the contract.


2. Stake Invocation:

    ```rust
    StakeRequest::<T>::stake(&caller, &account_id, &gas)?;
    ```
- **Calls the `stake` function** from the `StakeRequest` implementation.
- This ensures the contract's execution is recorded for Proof of Contract Stake (PoCS).

> Note: The addition in the `fn run` introduce a breaking change due to Substrate's subcall mechanism, so that retrieving the caller with `self.caller().account_id()` may fail, causing existing tests to break.


**2. Addition in `fn terminate`**

- **Stake (PoCS) Deletion on Termination:**

    Added the below code snippet to remove stake records when a contract is terminated.

    ```rust
    StakeRequest::<T>::delete(&frame.account_id);
    ```

---
**New Module [`src/stake`](https://github.com/auguth/pocs/tree/bf21e8f7cf119bd69d7ad8f942159d6e399fd08d/solo-substrate-chain/pallets/contracts/src/stake)**

**1. New `stake` Module**

- **Structure:**
  - `mod.rs` – Centralized all PoCS functionalities, providing a cohesive and loosely coupled design.
  - `chain_ext.rs` – Implements two chain extensions for querying and updating stake and delegate information.

- **Key Features:**
  - All struct fields are accessed via dedicated methods.
  - Comprehensive error handling for all operations.
  - Tests for all function in `mod.rs`
  - No compiler warnings are emitted.

**Purpose:**
Encapsulates PoCS-specific logic in a self-contained module, improving modularity, testability, and maintainability.

**2. `mod.rs` Overview**

- **Core Functionalities:**
  - Implements stake tracking and delegate management based on specification.
  - Provides methods for struct access, enhancing data encapsulation.

- **Error Handling:**
  - Explicit error management for all operations.
  - Uses `DispatchError` where appropriate, ensuring accurate error propagation.

**Purpose:**
Centralizes all stake and delegation logic, enforcing method-based struct access and robust error handling.


**3. `chain_ext.rs` Overview**

- **FetchStakeInfo (ID: 1200)**
  - Provides read access to:
    - `delegate_to` (func_id: 1000)
    - `delegate_at` (func_id: 1001)
    - `stake_score` (func_id: 1002)
    - `reputation` (func_id: 1003)
    - `owner` (func_id: 1004)
  
  - Ensures only known function IDs are handled, with error logging for unknown requests.

- **UpdateDelegateInfo (ID: 1300)**
  - Allows updates to:
    - Delegate information (func_id: 1005)
    - Stake owner (func_id: 1006)

  - Validates the calling contract using the environment context to prevent unauthorized updates.

**Purpose:**
Facilitates contract-level read and update operations on delegate and stake data while ensuring security and maintaining consistency with PoCS mappings.

---

**Addition in [`src/tests.rs`](https://github.com/auguth/pocs/blob/bf21e8f7cf119bd69d7ad8f942159d6e399fd08d/solo-substrate-chain/pallets/contracts/src/tests.rs)**

**1. Comprehensive Test Coverage**

- **Scope of Tests:**

  - Covers all functionalities within `pallet-contracts`, excluding `chain-ext.rs`.  
  - Tests for `chain-ext.rs` are located within the corresponding Ink! contracts. 

- **Test Design::**

  - Tests are expressive and validate all key operations.
  - Comprehensive coverage ensures both positive and negative test cases are handled.

**Purpose:**  
Ensures the correctness of PoCS functionality, providing clear validation of expected behaviors and failure scenarios.

---

### pallet-staking

**1. Changes in [`src/pallet/mod.rs`](https://github.com/auguth/pocs/blob/bf21e8f7cf119bd69d7ad8f942159d6e399fd08d/solo-substrate-chain/pallets/staking/src/pallet/mod.rs)**

- **Commented out checks related to minimum balance requirement:**

    - `if value < T::Currency::minimum_balance()`

    - `ledger.active >= T::Currency::minimum_balance()`

    - `ledger.active >= min_active_bond`

    - `ledger.active >= MinValidatorBond::<T>::get()`

    - `ledger.active >= MinNominatorBond::<T>::get()`

**Purpose:**  
To treat the stake score as a balance and allow the creation of an empty bond.

**2. Changes in [`src/test.rs`](https://github.com/auguth/pocs/blob/bf21e8f7cf119bd69d7ad8f942159d6e399fd08d/solo-substrate-chain/pallets/staking/src/pallet/mod.rs)**

- **Commented out Tests:**

    - `bond_with_no_staked_value` – Previously tested bonding behavior with zero stake, which is no longer required.
    - `cannot_bond_extra_to_lower_than_ed` – Checked that bond extra values cannot fall below the existential deposit, which is no longer enforced.
    - `min_bond_checks_work` – Validated minimum bond checks for nominators and validators, now obsolete due to the removal of these limits.

**Purpose:**  
These tests were downgraded since the minimum bond check is removed in PoCS.

>**Note:**
The changes made in `src/pallet/mod.rs` and `src/tests.rs` are Breaking changes. These changes are temporary and will be corrected or revised in the next grant.


### 2. Ink-Contracts

For each chain extension and its function id, corresponding Ink! contracts are provided. The `flipper` and `simple_caller` contracts are extras, with `flipper` serving as a dummy contract.

- **Custom Chain Extension (ID 1200):**

    Added five key functions for validator and delegation managementm which are also given as each seperate contratcs:

    - `delegate_of`: Retrieves the delegate of a given account (Func ID: 1000)

    - `delegate_at`: Returns the block number when the delegation was last updated (Func ID: 1001)

    - `stake_score`: Retrieves the stake score of a given contract (Func ID: 1002)

    - `reputation`: Fetches the reputation score (Func ID: 1003)

    - `owner`: Returns the owner of a given contract (Func ID: 1004)

- **Custom Chain Extension (ID 1300):**

    Added functions for advanced delegation and validator updates:
    
    - `update_delegate`: Updates the delegate for a given account and ensures synchronization with stake data (Func ID: 1005)

- **Delegate Registry Contract `delegate_registry`:**
    - Implements a reward distribution mechanism by tracking stake scores and delegation.
    - Validates contract ownership using the `owner_check` method.
    - Ensures delegation consistency with the `delegate_check` method.
    - Supports contract registration, reward claiming, and cancellation.

    Key Methods:
    - `register`: Registers a contract and updates the stake pool.
    - `claim`: Claims rewards based on updated stake scores.
    - `cancel`: Removes a contract from the registry after claiming.

    - **Environment Customization:**
    - Uses `CustomEnvironment` to integrate with the chain extension.

- **Automated End-to-End (E2E) Testing**

    - The E2E testing is automated using the `e2e_test.sh` script. 
    - This script spins up the PoCS node and manages test cases for all Ink! contracts and chain extensions in the project as a combined test. 
    - It ensures comprehensive validation across the contract lifecycle, including deployment, delegation updates, and ownership transfers.
    
