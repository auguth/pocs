# Proof of Contract Stake (PoCS) : Testing Report

**Project version:** v0.1 (Experimental)

## pallet-contracts

The Contracts module provides functionality for the runtime to deploy and execute WebAssembly smart-contracts.

### [`/src/lib.rs`](https://github.com/auguth/pocs/blob/w3f_milestone_3/solo-substrate-chain/pallets/contracts/src/lib.rs)

#### Storage Additions

  These maps leverage the `DelegateInfo` and `StakeInfo` structs from `pallet_contracts::stake` module to track stake-related data, enabling contract-based staking and delegation.

  - `DelegateInfoMap` – Stores delegate-related information for each contract.  
  - `StakeInfoMap` – Tracks stake scores of smart contracts.  
  - `ValidatorInfoMap` – Records the number of delegates associated with a validator.  


#### Error Handling

  These errors handle edge cases and failures during delegation, stake management, and validator nomination.

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

#### Event Additions

  These events ensure transparent tracking of stake updates, delegation actions, and validator status, facilitating better monitoring and debugging.

  - `Staked` – Emitted when a contract’s stake score is updated.  
  - `Delegated` – Emitted when a contract is delegated to a validator.  
  - `ReadyToStake` – Signals that a contract meets the minimum reputation for staking.  
  - `ValidateInfo` – Provides details about a validator’s status and eligibility.  
  - `StakeOwner` – Emitted when a contract’s stake owner is updated.  


#### New Dispatchable Calls

  These functions enable smart contracts to interact with the PoCS system by delegating validation, updating contract ownership, and participating as validators.

  1. `delegate()`  
     - **Purpose:** Allows a contract to delegate its validation rights to another account.  
     - **Logic:** Ensures the origin is signed and calls the `delegate()` function from `pallet_contracts::stake::DelegateRequest::delegate`.  

  2. `update_owner()`  
     - **Purpose:** Updates the stake owner for a contract.  
     - **Logic:** Ensures the origin is signed and invokes `update_stake_owner()` from `pallet_contracts::stake::DelegateRequest::update_stake_owner`.  

  3. `validate()`  
     - **Purpose:** Allows a contract to register as a validator and set preferences.  
     - **Logic:** Ensures the origin is signed and calls `validate()` from `pallet_contracts::stake::ValidateRequest::validate`, which in turns call the `validate()` method in pallet_staking.  

Benchmarks for the two functions `delegate()` and `update_owner()` is written in `pallet_contracts::src::benchmarking::mod`


### [`/src/exec.rs`](https://github.com/auguth/pocs/blob/w3f_milestone_3/solo-substrate-chain/pallets/contracts/src/exec.rs)

#### `fn run()`

**Key Additions**
1. Capture Stake Arguments:

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

<a id="breaking-changes"></a>
>
> ⚠️ **Important Note**: 
>
> The expected arguments for the stake request in `fn run` introduce a breaking change due to sub-calls allowing the Root Account to call and test. Since we now extract the caller's account ID via `self.caller().account_id()`, this results in a `RootNotAllowed` error, causing existing tests to fail.  
>
>This behavior cannot be bypassed, as PoCs fundamentally rely on the frame's caller account ID to assign stakes. Therefore, restricting the Root Account from calling contracts across all areas is necessary. Tests that previously expected root calls to succeed should be modified accordingly in future development.


#### `fn terminate()`

- Stake (PoCS) Deletion on Termination:

    To remove stake records when a contract is terminated the following call is made.

    ```rust
    StakeRequest::<T>::delete(&frame.account_id);
    ```

---

### [`/src/stake/..`](https://github.com/auguth/pocs/tree/w3f_milestone_3/solo-substrate-chain/pallets/contracts/src/stake)

#### Stake Module

  Encapsulates PoCS-specific logic in a self-contained module, improving modularity, testability, and maintainability.

- **Structure:**
  - [`mod.rs`](https://github.com/auguth/pocs/blob/w3f_milestone_3/solo-substrate-chain/pallets/contracts/src/stake/mod.rs) – Centralized all PoCS functionalities, providing a cohesive and loosely coupled design.
  - [`chain_ext.rs`](https://github.com/auguth/pocs/blob/w3f_milestone_3/solo-substrate-chain/pallets/contracts/src/stake/chain_ext.rs) – Implements two chain extensions for querying and updating stake and delegate information.

- **Key Features:**
  - All struct fields are accessed via dedicated methods.
  - Comprehensive error handling for all operations.


#### Module Overview

- **Core Functionalities:**
  - Implements stake/delegate/validator requests and management based on [PoCS specification](./specification/pocs-spec.pdf).
  - Provides methods for struct access, enhancing data encapsulation.

- **Error Handling:**
  - Explicit error management for all operations.
  - Uses `DispatchError` where appropriate, ensuring accurate error propagation to existing disptachable functions.


#### Chain Extensions Overview

Facilitates contract-level read and update operations on delegate and stake data while ensuring security and maintaining consistency with PoCS mappings.

1. **FetchStakeInfo (ID: 1200)** - For Stake State Query

    Ensures only known function IDs are handled, with error logging for unknown requests.

    | Function Name   | Function ID |
    |---------------|------------|
    | `delegate_to`  | 1000       |
    | `delegate_at`  | 1001       |
    | `stake_score`  | 1002       |
    | `reputation`   | 1003       |
    | `owner`        | 1004       |


2. **UpdateDelegateInfo (ID: 1300)** - For Stake State Update
   
   Validates the calling contract using the environment context to provide extrinsic calling behaviour to contracts which own other contracts.

    | Function Name   | Function ID |
    |---------------|------------|
    | `DelegateInfo::delegate_to`  | 1005       |
    | `DelegateInfo::owner`  | 1006       |


---

### [`src/tests.rs`](https://github.com/auguth/pocs/blob/w3f_milestone_3/solo-substrate-chain/pallets/contracts/src/tests.rs)

Comprehensive tests have been implemented to cover all functionalities within the `pallet-contracts` module. These tests include integrated checks for `stake/mod.rs` and `exec.rs`. All the test for PoCS will start with the prefix `pocs_` While the chain extension (`chain-ext.rs`) is excluded from these tests, dedicated tests for it are provided within the contracts directory.

**Test's that are Failing**
- `benchmarking::bench_seal_caller_is_root`
- `test exec::tests::root_caller_succeeds`
- `exec::tests::root_caller_succeeds_with_consecutive_calls`
- `tests::root_can_call`

These test are failing due to the [Breaking changes](#breaking-changes) made in the `pallet-contracts`. 

---

## pallet-staking

>**⚠️ Important Note:**
The changes made in `src/pallet/mod.rs` and `src/tests.rs` are Breaking changes. These changes are temporary and will be corrected or revised in further development. As this was the only method that may couple PoCS and NPoS logic.

### [`src/pallet/mod.rs`](https://github.com/auguth/pocs/blob/w3f_milestone_3/solo-substrate-chain/pallets/staking/src/pallet/mod.rs)

- **Commented out checks related to minimum balance requirement:**

    - `if value < T::Currency::minimum_balance()`

    - `ledger.active >= T::Currency::minimum_balance()`

    - `ledger.active >= min_active_bond`

    - `ledger.active >= MinValidatorBond::<T>::get()`

    - `ledger.active >= MinNominatorBond::<T>::get()`

To treat the stake score as a balance and allow the creation of an empty bond.

### [`src/test.rs`](https://github.com/auguth/pocs/blob/w3f_milestone_3/solo-substrate-chain/pallets/staking/src/tests.rs)

- **Commented out Tests:**

    - `bond_with_no_staked_value` – Previously tested bonding behavior with zero stake, which is no longer required.
    - `cannot_bond_extra_to_lower_than_ed` – Checked that bond extra values cannot fall below the existential deposit, which is no longer enforced.
    - `min_bond_checks_work` – Validated minimum bond checks for nominators and validators, now obsolete due to the removal of these limits.

These tests were downgraded since the minimum bond check is removed in PoCS.


## Ink-Contracts

For each chain extension and its function id, corresponding Ink! contracts are provided. 

> The `flipper` and `simple_caller` contracts are extras, with `flipper` serving as a dummy contract.

### Custom Chain Extension (ID 1200)

  Added five key functions for validator and delegation management which are also given as each seperate contracts:

  - [`delegate_to`](https://github.com/auguth/pocs/blob/w3f_milestone_3/ink-contracts/delegate_to/lib.rs): Retrieves the delegate of a given account (Func ID: 1000)

  - [`delegate_at`](https://github.com/auguth/pocs/blob/w3f_milestone_3/ink-contracts/delegate_at/lib.rs): Returns the block number when the delegation was last updated (Func ID: 1001)

  - [`stake_score`](https://github.com/auguth/pocs/blob/w3f_milestone_3/ink-contracts/stake_score/lib.rs): Retrieves the stake score of a given contract (Func ID: 1002)

  - [`reputation`](https://github.com/auguth/pocs/blob/w3f_milestone_3/ink-contracts/reputation/lib.rs): Fetches the reputation score (Func ID: 1003)

  - [`owner`](https://github.com/auguth/pocs/blob/w3f_milestone_3/ink-contracts/owner/lib.rs): Returns the owner of a given contract (Func ID: 1004)

### Custom Chain Extension (ID 1300)

  Added functions for advanced delegation and validator updates:

  > Both functions are integrated into a single contract, as a contract is required to deploy/instantiate a contract to become its owner to call the below chain extension functions.
  
  - [`update_delegate`](https://github.com/auguth/pocs/blob/w3f_milestone_3/ink-contracts/update_delegate/lib.rs): Updates the delegate for a given contract account and ensures synchronization with stake data (Func ID: 1005)
  - [`update_owner`](https://github.com/auguth/pocs/blob/w3f_milestone_3/ink-contracts/update_delegate/lib.rs): Updates the owner for a given contract account and ensures synchronization with stake data (Func ID: 1006)

### Delegate Registry Contract (Validator Reward Contract)

[`delegate_registry`](https://github.com/auguth/pocs/blob/w3f_milestone_3/ink-contracts/delegate_registry/lib.rs): Implements a reward distribution mechanism by tracking stake scores and delegation using PoCS chain extensions. The contract supports contract registration, reward claiming, and cancellation.

  **Callable Functions**:
  - `fn register()`: Registers a contract and updates the stake pool.
  - `fn claim()`: Claims rewards based on updated stake scores.
  - `fn cancel()`: Removes a contract from the registry along with claiming existing reward.


### Automated End-to-End (E2E) Testing

  - The E2E testing is automated using the [`e2e_test.sh`](https://github.com/auguth/pocs/blob/w3f_milestone_3/ink-contracts/e2e_test.sh) script. 
  - This script spins up the PoCS node and manages test cases for all Ink! contracts and chain extensions in the project as a combined test. 
  - It ensures comprehensive validation across the contract lifecycle, including deployment, delegation updates, and ownership transfers.
    
## Future (PoCS v0.2)  

- **Challenges with NPoS**: Since NPoS is inherently tied to balances and currency, maintaining or removing invariants related to staking primitives is complex. In contrast, the stake score consists of non-transferable, non-fungible computational units.  
- **Stake Module Extension**: Future development will extend the stake module in `pallet_contracts` to support a minimal implementation of NPoS, derived from `pallet_staking`, but without dependencies on balance or currency primitives. This will ensure full compatibility with PoCS without breaking changes.
- **Optimized Staking Logic**: To enhance efficiency, the staking logic will be integrated directly into the `pallet_contracts` crate, aligning with PoCS's one-to-one communication between contracts and staking.
