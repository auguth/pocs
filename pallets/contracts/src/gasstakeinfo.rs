use codec::{Decode, Encode, MaxEncodedLen};
use scale_info::TypeInfo;
use sp_runtime::{
	traits::{Saturating},
	RuntimeDebug,
};
use sp_std::{prelude::*};
use frame_system::{pallet_prelude::BlockNumberFor,};



#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct AccountStakeinfo<T: frame_system::Config> {
	pub owner : T::AccountId,
	pub delegate_to: T::AccountId,
	pub delegate_at: BlockNumberFor<T>,
}


#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct ContractScarcityInfo<T: frame_system::Config> {
	pub reputation: u64,
	pub recent_blockhight: BlockNumberFor<T>,
}

impl<T: frame_system::Config> AccountStakeinfo<T> {

    pub fn set_new_stakeinfo(
		owner: T::AccountId,
        delegate_to: T::AccountId,
	) -> Self{
		let current_block_number = <frame_system::Pallet<T>>::block_number();
		Self {
            
			owner,
            delegate_to,
			delegate_at:current_block_number,
		}
	}

	pub fn new_stakeinfo(
		owner: T::AccountId,
	) -> Self {
		let current_block_number = <frame_system::Pallet<T>>::block_number();
		let delegate_to = owner.clone();
		Self {
			owner: owner.clone(),
            delegate_to,
			delegate_at:current_block_number,
		}
	}

}

impl<T: frame_system::Config> ContractScarcityInfo<T>{

	pub fn set_scarcity_info()->Self{

		let current_block_number = <frame_system::Pallet<T>>::block_number();
		Self{
			reputation: 1,
			recent_blockhight: current_block_number,
		}
	}

	pub fn update_scarcity_info(
		current_reputation: u64,
		old_block_hight: BlockNumberFor<T>,
	)-> Self{

		let current_block_hight = <frame_system::Pallet<T>>::block_number();

		if current_block_hight > old_block_hight{
		let new_reputation = current_reputation + 1;
		let new_recent_blockhight = current_block_hight;

		Self{

			reputation: new_reputation,
			recent_blockhight: new_recent_blockhight,
		}
		}
		else{

		 let new_reputation = current_reputation;
		 let new_recent_blockhight = old_block_hight;

		 Self{

			reputation: new_reputation,
			recent_blockhight: new_recent_blockhight,
		}
		}
		
	}


}