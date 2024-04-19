# Proof of Contract Stake (PoCS) Formal Specification

## Short Theory

1. **Contracts as Bonds**: Proof of Contract Stake (PoCS) allows contracts to serve as bonds which can nominate/delegated to validators for block production. This bond represents a commitment of stake score as bond value to support the network's security and block authoring operation.
2. **Stake Score**: The stake score is a crucial metric in PoCS, representing the contribution of a contract to the network's security. It is determined based on factors such as the contract's gas consumption and reputation. A higher stake score indicates a higher bond value which can attract higher rewards.
3. **Reputation**: Reputation plays a vital role in PoCS, influencing a contract's stake score. It reflects the trustworthiness and reliability of a contract based on its usage history in consecutive blocks and behavior within the network.
4. **Minimum Requirements**: PoCS imposes minimum requirements for contracts and validators to participate in the staking process. Contracts must meet certain reputation thresholds to nominate/delegate to validators, while validators may have minimum delegator requirements to fulfill their roles effectively. These requirements ensure smooth functioning of the network.

For more detailed understanding of PoCS visit the [Research Document](https://jobyreuben.in/JOURNALS/pocs) or [README](/README.md)


## Specification

### Structures

In addition to the existing structures stored on-chain within a Contract Account, two additional structures, namely AccountStakeInfo and ContractScarcityInfo, are required. These structures provide essential information for stake management and scarcity evaluation.

**AccountStakeInfo**

AccountStakeInfo stores delegate information related to the account, comprising an array of variables indexed from 0 to 2.

$$\text{AccountStakeInfo} \to (\text{owner}_0, \text{delegateTo}_1, \text{delegateAt}_2)$$

- $\text{owner}$: The account-ID of the contract deployer, essential for authentication during the update of delegate information.
- $\text{delegateTo}$: The address of the validator controller contract to which the contract is staked.
- $\text{delegateAt}$: The block height at which the delegate information was last updated, crucial for determining the stake age.

During contract instantiation, the AccountStakeInfo structure of the contract account includes default values, as an additional call is necessary to update the actual validator information. Assuming the variables are indexed in an ordered set, the default values are:

$$\text{AccountStakeInfo}_\text{def} \to (\text{deployerID}_0, \text{deployerID}_1, \text{currentBlockheight}_2)$$

Upon contract instantiation, the `delegateTo` field is updated with the deployer's account-ID.

**ContractScarcityInfo**

ContractScarcityInfo stores the scarcity information i.e., score of the staked contract comprising an array of ordered variables from index 0 to 2  

$$\text{ContractScarcityInfo}=(\text{reputation}_0,\text{recentBlockHeight}_1, \text{stake\_score}_2 )$$

- $\text{reputation}$: The contract's reputation based on recurrent calls on consecutive blocks
- $\text{recentBlockHeight}$: Recent Blockheight in which the contract is called via an extrinsic.
- $\text{stake\_score}$: The Stake Score (Scarcity Value) of the contract


Similar to AccountStakeInfo, during contract instantiation, the ContractScarcityInfo structure of the contract account includes default values. These values can be only altered by the `update_delegate()` function. Assuming the variables are indexed in an ordered set, the default values are:

$$\text{AccountStakeInfo}_\text{def} \to (\text{1}_0, \text{currentBlockHeight}_1, \text{0}_2)$$

> In this document $\text{currentBlockHeight}$ is referred to the Blockheight in which the contract call is executed

### instantiate code

upload_contract() with default values - auto bond() to owner himself


instantiate-with-code - while contract deploy, contract scarcityinfo default values stored, accountstakeinfo owner, delegateTo also owner, delegateat will be initialized, pallet-staking bonding where stake_score will be zero, controller-id owner address

validatordelegate map update with 0

### reputation & stake_score



### updating delegate

update_delegate() - purge stake score, ensure min-reputation - unbond() event and next bond event

update-delegate custom function- only when update delegate nomination happens, input - contract address, delegateTo, - to whom you nominate the reputation should satisfy min_reputation, this updates delegateAt in contractscarcityinfomap, resets stake score, and updates recent_blockheight and reputation will not change

### unbond

new_unbond (unbond, update_delegate is ensuring owner, bond makes it zero)

### run

run - stack execution - contract scarcity info - current transaction's reftime- calculate new stakescore - update contractscarcityinfo map, bond_extra call

### bond_extra

add new stake_score value to the bond

### nominate

validator map is updated with +1 to existing address.

### validation 

validate function - min delegates ensure, using the validatordelegatemap


### Controller Contract

Reward Contract Verification Model
Reward Custom Logic

## Summary

bond (min bond removal), bond_extra (min bond removal), new_unbond (unbond, update_delegate is ensuring owner, bond makes it zero), nominate (add +1 to validatordelegate map), validate (min delegate ensure) 


