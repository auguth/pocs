// This file is part of PoCS-Substrate.
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
use crate::Config as ContractsConfig;
use codec::Encode;
use frame_support::log::error; 
use crate::{
    chain_extension::{ChainExtension, Environment, Ext, InitState, RetVal},
    stake::{DelegateInfo, StakeInfo,DelegateRequest},
};
use sp_core::crypto::UncheckedFrom;
use sp_runtime::DispatchError;
use core::marker::PhantomData;
use crate::chain_extension::RegisteredChainExtension;
use scale_info::prelude::format;

/// Chain Extension for Fetching Contract's DelegateInfo, StakeInfo 
/// 
pub struct FetchStakeInfo<T>(PhantomData<T>);

impl<T> Default for FetchStakeInfo<T> {
    fn default() -> Self {
        Self(PhantomData)
    }
}

/// Register FetchStakeInfo Chain extension id 1200
/// 
impl<T> RegisteredChainExtension<T> for FetchStakeInfo<T>
where
    T: ContractsConfig,
    T::AccountId: UncheckedFrom<T::Hash> + AsRef<[u8]>,
{
    const ID: u16 = 1200;
}

/// Implementation template provided in [`crate::chain_extension`]
/// 
impl<T> ChainExtension<T> for FetchStakeInfo<T>
where
    T: ContractsConfig, 
    T::AccountId: UncheckedFrom<T::Hash> + AsRef<[u8]>,
{
    fn call<E: Ext<T = T>>(
        &mut self,
        env: Environment<E, InitState>,
    ) -> Result<RetVal, DispatchError> {
        let func_id = env.func_id();
        let mut env = env.buf_in_buf_out(); 

        // Read contract account ID
        let contract_addr: T::AccountId = env.read_as()?;

        match func_id {
            // Get delegate_to of a contract 
            // Field of `crate::stake::DelegateInfo`
            1000 => {
                let delegate_info = DelegateInfo::<T>::get(&contract_addr)?;
                let result = delegate_info.delegate_to().encode();
                env.write(&result, false, None)?;
            }
            // Get delegate_at of a contract
            // Field of `crate::stake::DelegateInfo`
            1001 => {
                let delegate_info = DelegateInfo::<T>::get(&contract_addr)?;
                let result = delegate_info.delegate_at().encode();
                env.write(&result, false, None)?;
            }
            // Get stake_score of a contract
            // Field of `crate::stake::StakeInfo`
            1002 => {
                let stake_info = StakeInfo::<T>::get(&contract_addr)?;
                let result = stake_info.stake_score().encode();
                env.write(&result, false, None)?;
            }
            // Get reputation of a contract
            // Field of [`crate::stake::StakeInfo`]
            1003 => {
                let stake_info = StakeInfo::<T>::get(&contract_addr)?;
                let result = stake_info.reputation().encode();
                env.write(&result, false, None)?;
            }
            // Get Owner of a contract
            // Field of [`crate::stake::DelegateInfo`]
            1004 => {
                let delegate_info = DelegateInfo::<T>::get(&contract_addr)?;
                let result = delegate_info.owner().encode();
                env.write(&result, false, None)?;
            }
            // Handle unknown function IDs
            _ => {
                error!("Called an unregistered `func_id`: {}", func_id);
                return Err(DispatchError::Other("UnknownFunction"));
            }
        }
        Ok(RetVal::Converging(0)) // Return success
    }
}

/// Chain Extension for Updating Delegate of Contract Owned Contracts 
/// and to update stake owner of a contract owned contract
/// 
pub struct UpdateDelegateInfo<T>(PhantomData<T>);

impl<T> Default for UpdateDelegateInfo<T> {
    fn default() -> Self {
        Self(PhantomData)
    }
}

/// Register UpdateDelegateInfo Chain extension id 1300
///
impl<T> RegisteredChainExtension<T> for UpdateDelegateInfo<T>
where
    T: ContractsConfig,
    T::AccountId: UncheckedFrom<T::Hash> + AsRef<[u8]>,
{
    const ID: u16 = 1300;
}

/// Implementation template provided in [`crate::chain_extension`]
/// 
impl<T> ChainExtension<T> for UpdateDelegateInfo<T>
where
    T: ContractsConfig, 
    T::AccountId: UncheckedFrom<T::Hash> + AsRef<[u8]>,
{
    fn call<E: Ext<T = T>>(
        &mut self,
        env: Environment<E, InitState>,
    ) -> Result<RetVal, DispatchError> {
        let func_id = env.func_id();
        let mut env = env.buf_in_buf_out(); 

        // Read the parameters passed from the environment: 
        //
        // It includes:
        // - `contract_addr` - The contract that needs to be updated
        // - `target_addr` - The target contract for the chain extension function
        let (contract_addr, target_addr): (T::AccountId, T::AccountId) = env.read_as()?;
        
        match func_id {
            1005 => {

                // Get the current contract that is executing the chain extension
                // As passing as parameters is unsafe, cause contracts cannot sign transactions 
                // We verify that the contract calling the extension from reading its address from environment
                let executing_contract = env.ext().address();

                // Execute updating delegate which updates map [`Pallet::DelegateInfoMap`]
                // The same function call is utilized by [`Pallet::delegate`] for EOA owned contracts delegate update
                let delegate_result = <DelegateRequest<T>>::delegate(executing_contract, &contract_addr, &target_addr);

                match delegate_result {
                    Ok(()) => {
                        env.write(&[], false, None)?;
                    }
                    Err(e) => {
                        error!("Delegate failed: {:?}", e);
                        let error_message = format!("DelegateFailed: {:?}", e).encode();
                        env.write(&error_message, false, None)?;
                        return Err(e);
                    }
                }
            }

            1006 => {

                // Get the current contract that is executing the chain extension
                // As passing as parameters is unsafe, cause contracts cannot sign transactions 
                // We verify that the contract calling the extension from reading its address from environment
                let executing_contract = env.ext().address();

                // Execute updating stake owner of a contract which updates map [`Pallet::DelegateInfoMap`]
                // The same function call is utilized by [`Pallet::update_owner`] for EOA owned contracts owner update
                let update_owner_result = <DelegateRequest<T>>::update_stake_owner(executing_contract, &contract_addr, &target_addr);

                match update_owner_result {
                    Ok(()) => {
                        env.write(&[], false, None)?;
                    }
                    Err(e) => {
                        error!("UpdateOwnerFailed: {:?}", e);
                        let error_message = format!("UpdateOwnerFailed: {:?}", e).encode();
                        env.write(&error_message, false, None)?;
                        return Err(e);
                    }
                }
            }

            // Handle unknown function IDs
            _ => {
                error!("Called an unregistered `func_id`: {}", func_id);
                return Err(DispatchError::Other("UnknownFunction"));
            }
        }
        Ok(RetVal::Converging(0)) // Return success
    }
}