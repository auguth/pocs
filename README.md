# Proof of Contract Stake (W3F Grant Project)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![Substrate version](https://img.shields.io/badge/Substrate-2.0.0-brightgreen?logo=Parity%20Substrate)](https://substrate.dev/) ![Cargo doc](https://github.com/auguth/pocs/actions/workflows/doc.yml/badge.svg?branch=master) ![Build & Test](https://github.com/auguth/pocs/actions/workflows/build.yml/badge.svg?branch=master)

## Abstract

Proof of Contract Stake (PoCS) is a staking system utilizing contract gas history introducing **code-mining** by incentivizing developers to secure the network. Contracts’ stake scores depend on age, reputation, and gas use, deterring collusion attacks. Further information on PoCS Protocol Design are detailed in the [PoCS Research Page](https://jobyreuben.in/JOURNALS/pocs)

## Substrate Implementation

This [Substrate](https://substrate.io) Node is an adaptation of the [substrate-stencil](https://github.com/kaichaosun/substrate-stencil) to integrate PoCS protocol, which includes modified [pallet_contracts](https://auguth.github.io/pocs/target/doc/pallet_contracts/index.html) and [pallet_staking](https://auguth.github.io/pocs/target/doc/pallet_staking/) that supports Contract Staking Feature interoperable with current Substrate **NPoS-BABE-GRANDPA** public node infrastructure. 

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
5.  Use [Polkadot-JS-App](https://polkadot.js.org/apps/) and [Contracts UI](https://contracts-ui.substrate.io/) to interact with the Node. Refer to [Testing Guide.md](/TESTING-GUIDE.md) for extended information.

## External Links

1. [Litepaper]()
2. [Yellowpaper](/formal-spec/pocs-yellowpaper.pdf)
3. [PoCS Research Paper](https://jobyreuben.in/JOURNALS/pocs)
4. [Alpha Testing Documentation](/alpha/README.md)
5. [W3F Grant Application](https://github.com/w3f/Grants-Program/blob/master/applications/PoCS.md)
   1. [Milestone 1](https://github.com/w3f/Grant-Milestone-Delivery/blob/master/deliveries/pocs-milestone_1.md), [Milestone 1 Evaluation](https://github.com/w3f/Grant-Milestone-Delivery/blob/master/evaluations/pocs_1_keeganquigley.md) by [Keegan | W3F](https://github.com/keeganquigley), [Milestone 1 Branch Archive](https://github.com/auguth/pocs/tree/w3f_milestone_1)
   2. [Milestone 2](), [Milestone 2 Evaluation]() by [Piet | W3F](https://github.com/PieWol), [Milestone 2 Branch Archive]()
   3. [Milestone 3](), [Milestone 3 Evaluation]() by [Name | W3F]() , [Milestone 3 Branch Archive]()

## Acknowledgment

Sincere Thanks to the [Web3 Foundation](https://web3.foundation) for their vital [grant](https://grants.web3.foundation/applications/PoCS) support, enabling the progress of PoCS Substrate Implementation project.
