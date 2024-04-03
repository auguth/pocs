# Proof of Contract Stake (PoCS) Formal Specification

Proof of Contract Stake (PoCS) is an innovative staking system utilizing contract gas history to select block producers. It merges proof-of-work and proof-of-stake, introducing "code-mining" by incentivizing developers to secure the network. Contracts' stake scores depend on reputation, and gas use, deterring collusion attacks. PoCS eliminates the "nothing at stake" attack with a non-fungible non-transferable unit of scarcity to stake. A stake accumulation attack in PoCS is time constraint and patterned which can be easily detected, escalates costs over time, and cannot be expedited with any external resources.

## Additional References

Whitepaper
Grant Link
Milestone 1 Branch
Milestone 2 Branch

## Short Theory

Contracts as Bonds
Stake Score
Reputation
Minimum Requirements

## Substrate Infrastructure

Tell about Host and Runtime
What is Host and why it is seperate for polkadot and parachains that use substrate
How Runtime deals with State Transition System
How runtime is composed of pallets
Why auguth chose substrate for building PoCS

### pallet-contracts

Its module details
List of functions
How PoCS can be incorporated to pallet-contracts

### pallet-staking

Its module details
List of functions
How PoCS can be incorporated to pallet-staking

## Specification

### Maps

Additional Maps AccountStakeinfo, ContractScarcityinfo etc

### instantiate code

upload_contract() with default values - auto bond() to owner himself

### updating delegate

update_delegate() - purge stake score, ensure min-reputation - unbond() event and next bond event

### run

contract call bond_extra

### validation 

validator validate() ensure min-delegates 

### Controller Contract

Reward Contract Verification Model
Reward Custom Logic