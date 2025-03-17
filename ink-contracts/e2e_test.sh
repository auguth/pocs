#!/bin/bash

# Colors
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Test Counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Assert If Value is not Nil
assert_not_nil() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -n "$2 ... "  
    if [ -z "$1" ]; then
        echo -e "${RED}FAILED${RESET}"
        echo -e "${RED}assertion failed${RESET}: Expected a non-nil value, but got empty or null.\n"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    else 
        echo -e "${GREEN}ok${RESET} \n"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    fi
}

# Assert Integer Equality
assert_int() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -n "$3 ... "  
    if [ "$1" -ne "$2" ]; then
        echo -e "${RED}FAILED${RESET}"
        echo -e "${RED}assertion failed${RESET}: \n left: ${GREEN}$1${RESET},\n right: ${RED}$2${RESET} \n"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    else 
        echo -e "${GREEN}ok${RESET} \n"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    fi
}

# Assert String Equality
assert_str() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -n "$3 ... "
    if [ "$1" != "$2" ]; then
        echo -e "${RED}FAILED${RESET}"
        echo -e "${RED}assertion failed${RESET}: \n left: ${GREEN}$1${RESET},\n right: ${RED}$2${RESET} \n"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    else 
        echo -e "${GREEN}ok${RESET} \n"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    fi
}

# Assert $1 > $2
assert_greater() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -n "$3 ... "  
    if [ "$1" -le "$2" ]; then
        echo -e "${RED}FAILED${RESET}"
        echo -e "${RED}assertion failed${RESET}: \n left: ${GREEN}$1${RESET} (expected greater than),\n right: ${RED}$2${RESET} \n"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    else 
        echo -e "${GREEN}ok${RESET} \n"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    fi
}

# Final Test Summary (to be called at the end of the script)
test_summary() {
    echo -e "Test results: ${GREEN}$PASSED_TESTS${RESET} passed; ${RED}$FAILED_TESTS${RESET} failed; total $TOTAL_TESTS\n"
    if [ "$FAILED_TESTS" -eq 0 ]; then
        echo -e "${GREEN}All tests passed successfully.${RESET}\n"
    else
        echo -e "${RED}Some tests failed.${NONE}\n"
    fi
}

# Dev Mode Alice AccountId 
ALICE="5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY"

# Node Binary Execution File
NODE_PATH="./solo-substrate-chain/target/release/pocs"

# Contracts Bundle Path
CONTRACTS_PATH="./ink-contracts/contracts-bundle"

# Go to Root
cd ../

if [ ! -f "./solo-substrate-chain/target/release/pocs" ]; then
    echo -e "Node Build Targets are missing"
    echo "Do you wish to build PoCS-Substrate Node? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        chmod +x pocs.sh && ./pocs.sh --build --node
    else
        echo "Exiting Run Node..."
        exit 1
    fi
fi

# Flipper Contract is used for dummy contract testing
FLIPPER_CONTRACT="$CONTRACTS_PATH/flipper.contract"

# Flip Function of Flipper Contract
FLIPPER_FUNCTION="flip"

# Tests if Flipper is missing
if [ ! -f "$FLIPPER_CONTRACT" ]; then
    echo "Contract Bundles Missing on $FLIPPER_CONTRACT"
    echo "Do you wish to build Contract Bundles for Running ink! E2E Tests? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        chmod +x pocs.sh && ./pocs.sh --build --contracts
        echo -e "Ready to Run E2E Tests for Contracts"
    else
        echo -e "Exiting Tests..."
        kill $NODE_PID
        exit 1
    fi
fi


# Run PoCS-Substrate Node
$NODE_PATH --dev > /dev/null 2>&1 &

# Get Node Process Id
NODE_PID=$!

# Spinner animation
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

    echo -ne "\r\033[K"  
}

# Sleep until node is prepared
sleep 10 & spinner $!

echo "Starting ink! E2E Tests..."

#### UPLOAD FLIPPER CONTRACT

# Upload Flipper Contract and Get Code Hash
UPLOAD_FLIPPER=$(
    cargo contract upload \
    --suri //Alice \
    --execute \
    --skip-confirm \
    --output-json \
    "$FLIPPER_CONTRACT" 2>/dev/null \
)

# Extract Flipper Code Hash for Instantiating via Update Delegate Contract
FLIPPER_CODEHASH=$(echo "$UPLOAD_FLIPPER" | jq -r '.code_hash')


##### INSTANTIATE UPDATE DELEGATE CONTRACT

# Update Delegate Contract (Includes Contract Deployment and Update Delegate Chain Extension)
UPDATE_DELEGATE_CONTRACT="$CONTRACTS_PATH/update_delegate.contract"
UPDATE_DELEGATE_FUNCTION="update_delegate"
DEPLOY_FUNCTION="deploy_contract"
UPDATE_OWNER_FUNCTION="update_owner"

# Tests if Update Delegate Contract is missing
if [ ! -f "$UPDATE_DELEGATE_CONTRACT" ]; then
    echo "Contract Bundles Missing on $UPDATE_DELEGATE_CONTRACT"
    echo "Do you wish to build Contract Bundles for Running ink! E2E Tests? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        chmod +x pocs.sh && ./pocs.sh --build --contracts
        echo -e "Ready to Run E2E Tests for Contracts"
    else
        echo -e "Exiting Tests..."
        kill $NODE_PID
        exit 1
    fi
fi

# Instantiate Update Delegate Contract for Testing
INSTANTIATE_UPDATE_DELEGATE=$(
    cargo contract instantiate \
    --suri //Alice \
    --execute \
    --skip-confirm \
    --output-json \
    "$UPDATE_DELEGATE_CONTRACT" 2>/dev/null \
)

UPDATE_DELEGATE_ADDRESS=$(echo "$INSTANTIATE_UPDATE_DELEGATE" | jq -r '.contract')


#### INSTANTIATE FLIPPER VIA UPDATE DELEGATE deploy_contract()

# Salt for Deployment
SALT=$((RANDOM % 100))

# Deploying Flipper via calling Update Delegate Contract deploy_contract() message call
DEPLOY_FLIPPER=$(
    cargo contract call \
    --suri //Bob \
    --contract "$UPDATE_DELEGATE_ADDRESS" \
    --message "$DEPLOY_FUNCTION" \
    --execute \
    --args "$FLIPPER_CODEHASH" "$SALT" \
    --skip-confirm \
    --output-json \
    "$UPDATE_DELEGATE_CONTRACT" 2>/dev/null \
)

# Get Flipper Contract Instantiation Block Number (For Assertion)
INSTANTIATE_FLIPPER_BLOCK_NUM=$((16#$(curl -s -H "Content-Type: application/json" -d \
    '{"jsonrpc":"2.0","id":1,"method":"chain_getBlock"}' \
    http://localhost:9944 | jq -r '.result.block.header.number | ltrimstr("0x")')))


# Extract Flipper Address
FLIPPER_ADDRESS=$(echo "$DEPLOY_FLIPPER" | jq -r '.[] | select(.pallet=="Contracts" and .name=="Instantiated") | .fields[] | select(.name=="contract") | .value.Literal')

# Assertion
assert_not_nil "$FLIPPER_ADDRESS" "update_delegate_upload_code_hash_message_works"

# Dry Instantiate Flipper Contract - Instantiate without executing extrinsic onchain 
DRY_INSTANTIATE_FLIPPER=$(
    cargo contract instantiate \
    --suri //Bob \
    --skip-confirm \
    --output-json \
    "$FLIPPER_CONTRACT" 2>/dev/null \
)

# Get Dry Flipper Contract Address
DRY_FLIPPER_ADDRESS=$(echo "$DRY_INSTANTIATE_FLIPPER" | jq -r '.contract')


#### INSTANTIATE DELEGATE AT CONTRACT 

# Delegate At Contract
DELEGATE_AT_CONTRACT="$CONTRACTS_PATH/delegate_at.contract"
DELEGATE_AT_FUNCTION="fetch_delegate_at"

# Tests if Delegate At Contract is missing
if [ ! -f "$DELEGATE_AT_CONTRACT" ]; then
    echo "Contract Bundles Missing on $DELEGATE_AT_CONTRACT"
    echo "Do you wish to build Contract Bundles for Running ink! E2E Tests? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        chmod +x pocs.sh && ./pocs.sh --build --contracts
        echo -e "Ready to Run E2E Tests for Contracts"
    else
        echo -e "Exiting Tests..."
        kill $NODE_PID
        exit 1
    fi
fi

# Instantiate Delegate At Contract for Testing
INSTANTIATE_DELEGATE_AT=$(
    cargo contract instantiate \
    --suri //Alice \
    --execute \
    --skip-confirm \
    --output-json \
    "$DELEGATE_AT_CONTRACT" 2>/dev/null \
)

# Get Delegate At Contract Instantiation Block Number (For Assertion)
INSTANTIATE_DELEGATE_AT_BLOCK_NUM=$((16#$(curl -s -H "Content-Type: application/json" -d \
    '{"jsonrpc":"2.0","id":1,"method":"chain_getBlock"}' \
    http://localhost:9944 | jq -r '.result.block.header.number | ltrimstr("0x")')))


# Get Delegate At Contract Address
DELEGATE_AT_ADDRESS=$(echo "$INSTANTIATE_DELEGATE_AT" | jq -r '.contract')

# Call Delegate At Contract, expects error
CALL_DELEGATE_AT=$(
    cargo contract call \
    --suri //Bob \
    --contract "$DELEGATE_AT_ADDRESS" \
    --message "$DELEGATE_AT_FUNCTION" \
    --args "$ALICE" \
    --skip-confirm \
    --output-json \
    "$DELEGATE_AT_CONTRACT" 2>&1\
)

# Clear Warnings from Call Result
CLEAN_WARNINGS=$(echo "$CALL_DELEGATE_AT" | sed -n '/^{/,$p')

# Extract Error Result as String
DELEGATE_AT_NON_CONTRACT_RESULT=$(echo "$CLEAN_WARNINGS" | jq -r '.module_error.error // "No error found"')

# Expected Error Result Assign 
NO_STAKE_ERROR="NoStakeExists"

# Assertion
assert_str "$DELEGATE_AT_NON_CONTRACT_RESULT" "$NO_STAKE_ERROR" "delegate_at_chain_extension_returns_error_for_eoa"

# Call Delegate At Contract , Delegate At Function
CALL_DELEGATE_AT=$(
    cargo contract call \
    --suri //Bob \
    --contract "$DELEGATE_AT_ADDRESS" \
    --message "$DELEGATE_AT_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$DELEGATE_AT_CONTRACT" 2>/dev/null \
)

# Extract Unsigned Integer Value Returned by Calling Delegate At 
FLIPPER_DELEGATE_AT_RESULT=$(echo "$CALL_DELEGATE_AT" | jq -r '.data.Tuple.values[0].Tuple.values[0].UInt')

# Assertion
assert_int "$FLIPPER_DELEGATE_AT_RESULT" "$INSTANTIATE_FLIPPER_BLOCK_NUM" "delegate_at_chain_extension_works_on_instantiated_contract_"

# Call Delegate At Contract
CALL_DELEGATE_AT=$(
    cargo contract call \
    --suri //Bob \
    --contract "$DELEGATE_AT_ADDRESS" \
    --message "$DELEGATE_AT_FUNCTION" \
    --args "$DELEGATE_AT_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$DELEGATE_AT_CONTRACT" 2>/dev/null \
)

# Extract Unsigned Integer Value Returned by Calling Delegate At 
DELEGATE_AT_ITSELF_RESULT=$(echo "$CALL_DELEGATE_AT" | jq -r '.data.Tuple.values[0].Tuple.values[0].UInt')

# Assertion
assert_int "$DELEGATE_AT_ITSELF_RESULT" "$INSTANTIATE_DELEGATE_AT_BLOCK_NUM" "delegate_at_chain_extension_on_itself_works"

# Call Delegate At
CALL_DELEGATE_AT=$(
    cargo contract call \
    --suri //Bob \
    --contract "$DELEGATE_AT_ADDRESS" \
    --message "$DELEGATE_AT_FUNCTION" \
    --args "$DRY_FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$DELEGATE_AT_CONTRACT" 2>&1\
)

# Clear Warnings from Call Result
CLEAN_WARNINGS=$(echo "$CALL_DELEGATE_AT" | sed -n '/^{/,$p')

# Extract Error Result as String
DELEGATE_AT_DRY_CONTRACT_RESULT=$(echo "$CLEAN_WARNINGS" | jq -r '.module_error.error // "No error found"')

# Assertion
assert_str "$DELEGATE_AT_DRY_CONTRACT_RESULT" "$NO_STAKE_ERROR" "delegate_at_chain_extension_returns_error_for_non_instantiated_contract"

#### INSTANTIATE REPUTATION CONTRACT

# Reputation Contract to be tested
REPUTATION_CONTRACT="$CONTRACTS_PATH/reputation.contract"
# Message call of target contract to be tested
REPUTATION_FUNCTION="fetch_reputation"

# Tests if Reputation Contract is missing
if [ ! -f "$REPUTATION_CONTRACT" ]; then
    echo "Contract Bundles Missing on $REPUTATION_CONTRACT"
    echo "Do you wish to build Contract Bundles for Running ink! E2E Tests? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        chmod +x pocs.sh && ./pocs.sh --build --contracts
        echo -e "Ready to Run E2E Tests for Contracts"
    else
        echo -e "Exiting Tests..."
        kill $NODE_PID
        exit 1
    fi
fi

# Instantiate Reputation Contract for Testing
INSTANTIATE_REPUTATION=$(
    cargo contract instantiate \
    --suri //Alice \
    --execute \
    --skip-confirm \
    --output-json \
    "$REPUTATION_CONTRACT" 2>/dev/null \
)

# Get Reputation Contract Address
REPUTATION_ADDRESS=$(echo "$INSTANTIATE_REPUTATION" | jq -r '.contract')

# Call Reputation Contract, expects error
CALL_REPUTATION=$(
    cargo contract call \
    --suri //Bob \
    --contract "$REPUTATION_ADDRESS" \
    --message "$REPUTATION_FUNCTION" \
    --args "$ALICE" \
    --skip-confirm \
    --output-json \
    "$REPUTATION_CONTRACT" 2>&1\
)

# Clear Warnings from Call Result
CLEAN_WARNINGS=$(echo "$CALL_REPUTATION" | sed -n '/^{/,$p')

# Extract Error Result as String
REPUTATION_NON_CONTRACT_RESULT=$(echo "$CLEAN_WARNINGS" | jq -r '.module_error.error // "No error found"')

# Expected Error Result Assign 
NO_STAKE_ERROR="NoStakeExists"

# Assertion
assert_str "$REPUTATION_NON_CONTRACT_RESULT" "$NO_STAKE_ERROR" "reputation_chain_extension_returns_error_for_eoa"

# Call Reputation Contract 
CALL_REPUTATION=$(
    cargo contract call \
    --suri //Bob \
    --contract "$REPUTATION_ADDRESS" \
    --message "$REPUTATION_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$REPUTATION_CONTRACT" 2>/dev/null \
)

# Extract Unsigned Integer Value Returned by Calling Reputation 
FLIPPER_REPUTATION_RESULT=$(echo "$CALL_REPUTATION" | jq -r '.data.Tuple.values[0].Tuple.values[0].UInt')

# Instantiation Reputation 
REPUTATION=1

# Assertion
assert_int "$FLIPPER_REPUTATION_RESULT" "$REPUTATION" "reputation_chain_extension_on_just_instantiated_contract_works"

# Call Reputation
CALL_REPUTATION=$(
    cargo contract call \
    --suri //Bob \
    --contract "$REPUTATION_ADDRESS" \
    --message "$REPUTATION_FUNCTION" \
    --args "$DRY_FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$REPUTATION_CONTRACT" 2>&1\
)

# Clear Warnings from Call Result
CLEAN_WARNINGS=$(echo "$CALL_REPUTATION" | sed -n '/^{/,$p')

# Extract Error Result as String
REPUTATION_DRY_CONTRACT_RESULT=$(echo "$CLEAN_WARNINGS" | jq -r '.module_error.error // "No error found"')

# Assertion
assert_str "$REPUTATION_DRY_CONTRACT_RESULT" "$NO_STAKE_ERROR" "reputation_chain_extension_returns_error_for_non_instantiated_contract"

#### INSTANTIATE STAKE SCORE CONTRACT

# Stake Score Contract to be tested
STAKE_SCORE_CONTRACT="$CONTRACTS_PATH/stake_score.contract"
# Message call of target contract to be tested
STAKE_SCORE_FUNCTION="fetch_stake_score"

# Tests if Stake Score Contract is missing
if [ ! -f "$STAKE_SCORE_CONTRACT" ]; then
    echo "Contract Bundles Missing on $STAKE_SCORE_CONTRACT"
    echo "Do you wish to build Contract Bundles for Running ink! E2E Tests? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        chmod +x pocs.sh && ./pocs.sh --build --contracts
        echo -e "Ready to Run E2E Tests for Contracts"
    else
        echo -e "Exiting Tests..."
        kill $NODE_PID
        exit 1
    fi
fi

# Instantiate Stake Score Contract for Testing
INSTANTIATE_STAKE_SCORE=$(
    cargo contract instantiate \
    --suri //Alice \
    --execute \
    --skip-confirm \
    --output-json \
    "$STAKE_SCORE_CONTRACT" 2>/dev/null \
)

# Get Stake Score Contract Address
STAKE_SCORE_ADDRESS=$(echo "$INSTANTIATE_STAKE_SCORE" | jq -r '.contract')


# Call Stake Score Contract , Stake Score Function
CALL_STAKE_SCORE=$(
    cargo contract call \
    --suri //Bob \
    --contract "$STAKE_SCORE_ADDRESS" \
    --message "$STAKE_SCORE_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$STAKE_SCORE_CONTRACT" 2>/dev/null \
)

# Extract Unsigned Integer Value Returned by Calling Stake Score 
FLIPPER_STAKE_SCORE_RESULT=$(echo "$CALL_STAKE_SCORE" | jq -r '.data.Tuple.values[0].Tuple.values[0].UInt')

# Instantiation Stake Score 
STAKE_SCORE=0

# Assertion
assert_int "$FLIPPER_STAKE_SCORE_RESULT" "$STAKE_SCORE" "stake_score_chain_extension_on_just_instantiated_contract_works"

# Waiting for New Block to Submit Transaction due to reputation increment conditions
sleep 5

# Call Flipper Contract
CALL_FLIPPER=$(
    cargo contract call \
    --suri //Alice \
    --execute \
    --contract "$FLIPPER_ADDRESS" \
    --message "$FLIPPER_FUNCTION" \
    --skip-confirm \
    --output-json \
    "$FLIPPER_CONTRACT"  2>/dev/null\
)

# Increase Reputation since a call is made
((REPUTATION++))

# Call Reputation Contract 
CALL_REPUTATION=$(
    cargo contract call \
    --suri //Bob \
    --contract "$REPUTATION_ADDRESS" \
    --message "$REPUTATION_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$REPUTATION_CONTRACT" 2>/dev/null \
)

# Extract Unsigned Integer Value Returned by Calling Reputation 
FLIPPER_REPUTATION_RESULT=$(echo "$CALL_REPUTATION" | jq -r '.data.Tuple.values[0].Tuple.values[0].UInt')

# Assertion
assert_int "$FLIPPER_REPUTATION_RESULT" "$REPUTATION" "reputation_chain_extension_works_after_calls_to_dummy"


# Call Stake Score Contract
CALL_STAKE_SCORE=$(
    cargo contract call \
    --suri //Bob \
    --contract "$STAKE_SCORE_ADDRESS" \
    --message "$STAKE_SCORE_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$STAKE_SCORE_CONTRACT" 2>/dev/null \
)

# Extract Unsigned Integer Value Returned by Calling Stake Score 
FLIPPER_STAKE_SCORE_RESULT=$(echo "$CALL_STAKE_SCORE" | jq -r '.data.Tuple.values[0].Tuple.values[0].UInt')

# Assertion
assert_int "$FLIPPER_STAKE_SCORE_RESULT" "$STAKE_SCORE" "stake_score_chain_extension_no_update_after_call_before_delegation_works"

# Call Stake Score Contract, expects error
CALL_STAKE_SCORE=$(
    cargo contract call \
    --suri //Bob \
    --contract "$STAKE_SCORE_ADDRESS" \
    --message "$STAKE_SCORE_FUNCTION" \
    --args "$ALICE" \
    --skip-confirm \
    --output-json \
    "$STAKE_SCORE_CONTRACT" 2>&1\
)

# Clear Warnings from Call Result
CLEAN_WARNINGS=$(echo "$CALL_STAKE_SCORE" | sed -n '/^{/,$p')

# Extract Error Result as String
STAKE_SCORE_NON_CONTRACT_RESULT=$(echo "$CLEAN_WARNINGS" | jq -r '.module_error.error // "No error found"')

# Expected Error Result Assign 
NO_STAKE_ERROR="NoStakeExists"

# Assertion
assert_str "$STAKE_SCORE_NON_CONTRACT_RESULT" "$NO_STAKE_ERROR" "stake_score_chain_extension_returns_error_for_eoa"

# Call Stake Score, Expect Error
CALL_STAKE_SCORE=$(
    cargo contract call \
    --suri //Bob \
    --contract "$STAKE_SCORE_ADDRESS" \
    --message "$STAKE_SCORE_FUNCTION" \
    --args "$DRY_FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$STAKE_SCORE_CONTRACT" 2>&1\
)

# Clear Warnings from Call Result
CLEAN_WARNINGS=$(echo "$CALL_STAKE_SCORE" | sed -n '/^{/,$p')

# Extract Error Result as String
STAKE_SCORE_DRY_CONTRACT_RESULT=$(echo "$CLEAN_WARNINGS" | jq -r '.module_error.error // "No error found"')

# Assertion
assert_str "$STAKE_SCORE_DRY_CONTRACT_RESULT" "$NO_STAKE_ERROR" "stake_score_chain_extension_returns_error_for_non_instantiated_contract"

#### INSTANTIATE DELEGATE TO CONTRACT

# Delegate To Contract to be tested
DELEGATE_TO_CONTRACT="$CONTRACTS_PATH/delegate_to.contract"
# Message call of delegate to contract to be tested
DELEGATE_TO_FUNCTION="fetch_delegate_to"

# Tests if Delegate To Contract is missing
if [ ! -f "$DELEGATE_TO_CONTRACT" ]; then
    echo "Contract Bundles Missing on $DELEGATE_TO_CONTRACT"
    echo "Do you wish to build Contract Bundles for Running ink! E2E Tests? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        chmod +x pocs.sh && ./pocs.sh --build --contracts
        echo -e "Ready to Run E2E Tests for Contracts"
    else
        echo -e "Exiting Tests..."
        kill $NODE_PID
        exit 1
    fi
fi

# Instantiate Delegate To Contract for Testing
INSTANTIATE_DELEGATE_TO=$(
    cargo contract instantiate \
    --suri //Alice \
    --execute \
    --skip-confirm \
    --output-json \
    "$DELEGATE_TO_CONTRACT" 2>/dev/null \
)

# Get Delegate To Contract Address
DELEGATE_TO_ADDRESS=$(echo "$INSTANTIATE_DELEGATE_TO" | jq -r '.contract')

# Call Delegate To Contract
CALL_DELEGATE_TO=$(
    cargo contract call \
    --suri //Bob \
    --contract "$DELEGATE_TO_ADDRESS" \
    --message "$DELEGATE_TO_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$DELEGATE_TO_CONTRACT" 2>/dev/null \
)

# Extract AccountId
FLIPPER_DELEGATE_TO_RESULT=$(echo "$CALL_DELEGATE_TO" | jq -r '.data.Tuple.values[0].Tuple.values[0].Literal')

assert_str "$FLIPPER_DELEGATE_TO_RESULT" "$UPDATE_DELEGATE_ADDRESS" "delegate_to_chain_extension__works_before_delegation"

#### INSTANTIATE Owner CONTRACT

# Owner Contract to be tested
OWNER_CONTRACT="$CONTRACTS_PATH/owner.contract"
# Message call of Owner contract to be tested
OWNER_FUNCTION="fetch_owner"

# Tests if Owner Contract is missing
if [ ! -f "$OWNER_CONTRACT" ]; then
    echo "Contract Bundles Missing on $OWNER_CONTRACT"
    echo "Do you wish to build Contract Bundles for Running ink! E2E Tests? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        chmod +x pocs.sh && ./pocs.sh --build --contracts
        echo -e "Ready to Run E2E Tests for Contracts"
    else
        echo -e "Exiting Tests..."
        kill $NODE_PID
        exit 1
    fi
fi

# Instantiate Owner Contract for Testing
INSTANTIATE_OWNER=$(
    cargo contract instantiate \
    --suri //Alice \
    --execute \
    --skip-confirm \
    --output-json \
    "$OWNER_CONTRACT" 2>/dev/null \
)

# Get Owner Contract Address
OWNER_ADDRESS=$(echo "$INSTANTIATE_OWNER" | jq -r '.contract')

# Call Owner Contract
CALL_OWNER=$(
    cargo contract call \
    --suri //Bob \
    --contract "$OWNER_ADDRESS" \
    --message "$OWNER_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$OWNER_CONTRACT" 2>/dev/null \
)

# Extract AccountId
FLIPPER_OWNER_RESULT=$(echo "$CALL_OWNER" | jq -r '.data.Tuple.values[0].Tuple.values[0].Literal')

assert_str "$FLIPPER_OWNER_RESULT" "$UPDATE_DELEGATE_ADDRESS" "owner_chain_extension_works_before_delegation"

# Call Flipper Contract To attain Minimum Reputation
CALL_FLIPPER=$(
    cargo contract call \
    --suri //Alice \
    --execute \
    --contract "$FLIPPER_ADDRESS" \
    --message "$FLIPPER_FUNCTION" \
    --skip-confirm \
    --output-json \
    "$FLIPPER_CONTRACT"  2>/dev/null\
)

# Increase Reputation since a call is made
((REPUTATION++))

# Update Delegate of Flipper to Dry Flipper
UPDATE_DELEGATE_FLIPPER=$(
    cargo contract call \
    --suri //Alice \
    --execute \
    --contract "$UPDATE_DELEGATE_ADDRESS" \
    --message "$UPDATE_DELEGATE_FUNCTION" \
    --args "$FLIPPER_ADDRESS" "$DRY_FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$UPDATE_DELEGATE_CONTRACT"  2>/dev/null\
)

# Extract Flipper Address
DELEGATED_ADDRESS=$(echo "$UPDATE_DELEGATE_FLIPPER" | jq -r '.[] | select(.pallet=="Contracts" and .name=="Delegated") | .fields[] | select(.name=="delegate_to") | .value.Literal')

# Assertion
assert_str "$DELEGATED_ADDRESS" "$DRY_FLIPPER_ADDRESS" "update_delegate_chain_extension_works"

# Sleep for Reputation Criteria - New Block
sleep 5

# Call Flipper Contract
CALL_FLIPPER=$(
    cargo contract call \
    --suri //Alice \
    --execute \
    --contract "$FLIPPER_ADDRESS" \
    --message "$FLIPPER_FUNCTION" \
    --skip-confirm \
    --output-json \
    "$FLIPPER_CONTRACT"  2>/dev/null\
)

# Increase Reputation since a call is made
((REPUTATION++))

# Call Reputation Contract 
CALL_REPUTATION=$(
    cargo contract call \
    --suri //Bob \
    --contract "$REPUTATION_ADDRESS" \
    --message "$REPUTATION_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$REPUTATION_CONTRACT" 2>/dev/null \
)

# Extract Unsigned Integer Value Returned by Calling Reputation 
FLIPPER_REPUTATION_RESULT=$(echo "$CALL_REPUTATION" | jq -r '.data.Tuple.values[0].Tuple.values[0].UInt')

# Assertion
assert_int "$FLIPPER_REPUTATION_RESULT" "$REPUTATION" "reputation_chain_extension_works_after_update_delegate_done"

# Call Stake Score Contract
CALL_STAKE_SCORE=$(
    cargo contract call \
    --suri //Bob \
    --contract "$STAKE_SCORE_ADDRESS" \
    --message "$STAKE_SCORE_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$STAKE_SCORE_CONTRACT" 2>/dev/null \
)

# Extract Unsigned Integer Value Returned by Calling Stake Score 
FLIPPER_STAKE_SCORE_RESULT=$(echo "$CALL_STAKE_SCORE" | jq -r '.data.Tuple.values[0].Tuple.values[0].UInt')

# Assertion
assert_greater "$FLIPPER_STAKE_SCORE_RESULT" "$STAKE_SCORE" "stake_score_chain_extension_updates_after_update_delegate_works"

# Call Owner Contract
CALL_OWNER=$(
    cargo contract call \
    --suri //Bob \
    --contract "$OWNER_ADDRESS" \
    --message "$OWNER_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$OWNER_CONTRACT" 2>/dev/null \
)

# Extract AccountId
FLIPPER_OWNER_RESULT=$(echo "$CALL_OWNER" | jq -r '.data.Tuple.values[0].Tuple.values[0].Literal')

# Assertion
assert_str "$FLIPPER_OWNER_RESULT" "$UPDATE_DELEGATE_ADDRESS" "owner_chain_extension_unchanged_after_delegation"

# Call Delegate To Contract
CALL_DELEGATE_TO=$(
    cargo contract call \
    --suri //Bob \
    --contract "$DELEGATE_TO_ADDRESS" \
    --message "$DELEGATE_TO_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$DELEGATE_TO_CONTRACT" 2>/dev/null \
)

# Extract AccountId
FLIPPER_DELEGATE_TO_RESULT=$(echo "$CALL_DELEGATE_TO" | jq -r '.data.Tuple.values[0].Tuple.values[0].Literal')

# Assertion
assert_str "$FLIPPER_DELEGATE_TO_RESULT" "$DRY_FLIPPER_ADDRESS" "delegate_to_chain_extension__works_after_delegation"

# Call Delegate To Contract, expects error
CALL_DELEGATE_TO=$(
    cargo contract call \
    --suri //Bob \
    --contract "$DELEGATE_TO_ADDRESS" \
    --message "$DELEGATE_TO_FUNCTION" \
    --args "$ALICE" \
    --skip-confirm \
    --output-json \
    "$DELEGATE_TO_CONTRACT" 2>&1\
)

# Clear Warnings from Call Result
CLEAN_WARNINGS=$(echo "$CALL_DELEGATE_TO" | sed -n '/^{/,$p')

# Extract Error Result as String
DELEGATE_TO_NON_CONTRACT_RESULT=$(echo "$CLEAN_WARNINGS" | jq -r '.module_error.error // "No error found"')

# Expected Error Result Assign 
NO_STAKE_ERROR="NoStakeExists"

# Assertion
assert_str "$DELEGATE_TO_NON_CONTRACT_RESULT" "$NO_STAKE_ERROR" "delegate_to_chain_extension_returns_error_for_eoa"

# Call Delegate To
CALL_DELEGATE_TO=$(
    cargo contract call \
    --suri //Bob \
    --contract "$DELEGATE_TO_ADDRESS" \
    --message "$DELEGATE_TO_FUNCTION" \
    --args "$DRY_FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$DELEGATE_TO_CONTRACT" 2>&1\
)

# Clear Warnings from Call Result
CLEAN_WARNINGS=$(echo "$CALL_DELEGATE_TO" | sed -n '/^{/,$p')

# Extract Error Result as String
DELEGATE_TO_DRY_CONTRACT_RESULT=$(echo "$CLEAN_WARNINGS" | jq -r '.module_error.error // "No error found"')

# Assertion
assert_str "$DELEGATE_TO_DRY_CONTRACT_RESULT" "$NO_STAKE_ERROR" "delegate_to_chain_extension_returns_error_for_non_instantiated_contract"

# Call Owner Contract, expects error
CALL_OWNER=$(
    cargo contract call \
    --suri //Bob \
    --contract "$OWNER_ADDRESS" \
    --message "$OWNER_FUNCTION" \
    --args "$ALICE" \
    --skip-confirm \
    --output-json \
    "$OWNER_CONTRACT" 2>&1\
)

# Clear Warnings from Call Result
CLEAN_WARNINGS=$(echo "$CALL_OWNER" | sed -n '/^{/,$p')

# Extract Error Result as String
OWNER_NON_CONTRACT_RESULT=$(echo "$CLEAN_WARNINGS" | jq -r '.module_error.error // "No error found"')

# Expected Error Result Assign 
NO_STAKE_ERROR="NoStakeExists"

# Assertion
assert_str "$OWNER_NON_CONTRACT_RESULT" "$NO_STAKE_ERROR" "owner_chain_extension_returns_error_for_eoa"

# Call Owner
CALL_OWNER=$(
    cargo contract call \
    --suri //Bob \
    --contract "$OWNER_ADDRESS" \
    --message "$OWNER_FUNCTION" \
    --args "$DRY_FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$OWNER_CONTRACT" 2>&1\
)

# Clear Warnings from Call Result
CLEAN_WARNINGS=$(echo "$CALL_OWNER" | sed -n '/^{/,$p')

# Extract Error Result as String
OWNER_DRY_CONTRACT_RESULT=$(echo "$CLEAN_WARNINGS" | jq -r '.module_error.error // "No error found"')

# Assertion
assert_str "$OWNER_DRY_CONTRACT_RESULT" "$NO_STAKE_ERROR" "owner_chain_extension_returns_error_for_non_instantiated_contract"



#### INSTANTIATE DELAGATE REGISTRY (VALIDATOR REWARD) CONTRACT

# Validator Contract to be tested
VALIDATOR_CONTRACT="$CONTRACTS_PATH/delegate_registry.contract"
# Message call of Validator contract to be tested
REGISTER_FUNCTION="register"
# Message call of Validator contract to be tested
CLAIM_FUNCTION="claim"
# Message call of Validator contract to be tested
CANCEL_FUNCTION="cancel"

# Tests if Owner Contract is missing
if [ ! -f "$VALIDATOR_CONTRACT" ]; then
    echo "Contract Bundles Missing on $VALIDATOR_CONTRACT"
    echo "Do you wish to build Contract Bundles for Running ink! E2E Tests? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        chmod +x pocs.sh && ./pocs.sh --build --contracts
        echo -e "Ready to Run E2E Tests for Contracts"
    else
        echo -e "Exiting Tests..."
        kill $NODE_PID
        exit 1
    fi
fi

# Instantiate Owner Contract for Testing
INSTANTIATE_VALIDATOR_CONTRACT=$(
    cargo contract instantiate \
    --suri //Bob \
    --execute \
    --value 10000000000000000 \
    --skip-confirm \
    --output-json \
    "$VALIDATOR_CONTRACT" 2>/dev/null \
)

# Get Owner Contract Address
VALIDATOR_ADDRESS=$(echo "$INSTANTIATE_VALIDATOR_CONTRACT" | jq -r '.contract')

# Call Validator Contract, Register From Non Owner as Signer, Expect Error
REGISTER_FROM_NON_OWNER=$(
    cargo contract call \
    --suri //Alice \
    --contract "$VALIDATOR_ADDRESS" \
    --message "$REGISTER_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$VALIDATOR_CONTRACT" 2>&1 \
)

# Clear Warnings from Call Result
CLEAN_WARNINGS=$(echo "$REGISTER_FROM_NON_OWNER" | sed -n '/^{/,$p')

# Extract Error Result of the recent call
ERROR_RESULT=$(echo "$CLEAN_WARNINGS" | jq -r '.data.Tuple.values[0].Tuple.values[0].Tuple.ident')

# Error for Non Owner trying to register a contract to validator contract
INVALID_CONTRACT_OWNER_ERROR="InvalidContractOwner"

# Assertion
assert_str "$ERROR_RESULT" "$INVALID_CONTRACT_OWNER_ERROR" "validator_contract_throws_error_on_non_owner_of_contract"

## Another Test Can be conducted by Calling Extrinsic to Expect an Error NotADelegate 
## Before invoking the upcoming call to update delegate to validator address of the flipper contract
## Since we are only testing contract based e2e tests once the owner is updated from Contract owner to Alice 
## an extrinsic has to be signed, These tests are covered in pallet contracts stake i.e., pocs tests and need not be asserted here

# Update Delegate of Flipper to Validator
UPDATE_DELEGATE_FLIPPER=$(
    cargo contract call \
    --suri //Alice \
    --execute \
    --contract "$UPDATE_DELEGATE_ADDRESS" \
    --message "$UPDATE_DELEGATE_FUNCTION" \
    --args "$FLIPPER_ADDRESS" "$VALIDATOR_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$UPDATE_DELEGATE_CONTRACT"  2>/dev/null\
)

# Extract Flipper Address
DELEGATED_ADDRESS=$(echo "$UPDATE_DELEGATE_FLIPPER" | jq -r '.[] | select(.pallet=="Contracts" and .name=="Delegated") | .fields[] | select(.name=="delegate_to") | .value.Literal')

# Assertion 
assert_str "$DELEGATED_ADDRESS" "$VALIDATOR_ADDRESS" "update_delegate_to_validator_reward_contract_works"

# Call Update Delegate to update owner of its owned account
UPDATE_OWNER_FLIPPER=$(
    cargo contract call \
    --suri //Alice \
    --execute \
    --contract "$UPDATE_DELEGATE_ADDRESS" \
    --message "$UPDATE_OWNER_FUNCTION" \
    --args "$FLIPPER_ADDRESS" "$ALICE" \
    --skip-confirm \
    --output-json \
    "$UPDATE_DELEGATE_CONTRACT" 2>/dev/null\
)

# Retrieve the Owner of Flipper Contract after Update Owner
NEW_OWNER_ADDRESS=$(echo "$UPDATE_OWNER_FLIPPER" | jq -r '.[] | select(.pallet=="Contracts" and .name=="StakeOwner") | .fields[] | select(.name=="new_owner") | .value.Literal')

# Assertion
assert_str "$NEW_OWNER_ADDRESS" "$ALICE" "update_owner_chain_extension_works"

# Call Validator Contract, Register Flipper which is now owned by Alice
REGISTER_FLIPPER=$(
    cargo contract call \
    --suri //Alice \
    --execute \
    --contract "$VALIDATOR_ADDRESS" \
    --message "$REGISTER_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$VALIDATOR_CONTRACT"  2>/dev/null\
)

# Retrieve the Extrinsic Success Output to check which contract is called
RECENTLY_CALLED_CONTRACT_ADDRESS=$(echo "$REGISTER_FLIPPER" | jq -r '.[] | select(.pallet == "Contracts" and .name == "Called") | .fields[] | select(.name == "contract") | .value.Literal')

# Assertion
assert_str "$RECENTLY_CALLED_CONTRACT_ADDRESS" "$VALIDATOR_ADDRESS" "validator_contract_register_delegate_successful"


# Call Flipper, Increase Stake Score 
CALL_FLIPPER=$(
    cargo contract call \
    --suri //Bob \
    --execute \
    --contract "$FLIPPER_ADDRESS" \
    --message "$FLIPPER_FUNCTION" \
    --skip-confirm \
    --output-json \
    "$FLIPPER_CONTRACT"  2>/dev/null\
)

sleep 5 

# Call Flipper, Increase Stake Score 
CALL_FLIPPER=$(
    cargo contract call \
    --suri //Bob \
    --execute \
    --contract "$FLIPPER_ADDRESS" \
    --message "$FLIPPER_FUNCTION" \
    --skip-confirm \
    --output-json \
    "$FLIPPER_CONTRACT"  2>/dev/null\
)

# Call Validator Contract, Claim Reward For Delegated Stake Score
CLAIM_REWARD=$(
    cargo contract call \
    --suri //Alice \
    --execute \
    --contract "$VALIDATOR_ADDRESS" \
    --message "$CLAIM_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$VALIDATOR_CONTRACT"  2>/dev/null\
)

# Retrieve the Transfer Outputs to Assert If Transfer From Reward Contract to Flipper is Successful
TRANSFER_FROM=$(echo "$CLAIM_REWARD" | jq -r '.[] | select(.pallet == "Balances" and .name == "Transfer") | .fields[] | select(.name == "from").value.Literal')

TRANSFER_TO=$(echo "$CLAIM_REWARD" | jq -r '.[] | select(.pallet == "Balances" and .name == "Transfer") | .fields[] | select(.name == "to").value.Literal')

# Assertion
if [ "$TRANSFER_FROM" == "$VALIDATOR_ADDRESS" ]; then
    assert_str "$TRANSFER_TO" "$ALICE" "validator_reward_claim_transfer_works"
else 
    assert_str "1" "0" "validator_reward_claim_transfer_works"
fi

# Call Validator Contract, Cancel Registration For Delegated Stake Score
CANCEL_REGISTRATION_FAILS=$(
    cargo contract call \
    --suri //Alice \
    --contract "$VALIDATOR_ADDRESS" \
    --message "$CANCEL_FUNCTION" \
    --args "$FLIPPER_ADDRESS" \
    --skip-confirm \
    --output-json \
    "$VALIDATOR_CONTRACT"  2>&1\
)

# Clear Warnings from Call Result
CLEAN_WARNINGS=$(echo "$CANCEL_REGISTRATION_FAILS" | sed -n '/^{/,$p')

# Extract Error Result of the recent call
ERROR_RESULT=$(echo "$CLEAN_WARNINGS" | jq -r '.data.Tuple.values[0].Tuple.values[0].Tuple.ident')

# Since No Calls to Flipper Made, There'll be No Stake Score Hence No Reward
NO_REWARD_ALLOCATED="NoRewardAllocated"

# Assertion
assert_str "$ERROR_RESULT" "$NO_REWARD_ALLOCATED" "validator_contract_claiming_throws_error_if_no_stake_score"

test_summary

kill $NODE_PID