#!/bin/bash

set -e 

run_script() {
    local script_name=$1

    if [ ! -f "$script_name" ]; then
        echo "❌ Error: $script_name not found!"
        exit 1
    fi

    echo "🚀 Running $script_name"
    chmod +x "$script_name" && ./$script_name

    echo "✅ $script_name completed successfully."

    read -p "➡️  Do you want to proceed to the next script? (y/n): " choice
    case "$choice" in
        [yY]*) return 0 ;;
        *) echo "❌ Aborting."; exit 1 ;;
    esac
}

run_script "test.sh"
run_script "build.sh"

echo "🚀 Starting Substrate node"
cd solo-substrate-chain
./target/release/pocs --dev

echo "🎉 All scripts executed successfully!"
