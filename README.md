# Proof of Contract Stake (W3F Grant Project)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![Substrate version](https://img.shields.io/badge/Substrate-2.0.0-brightgreen?logo=Parity%20Substrate)](https://substrate.dev/) ![Cargo doc](https://github.com/auguth/pocs/actions/workflows/cargodoc.yml/badge.svg?branch=master) ![Build & Test](https://github.com/auguth/pocs/actions/workflows/rust.yml/badge.svg?branch=master)

## Abstract

Proof of Contract Stake (PoCS) is a staking system utilizing contract gas history introducing **code-mining** by incentivizing developers to secure the network. Contracts’ stake scores depend on age, reputation, and gas use, deterring collusion attacks. Further information on PoCS Protocol Design are detailed in the [PoCS Research Page](https://jobyreuben.in/JOURNALS/pocs)

## Substrate Implementation

This [Substrate](https://substrate.io) Node is an adaptation of the [substrate-stencil](https://github.com/kaichaosun/substrate-stencil) to integrate PoCS protocol, which includes modified [pallet_contracts](https://auguth.github.io/pocs/target/doc/pallet_contracts/index.html) and [pallet_staking](https://auguth.github.io/pocs/target/doc/pallet_staking/) that supports Contract Staking Feature interoperable with current Substrate **NPoS-BABE-GRANDPA** public node infrastructure. 

## PoCS Node Set-up

1. Clone the repository from GitHub:

   ```bash
   git clone https://github.com/auguth/pocs
   ```
2. Install essential tools and dependencies:
   ```bash
   sudo apt install build-essential clang curl

   sudo apt install --assume-yes git clang curl libssl-dev protobuf-compiler
   ```
3. Install Rust using rustup:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
   ```
4. Set the default Rust version to stable:
   ```bash
   rustup default stable
   ```
5. Install a specific nightly version of Rust:
   ```bash
   rustup install nightly-2023-12-21
   ```
6. Add a target for WebAssembly:
   ```bash
   rustup target add wasm32-unknown-unknown --toolchain nightly-2023-12-21
   ```
7. Set the nightly version as the default for this project:
   ```bash
   rustup override set nightly-2023-12-21
   ```
8. Build the project in release mode:
   
   ```bash
   cargo build --release
   ```
9. Run the executable with the specified configuration:
   
    ```bash
    ./target/release/pocs --dev
    ```
10. Use [Polkadot-JS-App](https://polkadot.js.org/apps/) and [Contracts UI](https://contracts-ui.substrate.io/) to interact with the Local Development only Node. Refer to [Tests](#tests) section

## Tests

Please refer to [TESTING-GUIDE.md](/TESTING-GUIDE.md) for extended details.

- To conduct manual tests using the front end check [Front End Test](/TESTING-GUIDE.md#test-using-front-end)
- To conduct unit & benchmarking tests check [Unit & Benchmarking Test](/TESTING-GUIDE.md#unit-tests--benchmarking-tests)

## Docker (Compose)
      
1.   Build & Run using Docker Compose:
    
      ```bash
      docker compose up --build -d
      ```
      To Stop container
      ```bash
      docker compose down
      ```
      To Restart the container
      ```
      docker compose up
      ```

      **Note:** Docker compose publishes ports, works in all hosts (Linux/Mac/Windows).

2. Use [Polkadot-JS-App](https://polkadot.js.org/apps/) and [Contracts UI](https://contracts-ui.substrate.io/) to interact with the Local Development only Node.

## Docker (Pull)

1. Install Latest [Docker Engine](https://docs.docker.com/engine/install/)
2. Pull Docker Image
    
   ```bash
   docker image pull jobyreuben/pocs-node:w3f_m2
   ```

3. List Docker Images:
    
   ```bash
   docker image ls
   ```
      
4. Run a Docker Container by specifying the Image ID that is recently pulled/built.

   ```bash
   docker run --network="host" --rm jobyreuben/pocs-node:w3f_m2
   ``` 
   **Note:** Local Host will only be available to Linux Hosts using `--network="host"` flag

5. Use [Polkadot-JS-App](https://polkadot.js.org/apps/) and [Contracts UI](https://contracts-ui.substrate.io/) to interact with the Local Development only Node. Refer to [Tests](#tests) section   

## Acknowledgment

Sincere Thanks to the [Web3 Foundation](https://web3.foundation) for their vital grant support, enabling the progress of PoCS Substrate Implementation project. For project application details, visit the [PoCS W3F Grant Application](https://grants.web3.foundation/applications/PoCS)
