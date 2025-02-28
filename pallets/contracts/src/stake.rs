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
	Config, Error, Event, Pallet as Contracts
};
use frame_system::{pallet_prelude::BlockNumberFor, };
use codec::{Decode, Encode, MaxEncodedLen};
use scale_info::TypeInfo;
use sp_runtime::{
	RuntimeDebug,traits::Hash,
};
use sp_std::{prelude::*};
use crate::{DelegateInfoMap,StakeInfoMap};


#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct DelegateInfo<T: Config> {
	owner : T::AccountId,
	delegate_to: T::AccountId,
	delegate_at: BlockNumberFor<T>,
}

impl<T: Config> DelegateInfo<T> {

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

    pub fn get(contract_addr: &T::AccountId) -> Result<StakeInfo<T>, Error<T>> {
        let stake_info = Contracts::get_stake_info(contract_addr).ok_or(Error::<T>::ContractNotFound)?;
        Ok(stake_info)
    }

    pub fn stake_level(&self) -> u16 {
        self.stake_level
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

    pub fn stake(origin: &T::AccountId, contract_addr: &T::AccountId, gas: &u64){
        if StakeInfoMap::<T>::contains_key(contract_addr){
            Self::new(contract_addr, gas);
        } else {
                Self::empty(origin, contract_addr);
        }
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

    fn new(contract_addr: &T::AccountId, gas: &u64){
        if let Some(stake_info) = Contracts::get_stake_info(contract_addr){
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
            }
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
        Contracts::<T>::deposit_event(
			vec![T::Hashing::hash_of(&delegate.delegate_to)],
			Event::Delegated {
                contract: self.contract.clone(),
                owner: delegate.owner.clone(),
                delegate_to: delegate.owner.clone(),
			},
		);
	}

    pub fn delete(contract_addr: &T::AccountId){
        if StakeInfoMap::<T>::contains_key(&contract_addr) {
            StakeInfoMap::<T>::remove(&contract_addr);
        } 
       
    }

}

