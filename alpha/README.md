# PoCS - Alpha Tests

This document outlines the alpha testing phase of the Proof of Contract Stake (PoCS) protocol, focusing on ensuring its functionality according to specifications.

The primary objective of alpha testing is to ensure that the protocol functions works precisely as per its [specifications](/formal-spec/README.md). This phase involves meticulous testing and validation to identify any discrepancies or issues that may exist within the [implementation](https://github.com/auguth/pocs).

**Test Environment:**

- Execute `cargo test pocs` within the PoCS repository.


<!---

**Expected Output:** 

- 

**Written Test:** 

```bash
test code
```

*Output:*

```bash
test code
```

*Logs*

Can be viewable at [Github Workflow Line X]()

```bash
test code
```

-->

## Provable Tests

> Kindly note that the extrinsic functions are called from `pallet-contracts` only, the security issues of calling from `pallet-staking` are explained in [Security Issues](#security-issues) section

### 1. Contract Instantiation & Bonding

**Function Called:** `instantiate_code()`

**Requirement:** When instantiating a contract, a bond must be created utilizing the instantiated contract's stake score, which is initially zero. During the instantiation, default values such as `delegateAt` (current blockheight), `reputation` (1), `stake_score` (zero), and `delegateTo`  (assigned to the contract deployer) must be updated accordingly.

**Security Questions**

1. Can the default values be altered in the extrinsic-transaction?
   
   *Answer* :  


**Test Flowchart**



**Expected Output**
- `delegateAt` updated to the current blockheight.
- `reputation` set to 1.
- `stake_score` initialized to zero.
- `delegateTo` assigned to the contract deployer.
- `Bond` created using the instantiated contract's `stake_score`.

**Workflow Logs**





### 2. Updating Delegate Info 

**Functions Called:** `update_delegate()`

**Requirement:** When updating delegate information through the `update_delegate()` function, it is required to verify that the caller is indeed the owner of the contract and that the requirement of `min_reputation` is satisfied i.e., the contract's `reputation >= min_reputation`. This function should facilitate the modification of delegate (validator) information and nominate the `delegateTo` validator for the subsequent era. Upon nomination, the stake score should reset to zero, reputation gets updated by +1, and the bond should be set to zero. 

**Security Questions**

1. Does Nomination happen during contract instantiation even if the contract deployer is the Validator controller account ?

   *Answer* :  

2. Does the validator controller account receives the fees collectively or it should be enforced?

   *Answer* :  

**Test Flowchart**

**Expected Output**
- Ensure minimum reputation criteria
- `stake_score` reset to zero.
- `reputation` updated by +1.
- `bond_value` set to zero.
- Successful update of delegate information.
- Nomination of `delegateTo` validator.

**Workflow Logs**

### 3. Nominated Bond Impact

**Functions Called:** `run()`

**Requirement:** Contracts updating stake score, reputation, recentBlockHeight and its bond_value on execution of the contract in the block.

**Test Flowchart**

**Expected Output**
- `stake_score` of a contract should be incremented.
- `bond_value` should be incremented
- `reputation` should be incremented if required
- `recentBlockHeight` should be updated if reputation is modified.

**Workflow Logs**

**Security Questions**

### 4. Multi-Contract Behavior

**Functions Used:** 
1. `run()`

**Requirement:** Is the contracts are getting increased in stake_score and is bond value increasing, or two are increasing. 

In the case of multiple contracts, the behavior could vary based on how the system is architected, such as whether each contract maintains its own bond or if there's a shared bond pool under contract deployer.

Is the validator can validate after minimum nominations, in that case what if a deployer has two contracts will it be two nominations or just 1.

**Expected Output**

**Test Flowchart**

**Workflow Logs**

**Security Questions**

## Security Issues

### PoCS x NPoS Collaboration

The collaboration between PoCS and NPoS introduces unique security challenges. It's essential to identify these challenges and develop robust solutions to address them effectively.

Issues include
- Publicly Callable Functions via pallet-staking
- Overflow issue of stake_score due to refTime's accuracy
- Unfeasible Normalization on stake_score
- Reward Distribution Extrinsic
- Enforcing Vaidator Controller account as contract

### Gray Areas

Include all gray areas to attend to

### Maximum Stake Score Attainable

The `stake_score` is a `unit64` integer that represents the cumulative stake score of individual transaction's `refTime` and reputation. Understanding the maximum attainable Stake Score is crucial for assessing the protocol's security limits and scalability potential.

#### Calculation Methodology

To determine the maximum attainable Stake Score, we employ a systematic approach based on the frequency of contract calls and the block's `refTime` (block's gas limit).

- **Step 1**: Define a hypothetical scenario where a contract is being called for a certain percentage of blocks consecutively from the genesis block. For example, assume the contract is called for 10% of blocks.
- **Step 2** : Bring a minimum gas limit per call to include multiple calls in an individual block and access its stake score accumulation.
- **Step 3**: Calculate the number of consecutive blocks required for an overflow error to occur due to the Stake Score reaching its maximum value.
- **Step 4**: Repeat the process for different percentages of block calls, such as 20%, 30%, and so on, to explore the impact of varying activity levels on the maximum attainable Stake Score.

Here's how we can implement the simulation script in python

```python
inputs given by the user : BlockGasLimit, MinGasPerCall, u64Max, divisor

Ensure that divisor is <= 100, if not print divisor overflow error and end the script
Find the number of plots using the divisor, use variable numPlots = 100/divisor
Loop this until numPlots = 100
    Calculate numCalls = (numPlots % * BlockGasLimit)/MinGasPerCall
    If numCalls > 0 then
        Calculate GasPerCall = (numPlots % * BlockGasLimit)/numCalls

        Calculation model

        Plot the X,Y Values and add legend as {numPlots}% of BlockGasLimit
        update numPlots = numPlots + numPlots
    else
        update numPlots = numPlots + numPlots

Merge all the Legends
Name the Chart as Maximum Score Attainable
Generate Chart, Should be smooth curve lines, 
Export to PNG in the same root folder of the script file
```

#### Ethereum's Difficulty Bomb

The Ethereum network has faced challenges related to the "difficulty bomb", a mechanism designed to gradually increase the difficulty of mining Ethereum blocks. It was initially introduced to incentivize the transition from proof-of-work (PoW) to proof-of-stake (PoS) consensus. However, it can significantly impact the network's performance and scalability, making it unfeasible for miners to continue operating effectively.

Several Ethereum Improvement Proposals (EIPs) have been proposed to address the difficulty bomb issue and ensure a smooth transition to PoS. These proposals aim to mitigate the negative effects of the difficulty bomb by adjusting block difficulty parameters or delaying its activation until Ethereum transitions to PoS consensus. Notable EIPs include [EIP-3554](https://eips.ethereum.org/EIPS/eip-3554), which proposes delaying the difficulty bomb until December 2021.

Similarly, the overflow issue of `u64` in PoCS's stake_score introduces challenges as the possibility of overflow issue is imperative and requires a feasible solution, without thriving in inequable losses when normalization is attempted. Higher Storage such as `u128` might result in heavier storage read and write operations and can be exhaustive for simpler contract executions.

#### Methods of Improvement

Normalization an intro
Normalization on continuous infinite set
Losses and inequality
Addition of newer elements may disturb immutable history
Un-Solvable question requires a different approach, either changing the entire question or solving via an acceptable indirect answer similar to a patch work.
methods to resolve this
    - tier system, if new stake score < old stake score, then new tier, overflow bypass
    - removing refTime and involving new gas structure based on numTransactions and global-constants

## Points to Improve

Continuous improvement is essential for enhancing the efficiency and effectiveness of the PoCS protocol. This section highlights areas where optimizations can be made.

### Optimization of Read and Write Operations

Optimizing read and write operations is crucial for minimizing resource consumption and improving overall system performance. Utilizing Big-O notation helps identify areas for improvement.

Give examples :

## Parachain Implications

Parachains introduce new possibilities and considerations for the PoCS ecosystem. Understanding these implications is essential for future development and integration efforts.

### Cumulus Integration

### Leveraging Moonbeam's Staking Integration

### Removal of Reward Systems

### Controller Account Ensure

ensuring if a controller account is a contract - validator registration and update_delegate()