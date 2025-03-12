#!/bin/bash

set -e  

cargo_clean() {
    local contract_path=$1
    local contract_name=$2

    echo "cleaning $contract_path"
    cd $contract_path
    cargo clean

}

declare -A contracts=(
    ["ink-contracts/chain_extensions/delegate_at"]="delegate_at"
    ["ink-contracts/chain_extensions/delegate_to"]="delegate_to"
    ["ink-contracts/chain_extensions/reputation"]="reputation"
    ["ink-contracts/chain_extensions/stake_score"]="stake_score"
    ["ink-contracts/delegate_registry"]="delegate_registry"
    ["ink-contracts/extras/flipper"]="flipper"
    ["ink-contracts/extras/simple_caller"]="simple_caller"
)

for path in "${!contracts[@]}"; do
    cargo_clean "$path" "${contracts[$path]}"
done

echo "Cleaning solo-substrate-chain"
cd solo-substrate-chain
cargo clean
cd ..

echo "Cleaning process completed!"
