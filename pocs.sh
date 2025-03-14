#!/bin/bash
 
set -e
 
action=$1
target=$2
 
CONTRACTS_DIR="ink-contracts"
DEPLOY_DIR="contracts-bundle"
NODE_DIR="solo-substrate-chain"
ENV_FLAG=".setup"

show_spinner() {
    local pid=$1
    local delay=0.1
    local spin_chars=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

    echo -n "⏳ Waiting for the node to start..."
    while kill -0 $pid 2>/dev/null; do
        for char in "${spin_chars[@]}"; do
            echo -ne "\r$char ⏳ Waiting for the PoCS-Substrate node to start..."
            sleep $delay
        done
    done
    echo -ne "\r✅ PoCS-Substrate Node is ready!\n"
}


detect_os() {
    case "$(uname -s)" in
        Linux*) OS="Linux" ;;
        Darwin*) OS="MacOS" ;;
        MINGW*|MSYS*|CYGWIN*) OS="Windows" ;;
        *) OS="Unknown" ;;
    esac
}
 
install_dependencies() {
 
    detect_os
    echo "🛠️ Detected OS: $OS"
 
    if [ "$OS" = "Linux" ]; then
        echo "Updating packages..."  
        sudo apt-get update
        echo "Installing required dependencies..."  
        sudo apt-get install --assume-yes build-essential clang curl libssl-dev protobuf-compiler
    elif [ "$OS" = "MacOS" ]; then
        echo "Updating Homebrew..."  
        brew update
        echo "Installing required dependencies..."  
        brew install curl protobuf
    elif [ "$OS" = "Windows" ]; then
        echo "Installing dependencies for Windows..."
        if command -v winget &>/dev/null; then
            winget install -e --id Rustlang.Rustup
            winget install -e --id GNU.Make
        elif command -v choco &>/dev/null; then
            choco install rustup.install -y
            choco install make -y
        else
            echo "Error: No suitable package manager found (winget/choco)"
            exit 1
        fi
    else
        echo "Unsupported operating system: $OS"
        exit 1
    fi
}
 
setup_contract_environment() {
    if [ ! -f "$ENV_FLAG" ]; then
        echo "Setting up the Ink! contract environment..."
 
        install_dependencies
 
        echo "Installing Rust using rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source $HOME/.cargo/env
 
        echo "Setting default Rust version to stable..."
        rustup default stable
 
        echo "Installing cargo-contract..."
        cargo install cargo-contract --force
 
        touch "$ENV_FLAG"
    fi
}
 
setup_node_environment() {
    if [ ! -f "$ENV_FLAG" ]; then
        echo "Setting up the Substrate node environment..."
        install_dependencies
 
        echo "Installing Rust using rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source $HOME/.cargo/env
 
        echo "Setting default Rust version to stable..."
        rustup default stable
 
        echo "Installing specific nightly version..."
        rustup install nightly-2023-12-21
 
        echo "Adding WebAssembly target for nightly version..."
        rustup target add wasm32-unknown-unknown --toolchain nightly-2023-12-21
 
        echo "Setting nightly version as override..."
        rustup override set nightly-2023-12-21
 
        touch "$ENV_FLAG"
    fi
}
 
build_contracts() {
    for contract in *; do
        if [ -d "$contract" ] && [ "$(basename "$contract")" != "$DEPLOY_DIR" ];  then
            echo "Building Ink! contract "$contract"..."
            (cd "$contract" && cargo contract build)
 
            contract_file=$(find "$contract/target/ink" -name "*.contract" 2>/dev/null)
            if [ -n "$contract_file" ]; then
                if [ ! -d "$DEPLOY_DIR" ]; then
                    echo "Creating deployment directory..."
                    mkdir -p "$DEPLOY_DIR"
                fi
                echo "Moving $(basename "$contract_file") to $DEPLOY_DIR"
                cp "$contract_file" "$DEPLOY_DIR"
            fi
        fi
    done
}
 
build_node() {
    echo "Building PoCS Substrate node"
    cargo build --release
}

test_e2e(){
    if [ -f "test.sh" ]; then 
       chmod +x test.sh && ./test.sh
    fi
}
 
test_contracts() {
    # for contract in *; do
    #     if [ -d "$contract" ] && [ "$(basename "$contract")" != "$DEPLOY_DIR" ]; then
    #         echo "Testing Ink! contract "$contract"..."
    #         (cd "$contract" && cargo test)
    #         echo "Do you wish to continue to next cargo test? (y/n)"
    #         read -r answer

    #         if [[ "$answer" =~ ^[Yy]$ ]]; then
    #             echo "Proceeding to the next test..."
    #         else
    #             echo "Exiting Tests..."
    #             exit 1
    #         fi
    #     fi
    # done
    # echo "All Cargo Test for Contracts are completed, Proceeding to E2E Tests"
    (   
        cd ../
        if [ ! -f "./$NODE_DIR/target/release/pocs" ]; then
            echo -e "Node Build Targets are missing"
            echo "Do you wish to build PoCS-Substrate Node for Running ink! E2E Tests? (y/n)"
            read -r answer
            if [[ "$answer" =~ ^[Yy]$ ]]; then
                echo "Proceeding to build PoCS-Substrate Node..."
                ./pocs.sh --build --node
            else
                echo "Exiting Tests..."
                exit 1
            fi                                                                                                            
        fi
        if [ ! -d "./$CONTRACTS_DIR/$DEPLOY_DIR-bundle" ];  then
            echo -e "Contract Bundles are Missing"
            echo "Do you wish to build Contract Bundles for Running ink! E2E Tests? (y/n)"
            read -r answer
            if [[ "$answer" =~ ^[Yy]$ ]]; then
                echo "Proceding to build Contracts Bundles..."
                ./pocs.sh --build --contracts
            else
                echo "Exiting Tests..."
                exit 1
            fi
        fi
    )
    for contract in *; do
        if [ -d "$contract" ] && [ "$(basename "$contract")" != "$DEPLOY_DIR" ]; then
            echo "Do you wish to run E2E-Tests on $contract Ink! contract? (y/n)"
            read -r answer
            if [[ "$answer" =~ ^[Yy]$ ]]; then
                echo "Proceeding to run E2E-Tests on $contract Ink! contract..."
                (cd "$contract" && test_e2e)
            else
                echo "Exiting Tests..."
                exit 1
            fi
        fi
    done
    echo "All E2E Tests for Contracts are completed"
}
 
test_node() {
    echo "Testing Substrate node..."
    cargo test --all
}
 
run_node() {
    if [ ! -f "./target/release/pocs" ]; then
        echo -e "Node Build Targets are missing"
        echo "Do you wish to build PoCS-Substrate Node? (y/n)"
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo "Proceding to build PoCS-Substrate Node..."
            cd ../
            ./pocs.sh --build --node
        else
            echo "Exiting Run Node..."
            exit 1
        fi
    fi
 
    echo "Starting Substrate node..."
    ./target/release/pocs --dev
}
 
clean_contracts() {
    for contract in *; do
        if [ -d "$contract" ] && [ "$(basename "$contract")" != "$DEPLOY_DIR" ]; then
            echo "️Cleaning Ink! contract "$contract"..."
            (cd "$contract" && cargo clean)
        fi
    done
}
 
clean_built_contracts(){
    if [ -d "$DEPLOY_DIR" ]; then
        rm -rf "$DEPLOY_DIR"
        echo "Removed $DEPLOY_DIR"
    fi
}
 
clean_node() {
    echo "Cleaning Substrate node..."
    cargo clean
}
 
clean_env(){
    if [ -f "$ENV_FLAG" ]; then
        rm "$ENV_FLAG"
        echo "Removed $ENV_FLAG"
    fi
}
 
case $action in
    --build)
        case $target in
            --contracts)
                cd $CONTRACTS_DIR
                setup_contract_environment
                build_contracts
                ;;
            --node)
                cd $NODE_DIR
                setup_node_environment
                build_node
                ;;
            *)
                echo "Usage: $0 --build {--contracts|--node}"
                exit 1
                ;;
        esac
        ;;
 
    --test)
        case $target in
            --contracts)
                cd $CONTRACTS_DIR
                setup_contract_environment
                test_contracts
                ;;
            --node)
                cd $NODE_DIR
                setup_node_environment
                test_node
                ;;
            *)
                echo "Usage: $0 --test {--contracts|--node}"
                exit 1
                ;;
        esac
        ;;
 
    --run)
        cd $NODE_DIR
        run_node
        ;;
 
    --clean)
        case $target in
            --contracts)
                cd $CONTRACTS_DIR
                clean_contracts
                clean_env
                clean_built_contracts
                ;;
            --node)
                cd $NODE_DIR
                clean_node
                clean_env
                ;;
            *)
                echo "Usage: $0 --clean {--contracts|--node}"
                exit 1
                ;;
        esac
        ;;
 
    *)
        echo "Usage: $0 {--build|--test|--run|--clean} {--contracts|--node}"
        exit 1
        ;;
esac
 