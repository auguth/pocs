# ink-contracts

These are ink-contracts provided for PoCS Substrate Node Testing 

Contracts are pre-built and provided as `.contract` file in its respective source directories which can be uploaded via an extrinsic call to `pallet-contract` via `instantiate_with_code`

## Ink! Environment Setup

Ensure your development environment meets the following requirements:

- Rust & C++ Compiler:

    In addition to Rust, installation requires a C++ compiler that supports C++17. Modern releases of gcc and clang, as well as Visual Studio 2019+, should work.

**Installation Steps:**

1. Install Rust Source:

    ``` rust
    rustup component add rust-src
    ```

2. Install `cargo-contract`:

    ``` rust
    cargo install --force --locked cargo-contract
    ```

3. To build and deploy:

    - Run the setup script if applicable:

        ``` rust
        chmod +x setup.sh && ./setup.sh
        ```

    - Open contract folder

    - Build the contract in release mode using cargo-contract:

        ``` rust
        cargo contract build --release
        ```

    - Deploy the contract to your local or test network using the Polkadot-JS-App or Contracts UI:

4. To Run Test:

    ```rust
    cargo test
    ```

