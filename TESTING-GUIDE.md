# Testing Guidelines for PoCS

> The testing guide is provided for Milestone-2 PoCS W3F Grant Delivery

[pallet-staking](https://auguth.github.io/pocs/target/doc/pallet_staking/index.html) has been integrated into [pallet-contracts](https://auguth.github.io/pocs/target/doc/pallet_contracts/index.html) to enable Proof of Contract Stake (PoCS) functionality with [Parity's](https://parity.io) Nominated Proof of Stake (NPoS). By following these steps, developers/reviewers can verify the correctness and reliability of the implemented features.

**Table of Contents**

- [Testing Guidelines for PoCS](#testing-guidelines-for-pocs)
  - [How PoCS Works](#how-pocs-works)
  - [Test Locally](#test-locally)
  - [Test Using Front-End](#test-using-front-end)
  - [Alternate Testing Methods](#alternate-testing-methods)
  - [Commit History](#commit-history)

## How PoCS Works
- Developers deploy smart contracts and become nominators by default.
- Developers can only nominate one validator at a time.
- Stake score represents each contract's execution time
- Stake score is used to nominate the validator.
- Stake score increases upon contract execution.
- Stake score purges to zero when the developer changes their nominated validator.

In-depth information about PoCS can be inferred from [PoCS-Research Document](https://jobyreuben.in/JOURNALS/pocs).

## Test Locally

- Building a local node is suitable to verify PoCS's unit & benchmarking tests locally, and further compile to run a Substrate-PoCS node. 

1. Clone the repository from GitHub
   ```bash
   git clone https://github.com/auguth/pocs
   ```
2. Run the Rust Setup Script
   ```bash
   chmod +x setup.sh && ./setup.sh
   ```
3. Run Unit Tests (Optional)

    pallets used : `pallet-contracts`, `pallet_staking`

   ```bash
   cargo test -p [pallet-name]
   ``` 
4. Run Benchmarking Tests (Optional)
   ```bash
   cargo test -p [pallet-name] --features=runtime-benchmarks
   ``` 
5. Build the project in release mode
   
   ```bash
   cargo build --release
   ```
6. Run the executable with the specified configuration:
   
    ```bash
    ./target/release/pocs --dev
    ```

## Test Using Front-End

After running the executable, the following tests using front-end can be done to verify the correctness mentioned in [How PoCS Work](#how-pocs-works) Section.

- Use [Polkadot-JS](https://polkadot.js.org/apps/) and [Contracts UI](https://contracts-ui.substrate.io/) and configure it to Local/Development Node
- Use sample ink! contracts from [auguth/ink-contracts-for-testing](https://github.com/auguth/ink-contracts-for-testing) 
- The examples below used [flipper contract](https://github.com/auguth/ink-contracts-for-testing/blob/main/flipper.contract). 
- For more advanced testing & scrutiny, use [flipper](https://github.com/auguth/ink-contracts-for-testing/blob/main/flipper.contract) and [caller](https://github.com/auguth/ink-contracts-for-testing/blob/main/caller.contract) contracts to test automated `stake_score` update across delegate-calls between contracts.

1. **Deploying Contracts**

    1. Upload a contract e.g., [flipper contract](https://github.com/auguth/ink-contracts-for-testing) using [Contracts UI](https://contracts-ui.substrate.io/)
    2. This uses function [instantiate_with_code()](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/struct.Pallet.html#method.instantiate_with_code) 

    ![instnatiate_with_code() Flowdiagram](/assets/img/instantiate_with_code().jpeg)

    3. [instantiate_with_code()](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/struct.Pallet.html#method.instantiate_with_code) calls the [bond()](https://auguth.github.io/pocs/target/doc/pallet_staking/dispatchables/fn.bond.html) function in pallet-staking to bond the contract deployer address with default `stake_score`.
    
        ![Instantiate_with_code()](/assets/gifs/instantiate_with_code().gif)

    4. After deployment, should expect events - [AccountStakeinfoevent](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/enum.Event.html#variant.AccountStakeinfoevent) & [ContractStakeinfoevent](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/enum.Event.html#variant.ContractStakeinfoevent)  with its default values
    
        ![Instantiate_with_code() events](/assets/gifs/instantiate_with_code()-events.gif)

    5. In Validator List (alias nominator), the deployer address will be added
    
        ![Deployer as Nominator](/assets/gifs/deployer_as_nominator.gif)

2. **Executing Contracts**

    ![run() Flowdiagram](/assets/img/run().jpeg)

    1. When executing contract [bond_extra()](https://auguth.github.io/pocs/target/doc/pallet_staking/dispatchables/fn.bond_extra.html) function is additionally called to increment the new `stake_score`

    2. This emits [ContractStakeinfoevent](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/enum.Event.html#variant.ContractStakeinfoevent) 
    3. In validator list of bonds, the `stake_score` will be reflected
    
        ![Execute bond_extra()](/assets/gifs/execute_bond_extra().gif)

3. **Updating Delegate Info**

    1. Construct an extrinsic via `contracts` pallet with [update_delegate()](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/dispatchables/fn.update_delegate.html) function 
    
    ![update_delegate() Flowdiagram](/assets/img/update_delegate().jpeg)

    2. [update_delegate()](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/dispatchables/fn.update_delegate.html) calls [nominate()](https://auguth.github.io/pocs/target/doc/pallet_staking/dispatchables/fn.nominate.html) and [new_unbond()](https://auguth.github.io/pocs/target/doc/pallet_staking/struct.Pallet.html#method.new_unbond) in pallet-staking to purge the `stake_score` (existing bond value) and nominate
  
        ![Update_delegate()](/assets/gifs/update_delegate().gif)
    
    3. In [AccountStakeinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.AccountStakeinfo.html), `delegateTo` and `delegateAt` will be updated and in [ContractScarcityinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.ContractScarcityInfo.html), the `stake_score` will be updated to 0 reflected in the validator list of bonds to zero. 
    
        ![Unbond events](/assets/gifs/unbond-events.gif)

    4. Can be verified that `delegateTo` address would be under waiting for nomination until `stake_score` updates and increases the bond value. 
    
        ![Update_delegate() Validator List](/assets/gifs/update_delegate()-validator-list.gif)

## Alternate Testing Methods

- The below two methods using Docker, can build and run a node shortly without requiring node specific dependencies, but unit & benchmarking tests cannot be verified.
- Regardless of the choice of any method, [front-end tests](#test-using-front-end) can be conducted

**Docker Compose** (Method 1)

1. Build & Run using Docker Compose:
    
      ```bash
      docker compose up --build -d
      ```
2. To Stop container
      ```bash
      docker compose down
      ```
3. To Restart the container
      ```
      docker compose up
      ```

      Works in all hosts (Linux/Mac/Windows).

**Docker Pull** (Method 2)

1. Install Latest [Docker Engine](https://docs.docker.com/engine/install/)
2. Pull Docker Image
    
   ```bash
   docker image pull jobyreuben/pocs-node:w3f_m2
   ```
      
3. Run a Docker Container.

   ```bash
   docker run --network="host" --rm jobyreuben/pocs-node:w3f_m2
   ``` 
   Local Host will only be available to Linux Hosts using `--network="host"` flag

## Commit History

Commit History is documented for in-depth valuation of PoCS specific modifications to the [substrate-stencil template](https://github.com/kaichaosun/substrate-stencil) for w3f-grant-reviewers.

**Milestone 3**

TBD

**Milestone 2**

Milestone 2 is published in [PR #29](https://github.com/auguth/pocs/pull/29)

1. Pallet Staking Codebase ( [3c5181c](https://github.com/auguth/pocs/pull/29/commits/3c5181ce3948913439085b316a4a0c79a589e542) ) 
2. Stake Score Addition ( [54a2e36](https://github.com/auguth/pocs/pull/29/commits/54a2e3607d5861ea65162383f28bea5b5a3873a6) ) 
3. `new_unbond()` fn added to pallet-staking ( [ba84bd8](https://github.com/auguth/pocs/pull/29/commits/ba84bd87042304a9c9914d4dd616806af052f8ee) )
4. `pallet-staking` Integration with `pallet-contracts` ( [9f908a4](https://github.com/auguth/pocs/pull/29/commits/9f908a41974f7b76e7365dca6dcd76faef48eccf) )
5. Minimum Bond Requirement removed & stake score calculation fixed ( [691def7](https://github.com/auguth/pocs/pull/29/commits/691def75deb847388d46f882ea15a3728139e002) ) 
6. Pallet Staking Bug Fixes ( [0d51e27f](https://github.com/auguth/pocs/pull/29/commits/0d51e27f6a0cf1775d62ab7f8955896f3a1b16dc) ) 
7. Pallet Contracts Tests Error Fix ( [1317f67](https://github.com/auguth/pocs/pull/29/commits/1317f67d4bf4c32dfd4e807906e34df8b0eedf0a) ) 
8. Pallet Staking Tests Removed ( [44f2fc4](https://github.com/auguth/pocs/pull/29/commits/44f2fc49285706dbeee1e1b8b698c40554160ee4) ) 
9.  Pallet Contracts Weight Adjustment ( [0619df4](https://github.com/auguth/pocs/pull/29/commits/0619df44f9c59f3352814408f0ce783030850be2) )
10. Fn `update_delegate()` Weight Adjustment ( [1e64910](https://github.com/auguth/pocs/pull/29/commits/1e64910a7fe213ca9efad12b32e5704c43512c66) )

**Milestone 1**

1. Pallet Contracts External ([ PR#2 ](https://github.com/auguth/pocs/pull/2))
2. Add Custom Pallet Contract ( [PR#3 ](https://github.com/auguth/pocs/pull/3))
3. pallet_contract 4-dev v1.0.0 ([ PR#4 ](https://github.com/auguth/pocs/pull/4))
4. POCS contract information structs added ([ PR#5 ](https://github.com/auguth/pocs/pull/5))
5. pallet contract pocs integration fn & maps added ([ PR#6 ](https://github.com/auguth/pocs/pull/6))
6. added gasstakeinfo ([ PR#7 ](https://github.com/auguth/pocs/pull/7))
7. Stake score updation on contract runtime ([ PR#8 ](https://github.com/auguth/pocs/pull/8))
8. Tight Coupling - I ([ PR#9 ](https://github.com/auguth/pocs/pull/9))
9. Tight coupling - II ([ PR#10 ](https://github.com/auguth/pocs/pull/10))
10. PoCS Test ([ PR#11 ](https://github.com/auguth/pocs/pull/11))
11. Github CI ([ PR#12 ](https://github.com/auguth/pocs/pull/12))
12. Test Preparation - I ([ PR#13 ](https://github.com/auguth/pocs/pull/13))
13. Tests Error Fixed ([ PR#14 ](https://github.com/auguth/pocs/pull/14))
14. PoCS Tests ([ PR#15 ](https://github.com/auguth/pocs/pull/15))
15. Added tests for `accountStake` and `update_delegate()` ([ PR#16 ](https://github.com/auguth/pocs/pull/16))
16. Test Preparation - II ([ PR#17 ](https://github.com/auguth/pocs/pull/17))
17. `test.rs` ContractAddressNotFount errors fixed ([ PR#18 ](https://github.com/auguth/pocs/pull/18))
18. Benchmark storage ([ PR#19 ](https://github.com/auguth/pocs/pull/19))
19. Docker addition ([ PR#26 ](https://github.com/auguth/pocs/pull/26))
20. Docker Compose ([ PR#27 ](https://github.com/auguth/pocs/pull/27))
