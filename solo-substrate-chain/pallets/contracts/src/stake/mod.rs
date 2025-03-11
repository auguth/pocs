// This file is part of Substrate.
// Copyright (C) Auguth Research Foundation, India.
// SPDX-License-Identifier: Apache-2.0

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// 	http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// This file is utilized for Proof of Contract Stake Protocol (PoCS).
//

pub mod chain_ext;


use crate::{
	Config, Error, Event, OriginFor, Pallet as Contracts, DelegateInfoMap, StakeInfoMap, ValidatorInfoMap,
};
use frame_system::pallet_prelude::BlockNumberFor;
use codec::{Decode, Encode, MaxEncodedLen};
use scale_info::TypeInfo;
use sp_runtime::{
	traits::Hash, DispatchError, RuntimeDebug
};
use sp_std::prelude::*;
use pallet_staking::{Pallet as Staking, ValidatorPrefs,Bonded};

/// The minimum reputation required to participate in staking contracts.
pub const MIN_REPUTATION: u32 = 3; 

/// The minimum number of delegates required for a validator to be eligible.
pub const MIN_DELEGATES: u32 = 10; 

/// The fixed unit used for incrementing reputation and initializing it during instantiation.
pub const REPUTATION_FACTOR: u32 = 1;

/// The initial stake score, set to zero for contract constructor purposes.
pub const INITIAL_STAKE_SCORE: u128 = 0;


/// Represents the delegation details of a deployed contract.
/// It includes:
/// - The owner of the contract.
/// - The validator account i.e., contract to which the contract is delegated.
/// - The block number when the delegation was set.
#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct DelegateInfo<T: Config> {
	owner : T::AccountId,
	delegate_to: T::AccountId,
	delegate_at: BlockNumberFor<T>,
}

impl<T: Config> DelegateInfo<T> {
    /// Returns the owner `AccountId` of the contract associated with this `DelegateInfo`.
    pub fn owner(&self) -> T::AccountId {
        self.owner.clone()
    }

    /// Returns the `AccountId` of the validator to whom the contract is delegated.
    pub fn delegate_to(&self) -> T::AccountId {
        self.delegate_to.clone()
    }
    
    /// Returns the block number when the delegate information was last updated.
    pub fn delegate_at(&self) -> BlockNumberFor<T> {
        self.delegate_at
    }
    
    /// Retrieves the `DelegateInfo` for a given contract address.
    pub fn get(contract_addr: &T::AccountId) -> Result<DelegateInfo<T>, DispatchError> {
        Contracts::<T>::get_delegate_info(contract_addr)
            .ok_or_else(|| Error::<T>::NoStakeExists.into())
    }

    /// Creates a new `DelegateInfo` instance where the deployer is both the owner and delegate.
    pub fn new(owner: &T::AccountId) -> Self {
        Self {
            owner: owner.clone(),
            delegate_to: owner.clone(),
            delegate_at: frame_system::Pallet::<T>::block_number(),
        }
    }

    /// Updates the `delegate_to` field and returns an updated `DelegateInfo` instance.
    pub fn update(&self, delegate: &T::AccountId) -> Self {
        Self {
            owner: self.owner.clone(),
            delegate_to: delegate.clone(),
            delegate_at: frame_system::Pallet::<T>::block_number(),
        }
    }
}


/// Tracks the gas usage metrics of a contract for staking purposes.
/// It includes:
/// - The reputation score of the contract.
/// - The block height of its most recent usage.
/// - The stake score associated with the contract.
#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct StakeInfo<T: Config> {
	reputation: u32,
	blockheight: BlockNumberFor<T>,
	stake_score: u128,
}

impl<T: Config> StakeInfo<T>{

    /// Returns the stake score of a contract's `StakeInfo`. 
    pub fn stake_score(&self) -> u128 {
        self.stake_score
    }

    /// Returns the reputation score of a contract's `StakeInfo`.
    pub fn reputation(&self) -> u32 {
        self.reputation
    }
    
    /// Returns the block height of the most recent interaction with the contract. 
    pub fn blockheight(&self) -> BlockNumberFor<T> {
        self.blockheight
    }

    /// Retrieves the `StakeInfo` of an instantiated contract.
    pub fn get(contract_addr: &T::AccountId) -> Result<StakeInfo<T>,DispatchError> {
        Contracts::<T>::get_stake_info(contract_addr)
            .ok_or_else(|| Error::<T>::NoStakeExists.into())
    }

    /// Creates a mock `StakeInfo` instance for testing with a given stake score and reputation.
    pub fn mock_stake(stake_score: u128, reputation: u32) -> Self{
        Self{
            reputation: reputation,
            blockheight: <frame_system::Pallet<T>>::block_number(),
            stake_score: stake_score
        }
    }

    /// Creates a new `StakeInfo` instance using predefined constants for instantiation. 
	fn new() -> Self {
		Self{
			reputation: REPUTATION_FACTOR,
			blockheight: <frame_system::Pallet<T>>::block_number(),
			stake_score: INITIAL_STAKE_SCORE,
		}
	}

    /// Resets the stake score in `StakeInfo` to zero, updates the block number, and retains the reputation. 
	fn reset(&self)-> Self {
		Self{
			reputation: self.reputation,
			blockheight: <frame_system::Pallet<T>>::block_number(),
			stake_score: INITIAL_STAKE_SCORE,
		}
	}

    /// Updates the stake score based on gas usage provided and adjusts reputation if the block height has changed.
    fn update(&self, gas: &u64) -> Self {
        let current_block_height = <frame_system::Pallet<T>>::block_number();
        let current_reputation = self.reputation;
        if current_block_height > self.blockheight {
            let new_stake_score = (*gas as u128 * current_reputation as u128) + self.stake_score;
            Self {
                reputation: current_reputation + REPUTATION_FACTOR,
                blockheight: current_block_height,
                stake_score: new_stake_score,
            }
        } else {
            let new_stake_score = *gas as u128  + self.stake_score;
            Self {
                reputation: current_reputation,
                blockheight: current_block_height,
                stake_score: new_stake_score,
            }
        }
    }
}


#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct StakeRequest<T: Config> {
	contract: T::AccountId,
    caller: T::AccountId,
    gas: u64
}

impl<T: Config> StakeRequest<T>{

    pub fn stake(origin: &T::AccountId, contract_addr: &T::AccountId, gas: &u64) -> Result<(),DispatchError>{
        if StakeInfoMap::<T>::contains_key(contract_addr){
            Self::new(contract_addr, gas)?;
        } else {
            Self::empty(origin, contract_addr);
        }
        Ok(())
    }

    fn empty(origin: &T::AccountId, contract_addr: &T::AccountId) {
        let delegate_info = <DelegateInfo<T>>::new(origin);
        Self::init(&Self{
            contract: contract_addr.clone(),
            caller: origin.clone(),
            gas: 0
        } 
            , &delegate_info);
    }

    fn new(contract_addr: &T::AccountId, gas: &u64) -> Result<(),DispatchError>{
        let delegate_info = <DelegateInfo<T>>::get(contract_addr)?;
        let stake_info = <StakeInfo<T>>::get(contract_addr)?;
        let gas = if delegate_info.owner != delegate_info.delegate_to { gas } else { &0 };
        let new_stake_info = <StakeInfo<T>>::update(&stake_info, gas);
        StakeInfoMap::<T>::insert(contract_addr, new_stake_info.clone());
        if delegate_info.owner != delegate_info.delegate_to {
            Contracts::<T>::deposit_event(
                vec![T::Hashing::hash_of(contract_addr)],
                Event::Staked {
                    contract: contract_addr.clone(),
                    stake_score: new_stake_info.stake_score.clone(),
                },
            );
            Self::decide_bond(&stake_info, &new_stake_info, &delegate_info)?;
        } 
        if stake_info.reputation >= MIN_REPUTATION {
            Contracts::<T>::deposit_event(
                vec![T::Hashing::hash_of(contract_addr)],
                Event::ReadyToStake {
                    contract: contract_addr.clone(),
                },
            );
        }
        Ok(())
    }

    fn decide_bond(stake_info:&StakeInfo<T>, new_stake_info:&StakeInfo<T> , delegate_info:&DelegateInfo<T>)-> Result<(),DispatchError>{
        if stake_info.reputation >= MIN_REPUTATION {
            if <Bonded<T>>::contains_key(&delegate_info.owner.clone()){
                let stake_score_difference = new_stake_info.stake_score - stake_info.stake_score;
                <StakeRequest<T>>::add_bond(&delegate_info.owner, &stake_score_difference)?;
            } else {
                <StakeRequest<T>>::new_bond(&delegate_info, &new_stake_info)?;
            }
        }
        Ok(())
    }

    fn add_bond(owner: &T::AccountId, stake_score: &u128) -> Result<(), DispatchError>{
        <pallet_staking::Pallet<T> as sp_staking::StakingInterface>::bond_extra(
            owner,stake_score.clone().try_into().unwrap_or_default())?;
        Ok(())
    }

    fn init(&self, delegate: &DelegateInfo<T>) {
		let stake_info: StakeInfo<T> = StakeInfo::<T>::new();
		StakeInfoMap::<T>::insert(&self.contract, stake_info.clone());
        DelegateInfoMap::<T>::insert(&self.contract, delegate.clone());
	}

    fn new_bond(delegate_info: &DelegateInfo<T>, stake_info: &StakeInfo<T>) -> Result<(),DispatchError>{
        <pallet_staking::Pallet<T> as sp_staking::StakingInterface>::bond(
            &delegate_info.owner,
            stake_info.stake_score.clone().try_into().unwrap_or_default(),
            &delegate_info.owner,
        )?;
        Self::nominate(&delegate_info.owner,&delegate_info.delegate_to)?;
        Ok(())
    }

    pub fn delete(contract_addr: &T::AccountId){
        if StakeInfoMap::<T>::contains_key(&contract_addr) {
            StakeInfoMap::<T>::remove(&contract_addr);
        } 
        if DelegateInfoMap::<T>::contains_key(&contract_addr){
            let delegate_info = <DelegateInfo<T>>::get(&contract_addr).unwrap();
            let delegate_to = delegate_info.delegate_to();
            if delegate_to != delegate_info.owner(){
                <DelegateRequest<T>>::decrement(&delegate_to);
            }
            DelegateInfoMap::<T>::remove(&contract_addr);
        }
    }

    fn nominate(owner: &T::AccountId, validator: &T::AccountId) -> Result<(),DispatchError>{
        <pallet_staking::Pallet<T> as sp_staking::StakingInterface>::nominate(
            owner,
            vec![validator.clone(),]
        )?;
        Ok(())
    }

}


#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct DelegateRequest<T: Config> {
	contract: T::AccountId,
    delegate_to: T::AccountId,
}

impl<T: Config> DelegateRequest<T>{

    pub fn delegate(origin: &T::AccountId, contract_addr: &T::AccountId, delegate_to: &T::AccountId) -> Result<(),DispatchError>{
        Self::stake_exists(contract_addr)?;
        let delegate_info = Self::owner_check(origin, contract_addr)?;
        let stake_info = <DelegateRequest<T>>::min_reputation(&contract_addr)?;
        if delegate_info.delegate_to != *delegate_to {
            Self::reset_stake(contract_addr, &stake_info);
            let new_delegate_info = <DelegateInfo<T>>::update(&delegate_info, delegate_to);
            DelegateInfoMap::<T>::insert(contract_addr, new_delegate_info.clone());
            Contracts::<T>::deposit_event(
                vec![T::Hashing::hash_of(contract_addr)],
                Event::Delegated {
                    contract: contract_addr.clone(),
                    delegate_to: new_delegate_info.delegate_to,
                },
            );
            Self::unbond(origin, &delegate_info.delegate_to, delegate_to)?;
            Ok(())
        } else {
            return Err(Error::<T>::AlreadyDelegated.into())
        }
    }

    pub fn stake_exists(contract_addr: &T::AccountId) -> Result<(),DispatchError>{
        if DelegateInfoMap::<T>::contains_key(contract_addr){
            Ok(())
        }else {
            Err(Error::<T>::NoStakeExists.into())
        }
    }

    pub fn owner_check(owner: &T::AccountId, contract_addr: &T::AccountId) -> Result<DelegateInfo<T>, DispatchError> {
        let delegate_info = <DelegateInfo<T>>::get(contract_addr)?;
        if delegate_info.owner == *owner {
            Ok(delegate_info)
        } else {
            Err(Error::<T>::InvalidContractOwner.into())
        }
    }

    fn min_reputation(contract_addr : &T::AccountId) -> Result<StakeInfo<T>,DispatchError>{
        let stake_info = <StakeInfo<T>>::get(contract_addr)?;
        if stake_info.reputation >= MIN_REPUTATION {
            Ok(stake_info)
        } else {
            Err(Error::<T>::LowReputation.into())
        }
            
    }

    fn reset_stake(contract_addr: &T::AccountId, stake_info: &StakeInfo<T>){
        let new_stake_info = <StakeInfo<T>>::reset(stake_info);
        StakeInfoMap::<T>::insert(contract_addr, new_stake_info.clone());
    }

    pub fn unbond(owner: &T::AccountId, to_unbond: &T::AccountId, validator: &T::AccountId) -> Result<(), DispatchError>{
        if <Bonded<T>>::contains_key(&owner.clone()){
            let null_stake: u64 = 0;
            <pallet_staking::Pallet<T> as sp_staking::StakingInterface>::unbond(owner,null_stake.into())?;
        }
        Self::decrement(to_unbond);
        Self::increment(validator);
        Ok(())
    }

   fn increment(validator: &T::AccountId) {
        if let Ok(num_delegates) = <ValidateRequest<T>>::get(validator){
            let new_num_delegates = num_delegates + 1;
            <ValidatorInfoMap<T>>::insert(&validator, new_num_delegates);
            if new_num_delegates >= MIN_DELEGATES {
                Contracts::<T>::deposit_event(
                    vec![T::Hashing::hash_of(validator)],
                    Event::ValidateInfo { 
                        validator: validator.clone(), 
                        num_delegates: new_num_delegates, 
                        can_validate: true,
                    }
                )
            } else {
                Contracts::<T>::deposit_event(
                    vec![T::Hashing::hash_of(validator)],
                    Event::ValidateInfo { 
                        validator: validator.clone(), 
                        num_delegates: new_num_delegates, 
                        can_validate: false,
                    }
                )
            }
        } else {
            <ValidatorInfoMap<T>>::insert(&validator, 1); 
            Contracts::<T>::deposit_event(
                vec![T::Hashing::hash_of(validator)],
                Event::ValidateInfo { 
                    validator: validator.clone(), 
                    num_delegates: 1, 
                    can_validate: false,
                }
            );
        }
    }

    fn decrement(validator: &T::AccountId) {
        if let Ok(num_delegates) = <ValidateRequest<T>>::get(validator){
            if num_delegates > 1 {
                let new_num_delegates = num_delegates - 1;
                <ValidatorInfoMap<T>>::insert(&validator, new_num_delegates);
                if new_num_delegates >= MIN_DELEGATES {
                    Contracts::<T>::deposit_event(
                        vec![T::Hashing::hash_of(validator)],
                        Event::ValidateInfo { 
                            validator: validator.clone(), 
                            num_delegates: new_num_delegates, 
                            can_validate: true,
                        }
                    );
                } else {
                    Contracts::<T>::deposit_event(
                        vec![T::Hashing::hash_of(validator)],
                        Event::ValidateInfo { 
                            validator: validator.clone(), 
                            num_delegates: new_num_delegates, 
                            can_validate: false,
                        }
                    );
                }
            }else{
                <ValidatorInfoMap<T>>::remove(&validator);
				Contracts::<T>::deposit_event(
					vec![T::Hashing::hash_of(validator)],
					Event::ValidateInfo { 
						validator: validator.clone(), 
						num_delegates: 0, 
						can_validate: false,
					}
				);
            }
        } 
    }

}

#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct ValidateRequest<T: Config> {
	validator: T::AccountId,
    num_delegates: u32,
}

impl<T: Config> ValidateRequest<T> {

    pub fn get(validator: &T::AccountId) -> Result<u32,DispatchError>{
        Contracts::<T>::get_validator_info(validator)
            .ok_or_else(|| Error::<T>::NoValidatorFound.into())
    }

    fn min_delegates_check(validator: &T::AccountId) -> Result<(),DispatchError>{
        let num_delegates = Self::get(validator)?;
        if num_delegates >= MIN_DELEGATES {
            return Ok(())
        } else {
            return Err(Error::<T>::InsufficientDelegates.into())
        }
    }

    pub fn validate(origin: OriginFor<T>, prefs: ValidatorPrefs, validator: &T::AccountId) -> Result<(),DispatchError>{
        Self::min_delegates_check(validator)?;
        Staking::<T>::validate(origin, prefs)?;
        Ok(())
    }

 
}

