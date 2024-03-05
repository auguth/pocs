# Testing Guidelines for PoCS

> The testing guide is provided for Milestone-2 PoCS W3F Grant Delivery

[pallet-staking](https://auguth.github.io/pocs/target/doc/pallet_staking/index.html) has been integrated into [pallet-contracts](https://auguth.github.io/pocs/target/doc/pallet_contracts/index.html) to enable Proof of Contract Stake (PoCS) functionality with [Parity's](https://parity.io) Nominated Proof of Stake (NPoS). By following these steps, developers/reviewers can verify the correctness and reliability of the implemented features.

**Table of Contents**

- [Testing Guidelines for PoCS](#testing-guidelines-for-pocs)
  - [How PoCS Works](#how-pocs-works)
  - [Test Locally](#test-locally)
  - [Test Using Front-End](#test-using-front-end)
  - [Alternate Testing Methods](#alternate-testing-methods)

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
2. Checkout to W3F Milestone 2 Branch
   ```bash
   git clone https://github.com/auguth/pocs
   ```   
3. Run the Rust Setup Script
   ```bash
   chmod +x setup.sh && ./setup.sh
   ```
4. Run Unit Tests (Optional)

    pallets used : `pallet-contracts`, `pallet_staking`

   ```bash
   cargo test -p [pallet-name]
   ``` 
5. Run Benchmarking Tests (Optional)
   ```bash
   cargo test -p [pallet-name] --features=runtime-benchmarks
   ``` 
6. Build the project in release mode
   
   ```bash
   cargo build --release
   ```
7. Run the executable with the specified configuration:
   
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

