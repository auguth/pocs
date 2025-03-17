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

**1.New Function**

- **Added `run` Function**

    The run function is responsible for executing the current frame call (either Call or Constructor), tracking gas consumption, and initiating stake updates via StakeRequest.

**2. Updated `terminate` function**

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

**Addition in src/tests.rs [`src/stake`](https://github.com/auguth/pocs/blob/bf21e8f7cf119bd69d7ad8f942159d6e399fd08d/solo-substrate-chain/pallets/contracts/src/tests.rs)**

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
