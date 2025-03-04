// This file is part of Substrate-PoCS Implementation
//
// SPDX-License-Identifier: Apache-2.0
// 
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

//! This module contains PoCS (Proof of Contract Stake) Structures and Implementations
//! 
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

const MIN_REPUTATION: u32 = 2; 
const MIN_DELEGATES: u32 = 2; 


#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct DelegateInfo<T: Config> {
	owner : T::AccountId,
	delegate_to: T::AccountId,
	delegate_at: BlockNumberFor<T>,
}

impl<T: Config> DelegateInfo<T> {

    fn get(contract_addr: &T::AccountId) -> Result<DelegateInfo<T>, DispatchError> {
        Contracts::<T>::get_delegate_info(contract_addr)
        .ok_or_else(|| Error::<T>::NoDelegateExists.into())
    }

	fn new(owner: &T::AccountId,) -> Self {
		Self {
			owner: owner.clone(),
            delegate_to: owner.clone(),
			delegate_at: frame_system::Pallet::<T>::block_number()
		}
	}

	fn update(&self, delegate: &T::AccountId) -> Self {
		Self{
			owner: self.owner.clone(), 
			delegate_to: delegate.clone(),
			delegate_at: frame_system::Pallet::<T>::block_number()
		}
	}

}

#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct StakeInfo<T: Config> {
	reputation: u32,
	blockheight: BlockNumberFor<T>,
	stake_score: u128,

}
impl<T: Config> StakeInfo<T>{

    pub fn stake_score(&self) -> u128 {
        self.stake_score
    }
    
    pub fn mock_stake_info(ref_time:&Option<u64>) -> Self{
        match ref_time {
            Some(gas) => {
                let stake_info = Self::new();
                let result = Self::update(&stake_info, &gas);
                return result
            }
            _none => {
                let result = Self::new();
                return result
            }
        }
    }

    pub fn get(contract_addr: &T::AccountId) -> Result<StakeInfo<T>,DispatchError> {
        Contracts::<T>::get_stake_info(contract_addr)
            .ok_or_else(|| Error::<T>::NoStakeExists.into())
    }

	fn new() -> Self {
		Self{
			reputation: 1,
			blockheight: <frame_system::Pallet<T>>::block_number(),
			stake_score: 0,
		}
	}

	fn reset(&self)-> Self {
		Self{
			reputation: self.reputation,
			blockheight: <frame_system::Pallet<T>>::block_number(),
			stake_score: 0,
		}
	}

    fn update(&self, gas: &u64) -> Self {
        let current_block_height = <frame_system::Pallet<T>>::block_number();
        let current_reputation = self.reputation;
        if current_block_height > self.blockheight {
            let new_stake_score = (*gas as u128 * current_reputation as u128) + self.stake_score;
            Self {
                reputation: current_reputation + 1,
                blockheight: current_block_height,
                stake_score: new_stake_score,
            }
        } else {
            let new_stake_score = *gas as u128  + self.stake_score;
            Self {
                reputation: current_reputation + 1,
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
        let request_info = Self{
            contract: contract_addr.clone(),
            caller: origin.clone(),
            gas: 0
        };
        let delegate_info = <DelegateInfo<T>>::new(origin);
        Self::init(&request_info , &delegate_info);
    }

    fn new(contract_addr: &T::AccountId, gas: &u64) -> Result<(),DispatchError>{
        let stake_info = <StakeInfo<T>>::get(contract_addr)?;
        let new_stake_info = <StakeInfo<T>>::update(&stake_info, gas);
        StakeInfoMap::<T>::insert(contract_addr, new_stake_info.clone());
        Contracts::<T>::deposit_event(
            vec![T::Hashing::hash_of(contract_addr)],
            Event::Staked {
                contract: contract_addr.clone(),
                stake_score: new_stake_info.stake_score.clone(),
            },
        );
        let delegate_info = <DelegateInfo<T>>::get(contract_addr)?;
        Self::decide_bond(&stake_info, &new_stake_info, &delegate_info)?;
        Ok(())
    }

    fn decide_bond(stake_info:&StakeInfo<T>, new_stake_info:&StakeInfo<T> , delegate_info:&DelegateInfo<T>)-> Result<(),DispatchError>{
        if delegate_info.owner != delegate_info.delegate_to {
            if stake_info.reputation >= MIN_REPUTATION {
                if <Bonded<T>>::contains_key(&delegate_info.owner.clone()){
                    let stake_score_difference = new_stake_info.stake_score - stake_info.stake_score;
                    <StakeRequest<T>>::add_bond(&delegate_info.owner, &stake_score_difference)?;
                } else {
                    <StakeRequest<T>>::new_bond(&delegate_info, &new_stake_info)?;
                }
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
		Contracts::<T>::deposit_event(
			vec![T::Hashing::hash_of(&self.contract)],
			Event::Staked {
				contract: self.contract.clone(),
				stake_score: stake_info.stake_score.clone(),
			},
		);
	}

    fn new_bond(delegate_info: &DelegateInfo<T>, stake_info: &StakeInfo<T>) -> Result<(),DispatchError>{
        <pallet_staking::Pallet<T> as sp_staking::StakingInterface>::bond(
            &delegate_info.owner,
            stake_info.stake_score.clone().try_into().unwrap_or_default(),
            &delegate_info.owner,
        )?;
        <DelegateRequest<T>>::nominate(&delegate_info.owner,&delegate_info.delegate_to)?;
        Ok(())
    }

    pub fn delete(contract_addr: &T::AccountId) -> Result<(),DispatchError>{
        if StakeInfoMap::<T>::contains_key(&contract_addr) {
            StakeInfoMap::<T>::remove(&contract_addr);
            Ok(())
        } else {
            Err(Error::<T>::NoStakeExists.into())
        }
    }

}


#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct DelegateRequest<T: Config> {
	contract: T::AccountId,
    delegate_to: T::AccountId,
}

impl<T: Config> DelegateRequest<T>{

    pub fn delegate(origin: &T::AccountId, contract_addr: &T::AccountId, delegate_to: &T::AccountId) -> Result<T::AccountId,DispatchError>{
        Self::contract_exists(contract_addr)?;
        let delegate_info = Self::origin_check(origin, contract_addr)?;
        let stake_info = <DelegateRequest<T>>::min_reputation(&contract_addr)?;
        if delegate_info.delegate_to != *delegate_to {
            Self::reset_stake(contract_addr, &stake_info);
            let new_delegate_info = <DelegateInfo<T>>::update(&delegate_info, delegate_to);
            DelegateInfoMap::<T>::insert(contract_addr, new_delegate_info.clone());
            Contracts::<T>::deposit_event(
                vec![T::Hashing::hash_of(contract_addr)],
                Event::Delegated {
                    contract: contract_addr.clone(),
                    owner: origin.clone(),
                    delegate_to: new_delegate_info.delegate_to,
                },
            );
            return Ok(delegate_info.delegate_to)
        } else {
            return Err(Error::<T>::AlreadyDelegated.into())
        }
    }

    fn contract_exists(contract_addr: &T::AccountId) -> Result<(),DispatchError>{
        if DelegateInfoMap::<T>::contains_key(contract_addr){
            Ok(())
        }else {
            Err(Error::<T>::NoStakeExists.into())
        }

    }

    fn origin_check(origin: &T::AccountId, contract_addr: &T::AccountId) -> Result<DelegateInfo<T>, DispatchError> {
        let delegate_info = <DelegateInfo<T>>::get(contract_addr)?;
        if delegate_info.owner == *origin {
            Ok(delegate_info)
        } else {
            Err(Error::<T>::InvalidContractOwner.into())
        }
    }

    fn min_reputation(contract_addr : &T::AccountId) -> Result<StakeInfo<T>,DispatchError>{
        let stake_info = <StakeInfo<T>>::get(contract_addr)?;
        if stake_info.reputation >= MIN_REPUTATION + 1 {
            Ok(stake_info)
        } else {
            Err(Error::<T>::LowReputation.into())
        }
            
    }

    fn reset_stake(contract_addr: &T::AccountId, stake_info: &StakeInfo<T>){
        let new_stake_info = <StakeInfo<T>>::reset(stake_info);
        StakeInfoMap::<T>::insert(contract_addr, new_stake_info.clone());
    }

    pub fn unbond(owner: &T::AccountId, delegate_to: &T::AccountId) -> Result<(), DispatchError>{
        if <Bonded<T>>::contains_key(&owner.clone()){
            let null_stake: u64 = 0;
            <pallet_staking::Pallet<T> as sp_staking::StakingInterface>::unbond(owner,null_stake.into())?;
            <ValidateRequest<T>>::decrement(delegate_to);
        }
        Ok(())
    }

    fn nominate(owner: &T::AccountId, delegate_to: &T::AccountId) -> Result<(),DispatchError>{
        <pallet_staking::Pallet<T> as sp_staking::StakingInterface>::nominate(
            owner,
            vec![delegate_to.clone(),]
        )?;
        <ValidateRequest<T>>::increment(delegate_to);
        Ok(())
    }

}

#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct ValidateRequest<T: Config> {
	validator: T::AccountId,
    num_delegates: u32,
}

impl<T: Config> ValidateRequest<T> {

    fn get(validator: &T::AccountId) -> Result<u32,DispatchError>{
        Contracts::<T>::get_validator_info(validator)
            .ok_or_else(|| Error::<T>::NoDelegatesFound.into())
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

    fn increment(validator: &T::AccountId) {
        if let Ok(num_delegates) = Self::get(validator){
            let new_num_delegates = num_delegates + 1;
            <ValidatorInfoMap<T>>::insert(&validator, new_num_delegates);
            if new_num_delegates >= MIN_DELEGATES {
                let validate_info = true;
                Contracts::<T>::deposit_event(
                    vec![T::Hashing::hash_of(validator)],
                    Event::ValidateInfo { 
                        validator: validator.clone(), 
                        num_delegates: new_num_delegates, 
                        can_validate: validate_info,
                    }
                );
            } else {
                let validate_info = false;
                Contracts::<T>::deposit_event(
                    vec![T::Hashing::hash_of(validator)],
                    Event::ValidateInfo { 
                        validator: validator.clone(), 
                        num_delegates: new_num_delegates, 
                        can_validate: validate_info,
                    }
                );
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
        if let Ok(num_delegates) = Self::get(validator){
            if num_delegates > 1 {
                let new_num_delegates = num_delegates - 1;
                <ValidatorInfoMap<T>>::insert(&validator, new_num_delegates);
                if new_num_delegates >= MIN_DELEGATES {
                    let validate_info = true;
                    Contracts::<T>::deposit_event(
                        vec![T::Hashing::hash_of(validator)],
                        Event::ValidateInfo { 
                            validator: validator.clone(), 
                            num_delegates: new_num_delegates, 
                            can_validate: validate_info,
                        }
                    );
                } else {
                    let validate_info = false;
                    Contracts::<T>::deposit_event(
                        vec![T::Hashing::hash_of(validator)],
                        Event::ValidateInfo { 
                            validator: validator.clone(), 
                            num_delegates: new_num_delegates, 
                            can_validate: validate_info,
                        }
                    );
                }
            }else{
                <ValidatorInfoMap<T>>::remove(&validator);
            }
        } 
    }
    
}

#[test]
fn cannot_delegate_without_minimum_reputation(){

}

#[test]
fn delegate_with_minimum_reputation(){

}

#[test]
fn cannot_delegate_by_non_deployer(){

}

#[test]
fn delegate_by_deployer(){

}

#[test]
fn cannot_delegate_an_eoa(){

}

#[test]
fn cannot_bare_instantiate_and_delegate(){

}

#[test]
fn stake_on_first_call_without_instantiation(){

}

#[test]
fn zero_stake_score_on_call_without_instantiation(){

}

#[test]
fn no_stake_increase_after_delegation(){

}

#[test]
fn stake_reset_after_delegation(){

}

#[test]
fn redundant_delegate_fails(){

}
