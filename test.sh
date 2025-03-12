#!/bin/bash

set -e  

test_contract() {
    local contract_path=$1
    local contract_name=$2

    if [ ! -d "$contract_path" ]; then
        echo "❌ Error: Directory $contract_path does not exist."
        return 1
    fi

    echo "🧪 Testing $contract_path"
    cd "$contract_path"
    cargo test || echo "❌ Tests failed for $contract_name"
    cd - > /dev/null
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
    test_contract "$path" "${contracts[$path]}"
done

if [ -d "solo-substrate-chain" ]; then
    echo "🧪 Testing solo-substrate-chain"
    cd solo-substrate-chain
    cargo test --all || echo "❌ Tests failed for solo-substrate-chain"
    cd ..
else
    echo "❌ Error: Directory solo-substrate-chain does not exist."
fi

echo "✅ All tests completed!"
