#!/bin/bash

set -e

assert_int() {
    if [ "$1" -ne "$2" ]; then
        echo "$CHAIN_EXT Tests Failed"
        kill $NODE_PID
    else 
        echo "$3 Passed"
    fi
}


NODE_PATH="./solo-substrate-chain/target/release/pocs"
CONTRACTS_PATH="./ink-contracts/contracts-bundle"
FLIPPER_CONTRACT="$CONTRACTS_PATH/flipper.contract"
CHAIN_EXT_CONTRACT="$CONTRACTS_PATH/delegate_at.contract"
CHAIN_EXT_NAME="delegate_at"
CHAIN_EXT_FUNCTION="fetch_delegate_at"

cd ../..

if [[ ! -f "$FLIPPER_CONTRACT" || ! -f "$CHAIN_EXT_CONTRACT" ]]; then
    echo -e "Contract Bundles are Missing"
    echo "Do you wish to build Contract Bundles for Running ink! E2E Tests? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        echo "Proceding to build Contracts Bundles..."
        chmod +x pocs.sh && ./pocs.sh --build --contracts
    else
        echo "Exiting Tests..."
        exit 1
    fi
fi

$NODE_PATH --dev > /dev/null 2>&1 &

NODE_PID=$!

spinner() {
    local pid=$1
    local delay=0.1
    local spin_chars=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

    while kill -0 $pid 2>/dev/null; do
        for char in "${spin_chars[@]}"; do
            echo -ne "\r$char PoCS-Substrate node starting..."
            sleep $delay
        done
    done
}

sleep 10 & spinner $!

echo "Running tests for $CHAIN_EXT_NAME" 


INSTANTIATE_FLIPPER=$(
    cargo contract instantiate \
    --suri //Alice \
    --execute \
    --skip-confirm \
    --output-json \
    "$FLIPPER_CONTRACT" 2>/dev/null \
)

CONTRACT_ADDRESS=$(echo "$INSTANTIATE_FLIPPER" | jq -r '.contract')

if [ -z "$CONTRACT_ADDRESS" ] || [ "$CONTRACT_ADDRESS" == "null" ]; then
    echo "[-] Failed to instantiate the contract."
    kill $NODE_PID
    exit 1
fi

FLIPPER_BLOCK_HASH=$(echo "$INSTANTIATE_FLIPPER" | jq -r '.block_hash')

FLIPPER_BLOCK_NUMBER_HEX=$(
    curl -s -H "Content-Type: application/json" -d \
    '{"jsonrpc":"2.0","id":1,"method":"chain_getBlock"}' \
    http://localhost:9944 | jq -r '.result.block.header.number'
)
FLIPPER_BLOCK_NUMBER=$((16#${FLIPPER_BLOCK_NUMBER_HEX#0x}))

INSTANTIATE_CHAIN_EXT=$(
    cargo contract instantiate \
    --suri //Alice \
    --execute \
    --skip-confirm \
    --output-json \
    "$CHAIN_EXT_CONTRACT" 2>/dev/null \
)

CHAIN_EXT_ADDRESS=$(echo "$INSTANTIATE_CHAIN_EXT" | jq -r '.contract')

if [ -z "$CHAIN_EXT_ADDRESS" ] || [ "$CHAIN_EXT_ADDRESS" == "null" ]; then
    echo "Failed to instantiate '$CHAIN_EXT_NAME' Chain Extension Contract."
    kill $NODE_PID
    exit 1
fi

CHAIN_EXT_BLOCK_HASH=$(echo "$INSTANTIATE_CHAIN_EXT" | jq -r '.block_hash')

CHAIN_EXT_BLOCK_NUMBER_HEX=$(
    curl -s -H "Content-Type: application/json" -d \
    '{"jsonrpc":"2.0","id":1,"method":"chain_getBlock"}' \
    http://localhost:9944 | jq -r '.result.block.header.number'
)
CHAIN_EXT_BLOCK_NUMBER=$((16#${CHAIN_EXT_BLOCK_NUMBER_HEX#0x}))

CHAIN_EXT_OUTPUT_1=$(
    cargo contract call \
    --suri //Bob \
    --url ws://localhost:9944 \
    --contract "$CHAIN_EXT_ADDRESS" \
    --message "$CHAIN_EXT_FUNCTION" \
    --args "$CONTRACT_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$CHAIN_EXT_CONTRACT" 2>/dev/null \
)

RESULT_1=$(echo "$CHAIN_EXT_OUTPUT_1" | jq -r '.data.Tuple.values[0].Tuple.values[0].UInt')

CHAIN_EXT_OUTPUT_2=$(
    cargo contract call \
    --suri //Bob \
    --url ws://localhost:9944 \
    --contract "$CHAIN_EXT_ADDRESS" \
    --message "$CHAIN_EXT_FUNCTION" \
    --args "$CHAIN_EXT_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$CHAIN_EXT_CONTRACT" 2>/dev/null \
)

RESULT_2=$(echo "$CHAIN_EXT_OUTPUT_2" | jq -r '.data.Tuple.values[0].Tuple.values[0].UInt')

assert_int "$RESULT_1" "$FLIPPER_BLOCK_NUMBER" "instantiated_contract_delegate_at_chain_extension_works"
assert_int "$RESULT_2" "$CHAIN_EXT_BLOCK_NUMBER" "delegate_at_chain_extension_on_itself_works"

kill $NODE_PID
