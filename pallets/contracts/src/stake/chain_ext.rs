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
use crate::Config as ContractsConfig;
use codec::Encode;
use frame_support::log::error; // Import logging functions
use crate::{
    chain_extension::{ChainExtension, Environment, Ext, InitState, RetVal},
    stake::{DelegateInfo, StakeInfo},
};
use sp_core::crypto::UncheckedFrom;
use sp_runtime::DispatchError;
use core::marker::PhantomData;
use crate::chain_extension::RegisteredChainExtension;


/// Chain Extension for DelegateInfo and StakeInfo
pub struct StakeDelegateExtension<T>(PhantomData<T>);

impl<T> Default for StakeDelegateExtension<T> {
    fn default() -> Self {
        Self(PhantomData)
    }
}

// registered chain extension
impl<T> RegisteredChainExtension<T> for StakeDelegateExtension<T>
where
    T: ContractsConfig,
    T::AccountId: UncheckedFrom<T::Hash> + AsRef<[u8]>,
{
    const ID: u16 = 1200;
}

impl<T> ChainExtension<T> for StakeDelegateExtension<T>
where
    T: ContractsConfig, 
    T::AccountId: UncheckedFrom<T::Hash> + AsRef<[u8]>,
{
    fn call<E: Ext<T = T>>(
        &mut self,
        env: Environment<E, InitState>,
    ) -> Result<RetVal, DispatchError> {
        let func_id = env.func_id();
        let mut env = env.buf_in_buf_out(); // Set buffer mode

        // Read contract account ID
        let contract_addr: T::AccountId = env.read_as()?;

        match func_id {
            // Get delegate_to
            1000 => {
                let delegate_info = DelegateInfo::<T>::get(&contract_addr)?;
                let result = delegate_info.delegate_to().encode();
                env.write(&result, false, None)?;
            }
            // Get delegate_at
            1001 => {
                let delegate_info = DelegateInfo::<T>::get(&contract_addr)?;
                let result = delegate_info.delegate_at().encode();
                env.write(&result, false, None)?;
            }
            // Get stake_score
            1002 => {
                let stake_info = StakeInfo::<T>::get(&contract_addr)?;
                let result = stake_info.stake_score().encode();
                env.write(&result, false, None)?;
            }
            // Get reputation
            1003 => {
                let stake_info = StakeInfo::<T>::get(&contract_addr)?;
                let result = stake_info.reputation().encode();
                env.write(&result, false, None)?;
            }
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

