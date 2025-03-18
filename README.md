# PoCS - Proof of Contract Stake (v0.1 Experimental)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Substrate version](https://img.shields.io/badge/Substrate-2.0.0-brightgreen?logo=Parity%20Substrate)](https://substrate.dev/) ![Node Build](https://github.com/auguth/pocs/actions/workflows/node_build.yml/badge.svg?branch=master)![Contract Build](https://github.com/auguth/pocs/actions/workflows/contracts_build.yml/badge.svg?branch=master)


## Documents

| Document        | Description                                     |Link                  | 
|-----------------|-------------------------------------------------|----------------------|
|Litepaper        | Conceptual overview of the PoCS protocol        |[pocs-litepaper.pdf](litepaper/pocs-litepaper.pdf) |
|Research Model   | In-depth technical design and theoretical model |[pocs-research.pdf](research-model/pocs-research.pdf)|
|Specification    | Detailed system architecture and implementation |[pocs-spec.pdf](specification/pocs-spec.pdf)|


## PoCS-Substrate Node

### Prerequisites

Ensure your system meets the following requirements:

- Linux, macOS, or Windows (with `winget` or `choco` package managers).
- Bash shell environment.
- `curl`, `cargo`, and `rustup` installed.
- Sufficient disk space for Substrate and Ink! builds.

#### Initial Setup

Before using the script, ensure it has execution permissions:

```bash
chmod +x pocs.sh
```

### Usage

#### Build

To build the Ink! contracts or the PoCS Substrate node:

```bash
./pocs.sh --build --contracts
./pocs.sh --build --node
```

#### Test

To run tests for Ink! contracts or the PoCS Substrate node:

```bash
./pocs.sh --test --contracts
./pocs.sh --test --node
```

#### Run

To start the PoCS Substrate node:

```bash
./pocs.sh --run
```

#### Clean

To clean the build artifacts and environment:

```bash
./pocs.sh --clean --contracts
./pocs.sh --clean --node
```

### Actions and Targets

| Action     | Target      | Description                                |
|------------|-------------|--------------------------------------------|
| `--build`  | `--contracts`| Build all Ink! contracts and bundle them.  |
|            | `--node`    | Build the PoCS Substrate node.             |
| `--test`   | `--contracts`| Run all Ink! contract tests and E2E tests. |
|            | `--node`    | Run tests for the PoCS Substrate node.     |
| `--run`    |             | Start the PoCS Substrate node.             |
| `--clean`  | `--contracts`| Clean all Ink! contract artifacts.         |
|            | `--node`    | Clean Substrate node build and targets |


## Acknowledgment
Sincere Thanks to the [Web3 Foundation](https://web3.foundation/) for their vital grant support, enabling the progress of PoCS Substrate Implementation project. For project application details, visit the [PoCS W3F Grant Application](https://grants.web3.foundation/applications/PoCS)