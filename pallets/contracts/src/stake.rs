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
	Config, Error, Event, OriginFor, Pallet as Contracts, ValidatorInfoMap
};
use frame_support::dispatch::DispatchErrorWithPostInfo;
use frame_system::{pallet_prelude::BlockNumberFor, };
use codec::{Decode, Encode, MaxEncodedLen};
use scale_info::TypeInfo;
use sp_runtime::{
	traits::Hash, DispatchError, RuntimeDebug
};
use sp_std::{prelude::*};
use crate::{DelegateInfoMap,StakeInfoMap};
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
        if let Some(delegate_info) = Contracts::<T>::get_delegate_info(contract_addr){
            return Ok(delegate_info)
        } else {
            return Err(Error::<T>::NoDelegateExists.into())
        }
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
	stake_score: u64,
    stake_level: u16,

}
impl<T: Config> StakeInfo<T>{

    pub fn stake_score(&self) -> u64 {
        self.stake_score
    }
    
    pub fn stake_level(&self) -> u16 {
        self.stake_level
    }

    pub fn mock_stake_info(ref_time:&Option<u64>) -> Self{
        match ref_time {
            Some(gas) => {
                let stake_info = Self::new();
                let result = Self::update(&stake_info, &gas);
                return result
            }
            None => {
                let result = Self::new();
                return result
            }
        }
    }

    pub fn get(contract_addr: &T::AccountId) -> Result<StakeInfo<T>,DispatchError> {
        if let Some(stake_info) = Contracts::<T>::get_stake_info(contract_addr){
            return Ok(stake_info)
        } else {
            return Err(Error::<T>::NoStakeExists.into())
        }
    }

	fn new() -> Self {
		Self{
			reputation: 1,
			blockheight: <frame_system::Pallet<T>>::block_number(),
			stake_score: 0,
            stake_level: 1,
		}
	}

	fn reset(&self)-> Self {
		Self{
			reputation: self.reputation,
			blockheight: <frame_system::Pallet<T>>::block_number(),
			stake_score: 0,
            stake_level: 1,
		}
	}

    fn update(&self, gas: &u64) -> Self {
        let current_block_height = <frame_system::Pallet<T>>::block_number();
        let current_reputation = self.reputation;
        if current_block_height > self.blockheight {
            let (interim,may_wrap) = gas.clone().overflowing_mul(current_reputation as u64);
            let (result,is_wrap) = interim.overflowing_add(self.stake_score);
            if may_wrap || is_wrap {
                Self {
                    reputation: current_reputation + 1,
                    blockheight: current_block_height,
                    stake_score: result,
                    stake_level: self.stake_level + 1,
                }
            }else {
                Self {
                    reputation: current_reputation + 1,
                    blockheight: current_block_height,
                    stake_score: result,
                    stake_level: self.stake_level,
                }
            }

        } else {
            let (result,may_wrap) = gas.clone().overflowing_add(self.stake_score);
            if may_wrap {
                Self {
                    reputation: current_reputation + 1,
                    blockheight: current_block_height,
                    stake_score: result,
                    stake_level: self.stake_level + 1,
                }
            }else {
                Self {
                    reputation: current_reputation + 1,
                    blockheight: current_block_height,
                    stake_score: result,
                    stake_level: self.stake_level,
                }
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
            if let Err(error) = Self::new(contract_addr, gas){
                return Err(error)
            } 
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
        let result = <StakeInfo<T>>::get(contract_addr);
        match result {
            Ok(stake_info) => {
                let new_stake_info = <StakeInfo<T>>::update(&stake_info, gas);
                StakeInfoMap::<T>::insert(contract_addr, new_stake_info.clone());
                Contracts::<T>::deposit_event(
                    vec![T::Hashing::hash_of(contract_addr)],
                    Event::Staked {
                        contract: contract_addr.clone(),
                        stake_score: new_stake_info.stake_score.clone(),
                        stake_level: new_stake_info.stake_level,
                    },
		        );
                let delegate_info_result = <DelegateInfo<T>>::get(contract_addr);
                match delegate_info_result {
                    Ok(delegate_info) => {
                        if let Err(bond_error) =Self::decide_bond(&stake_info, &new_stake_info, &delegate_info){
                            return Err(bond_error)
                        }
                        Ok(())
                    }
                    Err(no_delegate) => {
                        return Err(no_delegate)
                    }
                }    
            }
            Err(no_stake) => {
                return Err(no_stake)
            }
        }
                
    }

    fn decide_bond(stake_info:&StakeInfo<T>, new_stake_info:&StakeInfo<T> , delegate_info:&DelegateInfo<T>)-> Result<(),DispatchError>{
        if delegate_info.owner != delegate_info.delegate_to {
            if stake_info.reputation >= MIN_REPUTATION {
                if <Bonded<T>>::contains_key(&delegate_info.owner.clone()){
                    let stake_score_difference = new_stake_info.stake_score - stake_info.stake_score;
                    if let Err(bond_error) = <StakeRequest<T>>::add_bond(&delegate_info.owner, &stake_score_difference){
                        return Err(bond_error)
                    }
                } else {
                    if let Err(bond_error) = <StakeRequest<T>>::new_bond(&delegate_info, &new_stake_info){
                        return Err(bond_error)
                    }
                }
            }
        }
        Ok(())
    }

    fn add_bond(owner: &T::AccountId, stake_score: &u64) -> Result<(), DispatchError>{
        if let Err(bond_error) = <pallet_staking::Pallet<T> as sp_staking::StakingInterface>::bond_extra(
            owner,
            stake_score.clone().try_into().unwrap_or_default(),
        ){
            return Err(bond_error.into())
        }	
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
                stake_level : stake_info.stake_level,
			},
		);
	}

    fn new_bond(delegate_info: &DelegateInfo<T>, stake_info: &StakeInfo<T>) -> Result<(),DispatchError>{
        if let Err(bond_error) = <pallet_staking::Pallet<T> as sp_staking::StakingInterface>::bond(
            &delegate_info.owner,
            stake_info.stake_score.clone().try_into().unwrap_or_default(),
            &delegate_info.owner,
        ){
            return Err(bond_error.into())
        }
        if let Err(nominate_error) = <DelegateRequest<T>>::nominate(&delegate_info.owner,&delegate_info.delegate_to){
            return Err(nominate_error.into())
        }
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
        if let Err(non_exists) = Self::contract_exists(contract_addr) {
            return Err(non_exists)    
        }
        let delegate = Self::origin_check(origin, contract_addr);
        match delegate {
            Ok(delegate_info) => {
                let stake = <DelegateRequest<T>>::min_reputation(&contract_addr);
                match stake {
                    Ok(stake_info) => {
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
                    Err(low_reputation) => {
                        return Err(low_reputation)
                    }
                }
            }
            Err(invalid_origin) => {
                return Err(invalid_origin)
            }
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
        let result = <DelegateInfo<T>>::get(contract_addr);
        match result {
            Ok(delegate_info) => {
                if delegate_info.owner == *origin {
                    Ok(delegate_info)
                } else {
                    Err(Error::<T>::InvalidContractOwner.into())
                }
            }
            Err(no_delegate) => {
                return Err(no_delegate)
            }

        }
    }

    fn min_reputation(contract_addr : &T::AccountId) -> Result<StakeInfo<T>,DispatchError>{
        let result = <StakeInfo<T>>::get(contract_addr);
        match result {
            Ok(stake_info) => {
                if stake_info.reputation >= MIN_REPUTATION + 1 {
                    Ok(stake_info)
                } else {
                    Err(Error::<T>::LowReputation.into())
                }
            }
            Err(no_stake) => {
                return Err(no_stake)
            }
        }
    }

    fn reset_stake(contract_addr: &T::AccountId, stake_info: &StakeInfo<T>){
        let new_stake_info = <StakeInfo<T>>::reset(stake_info);
        StakeInfoMap::<T>::insert(contract_addr, new_stake_info.clone());
    }

    pub fn unbond(owner: &T::AccountId, delegate_to: &T::AccountId) -> Result<(), DispatchError>{
        if <Bonded<T>>::contains_key(&owner.clone()){
            let null_stake: u64 = 0;
            if let Err(bond_error) = <pallet_staking::Pallet<T> as sp_staking::StakingInterface>::unbond(owner,null_stake.into()){
                return Err(bond_error)
            }
            if let Some(num_delegates) = <ValidatorInfoMap<T>>::get(&delegate_to){
                if num_delegates > 1 {
                    <ValidatorInfoMap<T>>::insert(&delegate_to, num_delegates-1);
                }else{
                    <ValidatorInfoMap<T>>::remove(&delegate_to);
                }
            } 
        }
        Ok(())
    }

    fn nominate(owner: &T::AccountId, delegate_to: &T::AccountId) -> Result<(),DispatchError>{
        if let Err(nominate_error) = <pallet_staking::Pallet<T> as sp_staking::StakingInterface>::nominate(
            owner,
            vec![delegate_to.clone(),]
        ){
            return Err(nominate_error)
        }
        if let Some(num_delegates) = <ValidatorInfoMap<T>>::get(&delegate_to){
            <ValidatorInfoMap<T>>::insert(&delegate_to, num_delegates+1);
        } else {
            <ValidatorInfoMap<T>>::insert(&delegate_to, 1) 
        }
        Ok(())
    }


}
