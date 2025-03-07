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

pub const MIN_REPUTATION: u32 = 3; 
pub const MIN_DELEGATES: u32 = 10; 
pub const REPUTATION_FACTOR : u32 = 1;
pub const INITIAL_STAKE_SCORE : u128 = 0;


#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug, TypeInfo, MaxEncodedLen)]
#[scale_info(skip_type_params(T))]
pub struct DelegateInfo<T: Config> {
	owner : T::AccountId,
	delegate_to: T::AccountId,
	delegate_at: BlockNumberFor<T>,
}

impl<T: Config> DelegateInfo<T> {

    pub fn owner(&self) -> T::AccountId {
        self.owner.clone()
    }

    pub fn delegate_to(&self) -> T::AccountId {
        self.delegate_to.clone()
    }
    
    pub fn delegate_at(&self) -> BlockNumberFor<T> {
        self.delegate_at
    }
    
    pub fn get(contract_addr: &T::AccountId) -> Result<DelegateInfo<T>, DispatchError> {
        Contracts::<T>::get_delegate_info(contract_addr)
        .ok_or_else(|| Error::<T>::NoStakeExists.into())
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

    pub fn reputation(&self) -> u32 {
        self.reputation
    }
    
    pub fn blockheight(&self) -> BlockNumberFor<T> {
        self.blockheight
    }

    pub fn get(contract_addr: &T::AccountId) -> Result<StakeInfo<T>,DispatchError> {
        Contracts::<T>::get_stake_info(contract_addr)
            .ok_or_else(|| Error::<T>::NoStakeExists.into())
    }

	fn new() -> Self {
		Self{
			reputation: REPUTATION_FACTOR,
			blockheight: <frame_system::Pallet<T>>::block_number(),
			stake_score: INITIAL_STAKE_SCORE,
		}
	}

	fn reset(&self)-> Self {
		Self{
			reputation: self.reputation,
			blockheight: <frame_system::Pallet<T>>::block_number(),
			stake_score: INITIAL_STAKE_SCORE,
		}
	}

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
        Self::nominate(&delegate_info.owner,&delegate_info.delegate_to)?;
        Ok(())
    }

    pub fn delete(contract_addr: &T::AccountId){
        if StakeInfoMap::<T>::contains_key(&contract_addr) {
            StakeInfoMap::<T>::remove(&contract_addr);
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

    pub fn delegate(origin: &T::AccountId, contract_addr: &T::AccountId, delegate_to: &T::AccountId) -> Result<T::AccountId,DispatchError>{
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
            return Ok(delegate_info.delegate_to)
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

