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

    /// The error type returned by the message functions
    type ErrorCode = StakeDelegateError;

    /// Retrieves the validator `AccountId` that the given contract is delegated to
    #[ink(function = 1000)]
    fn delegate_to(contract_addr: <CustomEnvironment as Environment>::AccountId) -> [u8; 32];

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

/// Ink! contract for retrieving the validator address for which the contract is delegated to
#[ink::contract(env = self::CustomEnvironment)]
mod fetch_delegate_to {

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

        /// Fetches the validator account address of a staked contract
        #[ink(message)]
        pub fn fetch_delegate_to(&self, contract_addr: AccountId) -> Result<[u8; 32], StakeDelegateError> {
            let delegate_to = self.env()
                .extension()
                .delegate_to(contract_addr)
                .map_err(|_| StakeDelegateError::UnknownError)?;
            
            Ok(delegate_to)
        }
    }
}