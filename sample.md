## Alpha Testing Report

### 1. Overview

The alpha testing phase focused on validating the integration of the `delegate_registry` contract with the custom PoCS chain extension (ID 1200) within the Ink! smart contract framework. The primary objective was to ensure the correct functioning of contract registration, reward distribution, and validator checks using the chain extension functions.

### 2. Changes in the Substrate Node

- **Custom Chain Extension (ID 1200):**
    - Added five key functions for validator and delegation management:
        - `delegate_of`: Retrieves the delegate of a given account (Func ID: 1000)
        - `delegate_at`: Returns the block number when the delegation was last updated (Func ID: 1001)
        - `stake_score`: Retrieves the stake score of a given contract (Func ID: 1002)
        - `reputation`: Fetches the reputation score (Func ID: 1003)
        - `owner`: Returns the owner of a given contract (Func ID: 1004)

- **Custom Chain Extension (ID 1300):**
    - Added functions for advanced delegation and validator updates:
        - `update_delegate`: Updates the delegate for a given account and ensures synchronization with stake data (Func ID: 1005)
        - `fetch_delegate_info`: Retrieves detailed information about the current delegate, including stake and block data (Func ID: 1006)

- **Error Handling:**
    - Implemented custom error mapping using `From<u8>` and `FromStatusCode`.
    - Supports errors for invalid delegation, insufficient stake, ownership mismatch, and transfer failures.

- **Transaction Validations:**
    - Ensures correct delegation through the `UpdateDelegate` extension.
    - Validates the stake score and ensures consistency between the contract and the chain state.

- **Breaking Changes:**
    - Changes made in `src/pallet/mod.rs` and `src/tests.rs` introduce breaking changes. These will be revised and corrected in the next grant phase.

### 3. Changes in Ink! Contracts

For each chain extension, corresponding Ink! contracts are provided. The `flipper` and `simple_caller` contracts are extras, with `flipper` serving as a dummy contract.

- **Delegate Registry Contract:**
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

**Folder Structure:**

```
|- ink-contracts
   |- delegate_at
      |- target
         |- ink
            |- delegate_at.contract
   |- delegate_to
      |- target
         |- ink
            |- delegate_to.contract
   |- reputation
      |- target
         |- ink
            |- reputation.contract
   |- stake_score
      |- target
         |- ink
            |- stake_score.contract
   |- delegate_registry
      |- target
         |- ink
            |- delegate_registry.contract
   |- flipper
      |- target
         |- ink
            |- flipper.contract
   |- simple_caller
      |- target
         |- ink
            |- simple_caller.contract
```

### 4. E2E Testing

- **Testing Strategy:**
    - Automated via the `test.sh` script.
    - Simulates real-world contract deployments and reward claims.

- **Test Cases:**
    1. Successful contract registration and delegation verification.
    2. Validating reward claims based on stake score updates.
    3. Ensuring the contract owner can cancel and remove registrations.
    4. Handling error cases such as invalid delegation and insufficient stake.

- **Execution Flow:**
    1. Starts the Substrate node in `solo-substrate-chain`.
    2. Deploys the `delegate_registry` contract.
    3. Interacts with chain extension functions.
    4. Validates state transitions and reward distribution.

### 5. Key Findings

- **Functionality Validation:**
    - All chain extension functions interact correctly with the Ink! contract.
    - Stake score calculation and reward distribution match expected outputs.

- **Error Handling:**
    - Proper error propagation and handling for invalid delegates and ownership mismatches.

- **Performance:**
    - Efficient handling of large stake pools with minimal computation overhead.

### 6. Next Steps

1. Optimize reward calculation logic to reduce on-chain computation.
2. Expand test coverage to include edge cases and stress testing.
3. Validate compatibility with future chain extension updates.
4. Perform beta testing with external validators and larger datasets.

