# Proof of Contract Stake (W3F Grant Project)

## Substrate Implementation

This [Substrate](https://substrate.io) Node is an adaptation of the [substrate-stencil](https://github.com/kaichaosun/substrate-stencil) to integrate PoCS protocol, which includes modified [pallet_contracts](https://auguth.github.io/pocs/target/doc/pallet_contracts/index.html) and [pallet_staking](https://auguth.github.io/pocs/target/doc/pallet_staking/) that supports Contract Staking Feature interoperable with current Substrate **NPoS-BABE-GRANDPA** public node infrastructure. 


## Build & Run PoCS Node using `pocs.sh`

### Actions and Targets

| Action     | Target      | Description                                |
|------------|-------------|--------------------------------------------|
| `--build`  | `--node`    | Build the PoCS Substrate node.             |
|            |             |                                            |
| `--test`   | `--node`    | Run tests for the PoCS Substrate node.     |
|            |             |                                            |
| `--run`    |             | Start the PoCS Substrate node.             |
|            |             |                                            |
| `--clean`  | `--node`    | Clean Substrate node build and targets |


#### Initial Setup

Before using the script, ensure it has execution permissions:

```bash
chmod +x pocs.sh
```

### Usage

2. Build the nide in `--release` mode

   ```bash
   ./pocs.sh --node --build
   ```

4. Run the executable

    ```bash
    ./pocs.sh --node --run
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


