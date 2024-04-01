# Proof of Contract Stake

Proof of Contract Stake (PoCS) is an innovative staking system utilizing contract gas history to select block producers. It merges proof-of-work and proof-of-stake, introducing "code-mining" by incentivizing developers to secure the network. Contracts' stake scores depend on reputation, and gas use, deterring collusion attacks. PoCS eliminates the "nothing at stake" attack with a non-fungible non-transferable unit of scarcity to stake. A stake accumulation attack in PoCS is time constraint and patterned which can be easily detected, escalates costs over time, and cannot be expedited with any external resources.

# Implementation Spec

## PoCS x NPoS

Substrate Infrastructure
pallet-staking and pallet-contracts
Additional Maps AccountStakeinfo, ContractScarcityinfo etc
upload_contract() with default values - auto bond() to owner himself
update_delegate() - purge stake score, ensure min-reputation - unbond() event and next bond event
contract call bond_extra
validator validate() ensure min-delegates 
Reward Contract Verification Model
Reward Custom Logic