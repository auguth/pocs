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

use codec::{Decode, Encode, MaxEncodedLen};
use scale_info::TypeInfo;
use sp_runtime::{
	RuntimeDebug,
};
use sp_std::{prelude::*};
use frame_system::{pallet_prelude::BlockNumberFor,};
use crate::{DelegateInfoMap,StakeInfoMap};

#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct DelegateInfo<T: frame_system::Config> {
	pub owner : T::AccountId,
	pub delegate_to: T::AccountId,
	pub delegate_at: BlockNumberFor<T>,
}


#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct StakeInfo<T: frame_system::Config> {
	pub reputation: u32,
	pub blockheight: BlockNumberFor<T>,
	pub stake_score: u64,
    pub stake_level: u16,
}

impl<T: frame_system::Config> DelegateInfo<T> {

	pub fn new(owner: &T::AccountId,) -> Self {
		Self {
			owner: owner.clone(),
            delegate_to: owner.clone(),
			delegate_at: <frame_system::Pallet<T>>::block_number()
		}
	}

    pub fn update_mut (&mut self, delegate: &T::AccountId) {
		self.delegate_to = delegate.clone();
    	self.delegate_at = frame_system::Pallet::<T>::block_number();
	}
     
	pub fn update(&self, delegate: &T::AccountId) -> Self {
		Self{
			owner: self.owner.clone(), 
			delegate_to: delegate.clone(),
			delegate_at: frame_system::Pallet::<T>::block_number()
		}
	}

}

impl<T: frame_system::Config> StakeInfo<T>{

	pub fn new() -> Self {
		Self{
			reputation: 1,
			blockheight: <frame_system::Pallet<T>>::block_number(),
			stake_score: 0,
            stake_level: 1,
		}
	}

	pub fn reset(&self)-> Self {
		Self{
			reputation: self.reputation,
			blockheight: <frame_system::Pallet<T>>::block_number(),
			stake_score: 0,
            stake_level: 1,
		}
	}

	pub fn reset_mut(&mut self) {
		self. blockheight = <frame_system::Pallet<T>>::block_number();
		self.stake_score = 0;
        self.stake_level = 1;
	}
	
	pub fn update_mut(&mut self, gas: &u64) {
        let current_block_height = <frame_system::Pallet<T>>::block_number();
        if current_block_height > self.blockheight {
            let (interim,may_wrap) = gas.clone().overflowing_mul(self.reputation as u64);
            let (result,is_wrap) = interim.overflowing_add(self.stake_score);
            if may_wrap || is_wrap {
                self.reputation += 1;
                self.blockheight = current_block_height;
                self.stake_score = result;
                self.stake_level += 1;
            }else {
                self.reputation += 1;
                self.blockheight = current_block_height;
                self.stake_score = result;
            }
        } else {
            let (result,may_wrap) = gas.clone().overflowing_add(self.stake_score);
            if may_wrap {
                self.reputation += 1;
                self.blockheight = current_block_height;
                self.stake_score = result;
                self.stake_level += 1;
                
            }else {
                self.reputation += 1;
                self.blockheight = current_block_height;
                self.stake_score = result;
                }
            }
        }

    pub fn update(&self, gas: &u64) -> Self {
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
		// //make origin the validator(nominator) addition here(pocs edited)
		// let _ = <pallet_staking::Pallet<T> as sp_staking::StakingInterface>::bond(
		// 	&account_stake_info.owner,
		// 	contract_stake_info.stake_score.saturated_into(),
		// 	&account_stake_info.owner,
		// ).map_err(|_| Error::<T>::BondingFailed)?;

// 		Ok(())

// 	}

