#![cfg_attr(not(feature = "std"), no_std, no_main)]
#![allow(unexpected_cfgs)]

use core::fmt::Error;
use ink::env::{chain_extension::FromStatusCode, Environment};
use parity_scale_codec::{Decode, Encode};
use scale_info::TypeInfo;
use ink::prelude::*;

/// PoCS StakeDelegateExtension: Chain Extension with registered ID 1200
#[ink::chain_extension(extension = 1200)] 
pub trait StakeDelegateExtension {

    /// The error type returned by the chain extension functions
    type ErrorCode = StakeDelegateError;

    // Updates the delegate information of a deployed contract  
    // where a contract itself is the owner of another contract.  
    // Since extrinsics cannot be created, a chain extension is provided.  
    // This function can only be called by a owner contract.  
    #[ink(function = 1005, handle_status = false)]
    fn delegate(
        account_addr: <CustomEnvironment as Environment>::AccountId, 
        delegate_to: <CustomEnvironment as Environment>::AccountId
    ) -> Result<[u8; 32], StakeDelegateError>;
        
}

/// Represents possible errors that can occur in our contract
#[derive(Debug, PartialEq, Eq, Encode, Decode, TypeInfo)]
pub enum StakeDelegateError {
    DelegateInfoNotFound = 1,
    UnknownError = 2,
}

// add comments
impl From<parity_scale_codec::Error> for StakeDelegateError {

    fn from(_: parity_scale_codec::Error) -> Self {
        StakeDelegateError::UnknownError 
    }

}

/// Implements conversion from `u8` integer error code to `StakeDelegateError`
/// 
/// This allows mapping raw error codes returned by the chain extension functions into error variants
impl From<u8> for StakeDelegateError {

    fn from(value: u8) -> Self {
        match value {
            1 => StakeDelegateError::DelegateInfoNotFound,
            _ => StakeDelegateError::UnknownError,
        }
    }

}

/// Implements conversion from a `status_code` integer returned by the chain extension functions
/// 
/// Returns a `Result<(), StakeDelegateError>`. A status code of `0` indicates success
impl FromStatusCode for StakeDelegateError {
    fn from_status_code(status_code: u32) -> Result<(), Self> {
        match status_code {
            0 => Ok(()),
            1 => Err(StakeDelegateError::DelegateInfoNotFound),
            _ => Err(StakeDelegateError::UnknownError),
        }
    }
}

/// Extends the default Ink! environment while integrating the `StakeDelegateExtension`
#[derive(Debug, Clone, PartialEq, Eq)]
#[ink::scale_derive(TypeInfo)]
pub struct CustomEnvironment {}

impl Environment for CustomEnvironment {

    /// Defines the maximum number of topics that an event can have in this environment
    const MAX_EVENT_TOPICS: usize =
        <ink::env::DefaultEnvironment as Environment>::MAX_EVENT_TOPICS;
    
    /// Type alias from default environment required for our chain extension custom environment
    type AccountId = <ink::env::DefaultEnvironment as Environment>::AccountId;
    type Balance = <ink::env::DefaultEnvironment as Environment>::Balance;
    type Hash = <ink::env::DefaultEnvironment as Environment>::Hash;
    type BlockNumber = <ink::env::DefaultEnvironment as Environment>::BlockNumber;
    type Timestamp = <ink::env::DefaultEnvironment as Environment>::Timestamp;

    /// Defines `StakeDelegateExtension` as ChainExtension
    type ChainExtension = StakeDelegateExtension;

}

/// Ink! contract for updating delegate information of a contract-owned contract
#[ink::contract(env = self::CustomEnvironment)]
mod update_delegate {

    use super::*;

    /// Storage struct requirement for the contract.  
    /// It does not hold any state.
    #[ink(storage)]
    pub struct FetchDelegateTo {}

    impl Default for FetchDelegateTo {

        /// Provides a default implementation that calls the `new` constructor
        fn default() -> Self {
            Self::new()
        }

    }

    impl FetchDelegateTo {

        /// Constructor to initialize the contract.
        #[ink(constructor)]
        pub fn new() -> Self {
            Self {}
        }

        /// Updates the delegate information of a contract to `delegate_to`,
        /// where our contract is the owner of `contract_addr`
        ///
        /// # Arguments
        /// * `contract_addr` - The address of the contract whose delegate is being updated
        /// * `delegate_to` - The account ID to which delegation is assigned
        ///
        #[ink(message)]
        pub fn update_delegate(
            &self, 
            contract_addr: AccountId,
            delegate_to: AccountId
        ) -> Result<[u8; 32], StakeDelegateError> {

            let delegate_result= self.env()
                .extension()
                .delegate(contract_addr,delegate_to)
                .map_err(|_| StakeDelegateError::UnknownError)?;

                Ok(delegate_result)

        }
    }
}