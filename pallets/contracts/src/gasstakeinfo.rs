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

//! This module contains contract's stake score structure and implementation 

use codec::{Decode, Encode, MaxEncodedLen};
use scale_info::TypeInfo;
use sp_runtime::{
	traits::{Saturating},
	RuntimeDebug,
};
use sp_std::{prelude::*};
use frame_system::{pallet_prelude::BlockNumberFor,};



/// Struct to hold the delegation details of a deployed contract,
/// i.e., the owner of the contract, the account to which it is delegated,
/// and the block number when the delegation was set.
#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct AccountStakeinfo<T: frame_system::Config> {
	pub owner : T::AccountId,
	pub delegate_to: T::AccountId,
	pub delegate_at: BlockNumberFor<T>,
}


/// Struct to track the usage metrics of a contract,
/// i.e reputation score and the block height of its most recent usage.
#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct ContractScarcityInfo<T: frame_system::Config> {
	pub reputation: u64,
	pub recent_blockheight: BlockNumberFor<T>,
	pub stake_score: u128,
}

impl<T: frame_system::Config> AccountStakeinfo<T> {

    /// Update the delegate information for a contract.
    pub fn set_new_stakeinfo(
		owner: T::AccountId,
        delegate_to: T::AccountId,
	) -> Self{
		// Get the current block number.
		let current_block_number = <frame_system::Pallet<T>>::block_number();
		// Create and return a new AccountStakeinfo instance.
		Self {
			owner,
			delegate_to,
			delegate_at:current_block_number,
		}
	}
    /// Create a new stake info instance
     pub fn new_stakeinfo(
		owner: T::AccountId,
	) -> Self {
		// Get the current block number.
		let current_block_number = <frame_system::Pallet<T>>::block_number();
		// Set developer account address for delegate_to, as it's the initial delegation.
		let delegate_to = owner.clone();
		// Create and return a new AccountStakeinfo instance.
		Self {
			owner: owner.clone(),
            delegate_to,
			delegate_at:current_block_number,
		}
	}
}

impl<T: frame_system::Config> ContractScarcityInfo<T>{
    /// Initialize the scarcity information for a contract, 
	pub fn set_scarcity_info()->Self{
		// Get the current block number.
		let current_block_number = <frame_system::Pallet<T>>::block_number();
		// Create and return a new ContractScarcityInfo instance with default values.
		Self{
			reputation: 1,
			recent_blockheight: current_block_number,
			stake_score: 0,
		}
	}
    /// Updates the contract's reputation based on its usage.
	pub fn update_scarcity_info(
		current_reputation: u64,
		old_block_height: BlockNumberFor<T>,
		old_stake_score: u128,
		current_stake_score: u128,
	)-> Self{
		// Get the current block number.
		let current_block_height = <frame_system::Pallet<T>>::block_number();
		// Prevent updating stake score multiple times within the same block height.
		if current_block_height > old_block_height{
		// Increase reputation and update recent_block_height.
		let new_reputation = current_reputation + 1;
		let new_recent_blockheight = current_block_height;
		// Create and return a new ContractScarcityInfo instance.
		Self{
			reputation: new_reputation,
			recent_blockheight: new_recent_blockheight,
			stake_score: current_stake_score,
		}
		}
		else{
		 // Contract hasn't been used; no change in reputation.
         // Return a new ContractScarcityInfo instance with the same values.
		 let new_reputation = current_reputation;
		 let new_recent_blockheight = old_block_height;
		 Self{
			reputation: new_reputation,
			recent_blockheight: new_recent_blockheight,
			stake_score: old_stake_score,
		}
		}	
	}
}
