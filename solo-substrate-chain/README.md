# Proof of Contract Stake (W3F Grant Project)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![Substrate version](https://img.shields.io/badge/Substrate-2.0.0-brightgreen?logo=Parity%20Substrate)](https://substrate.dev/) ![Cargo doc](https://github.com/auguth/pocs/actions/workflows/doc.yml/badge.svg?branch=master) ![Build & Test](https://github.com/auguth/pocs/actions/workflows/build.yml/badge.svg?branch=master)

## Abstract

Proof of Contract Stake (PoCS) is a staking system utilizing contract gas history introducing **code-mining** by incentivizing developers to secure the network. Contracts’ stake scores depend on age, reputation, and gas use, deterring collusion attacks. Further information on PoCS Protocol Design are detailed in the [PoCS Research Page](https://jobyreuben.in/JOURNALS/pocs)

## Substrate Implementation

This [Substrate](https://substrate.io) Node is an adaptation of the [substrate-stencil](https://github.com/kaichaosun/substrate-stencil) to integrate PoCS protocol, which includes modified [pallet_contracts](https://auguth.github.io/pocs/target/doc/pallet_contracts/index.html) and [pallet_staking](https://auguth.github.io/pocs/target/doc/pallet_staking/) that supports Contract Staking Feature interoperable with current Substrate **NPoS-BABE-GRANDPA** public node infrastructure. 

## Navigation

## Build & Run PoCS Node

1. Clone the repository from GitHub:

   ```bash
   git clone https://github.com/auguth/pocs
   ```

2. Run the Rust Setup Script

   ```bash
   chmod +x setup.sh && ./setup.sh
   ```

3. Build the project in release mode:
   
   ```bash
   cargo build --release
   ```
4. Run the executable with the specified configuration:
   
    ```bash
    ./target/release/pocs --dev
    ```
5.  Use [Polkadot-JS-App](https://polkadot.js.org/apps/) and [Contracts UI](https://contracts-ui.substrate.io/) to interact with the Node. 

**Docker Compose**

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


## Acknowledgment

Sincere Thanks to the [Web3 Foundation](https://web3.foundation) for their vital grant support, enabling the progress of PoCS Substrate Implementation project. For project application details, visit the [PoCS W3F Grant Application](https://grants.web3.foundation/applications/PoCS)

## How PoCS Works

- Developers deploy smart contracts with `stake_score` i.e., bond value.
- `stake_score` derived from contract execution time (refTime) and reputation.

    ![Flow Chart](https://www.plantuml.com/plantuml/png/RP0nKyCm38Lt_uetfXjpCj03rdQW1oirYPhgSAHSf1JuzwHfQtgzJfRjzpr9RsaU1n-x5EOYb9jkEl2iuaEitH0DJofD5NY7OiN2tTZXbVhHexCALkIF2_YU1CKlsI80vH6W1dKseSGjVoQ2AqGxbkXK1U3ekJxV4V4U4pVHTRXr1Cet8sp7VlgcZuOIjLDHBBQW7nzOZEjgrbrF-NAMsRqXPzFSq32lZyFfWQKzsL4oGY5wZwYZY6Q4pe0ql0ktOBbM72vaJc0AzG9a-PtuSgV_v4vGkV7uHR1Q1q8_3YqPNF60x-EYbv2QgyxrFigageAvzc4vsOnT-WC0)

- Developers nominate a validator using `delegate()` extrinsic.
- Bonded contracts need minimum reputation to nominate.
- `min_reputation` is set at 10 for development, adjustable.
- `stake_score` purges to 0 when contract's delegated validator changes.
- Validators need minimum delegates (nominators i.e., bonded contracts) to start validating.
- `min_delegates` set at 3 for development, adjustable.


## Test Using Front-End

> This is an optional extended test to check correctness of PoCS via `pallet_contracts` extrinsics on front-end, without attempting staking feature via `pallet_staking`

- Use [Polkadot-JS](https://polkadot.js.org/apps/) and [Contracts UI](https://contracts-ui.substrate.io/) and configure it to Local/Development Node
- Use sample ink! contracts from [auguth/ink-contracts-for-testing](https://github.com/auguth/ink-contracts-for-testing) 
- The examples below used [flipper contract](https://github.com/auguth/ink-contracts-for-testing/blob/main/flipper.contract). 
- For more advanced testing & scrutiny, use [flipper](https://github.com/auguth/ink-contracts-for-testing/blob/main/flipper.contract) and [caller](https://github.com/auguth/ink-contracts-for-testing/blob/main/caller.contract) contracts to test automated `stake_score` update across delegate-calls between contracts.

After running the executable, the following tests using front-end can be done to verify the correctness mentioned in [How PoCS Work](#how-pocs-works) Section.

- Use [Polkadot-JS](https://polkadot.js.org/apps/) and [Contracts UI](https://contracts-ui.substrate.io/) and configure it to Local/Development Node
- Use sample ink! contracts from [auguth/ink-contracts-for-testing](https://github.com/auguth/ink-contracts-for-testing) 
- The examples below used [flipper contract](https://github.com/auguth/ink-contracts-for-testing/blob/main/flipper.contract). 
- For more advanced testing & scrutiny, use [flipper](https://github.com/auguth/ink-contracts-for-testing/blob/main/flipper.contract) and [caller](https://github.com/auguth/ink-contracts-for-testing/blob/main/caller.contract) contracts to test automated `stake_score` update across delegate-calls between contracts.

1. **Deploying Contracts**

    1. Upload a contract e.g., [flipper contract](https://github.com/auguth/ink-contracts-for-testing) using [Contracts UI](https://contracts-ui.substrate.io/)
    2. This uses function [instantiate_with_code()](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/struct.Pallet.html#method.instantiate_with_code) 
    3. [instantiate_with_code()](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/struct.Pallet.html#method.instantiate_with_code) calls the [bond()](https://auguth.github.io/pocs/target/doc/pallet_staking/dispatchables/fn.bond.html) function in pallet-staking to bond the contract deployer address with default `stake_score`.
    4. After deployment, should expect events - [AccountStakeinfoevent](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/enum.Event.html#variant.AccountStakeinfoevent) & [ContractStakeinfoevent](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/enum.Event.html#variant.ContractStakeinfoevent)  with its default values

2. **Executing Contracts**

    1. When executing contract [bond_extra()](https://auguth.github.io/pocs/target/doc/pallet_staking/dispatchables/fn.bond_extra.html) function is additionally called to increment the new `stake_score`
    2. This emits [ContractStakeinfoevent](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/enum.Event.html#variant.ContractStakeinfoevent) 
    3. In validator list of bonds, the `stake_score` will be reflected

3. **Nominating a Validator after minimum reputation achieved**

    1. Construct an extrinsic via `contracts` pallet with [update_delegate()](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/dispatchables/fn.update_delegate.html) function 
    2. [update_delegate()](https://auguth.github.io/pocs/target/doc/pallet_contracts/pallet/dispatchables/fn.update_delegate.html) calls [nominate()](https://auguth.github.io/pocs/target/doc/pallet_staking/dispatchables/fn.nominate.html) and [new_unbond()](https://auguth.github.io/pocs/target/doc/pallet_staking/struct.Pallet.html#method.new_unbond) in pallet-staking to purge the `stake_score` (existing bond value) and ensures if the contract has required minimum reputation to nominate
    3. In [AccountStakeinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.AccountStakeinfo.html), `delegateTo` and `delegateAt` will be updated and in [ContractScarcityinfo](https://auguth.github.io/pocs/target/doc/pallet_contracts/gasstakeinfo/struct.ContractScarcityInfo.html), the `stake_score` will be updated to 0 reflected in the validator list of bonds to zero.
