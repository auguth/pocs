use crate::{Config as ContractsConfig, Pallet as ContractsPallet};
use codec::Encode;
use frame_support::log::{error, info}; // Import logging functions
use crate::{
    chain_extension::{ChainExtension, Environment, Ext, InitState, RetVal},
    stake::{DelegateInfo, StakeInfo},
};
use sp_core::crypto::UncheckedFrom;
use sp_runtime::DispatchError;
use core::marker::PhantomData;

/// Chain Extension for DelegateInfo and StakeInfo
pub struct StakeDelegateExtension<T>(PhantomData<T>);

impl<T> Default for StakeDelegateExtension<T> {
    fn default() -> Self {
        Self(PhantomData)
    }
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
            // Handle unknown function IDs
            _ => {
                error!("Called an unregistered `func_id`: {}", func_id);
                return Err(DispatchError::Other("UnknownFunction"));
            }
        }
        Ok(RetVal::Converging(0)) // Return success
    }
}
