#![cfg_attr(not(feature = "std"), no_std, no_main)]
#![allow(unexpected_cfgs)]

use ink::env::{chain_extension::FromStatusCode, Environment};
use parity_scale_codec::{Decode, Encode};
use scale_info::TypeInfo;


/// PoCS ChainExtension: Chain Extension with registered ID 1200
/// 
#[ink::chain_extension(extension = 1200)]
pub trait ChainExtension {

    /// The error type returned by the message functions
    /// 
    type ErrorCode = Error;

    /// Retrieves the reputation score of the given contract
    /// 
    #[ink(function = 1003)]
    fn reputation(account_id: <CustomEnvironment as Environment>::AccountId) -> u32;
}

/// Represents possible errors that can occur in our contract
/// 
#[derive(Debug, PartialEq, Eq, Encode, Decode, TypeInfo)]
pub enum Error {
    ReputationFetchFailed = 1,
    UnknownError = 2,
}

/// Maps raw integer error codes into `Error` variants
/// 
impl From<u8> for Error {
    fn from(value: u8) -> Self {
        match value {
            1 => Error::ReputationFetchFailed,
            _ => Error::UnknownError,
        }
    }
}

/// Maps `status_code` integer to `Error` variants
/// A status code of `0` indicates success
/// 
impl FromStatusCode for Error {
    fn from_status_code(status_code: u32) -> Result<(), Self> {
        match status_code {
            0 => Ok(()),
            1 => Err(Error::ReputationFetchFailed),
            _ => Err(Error::UnknownError),
        }
    }
}

/// Custom Ink! environment integrating `ChainExtension`
/// 
#[derive(Debug, Clone, PartialEq, Eq)]
#[ink::scale_derive(TypeInfo)]
pub struct CustomEnvironment {}

impl Environment for CustomEnvironment {

    /// Defines the maximum number of topics that an event can have in this environment
    /// 
    const MAX_EVENT_TOPICS: usize =
        <ink::env::DefaultEnvironment as Environment>::MAX_EVENT_TOPICS;

    /// Type alias from default environment required for our custom environment
    /// 
    type AccountId = <ink::env::DefaultEnvironment as Environment>::AccountId;
    type Balance = <ink::env::DefaultEnvironment as Environment>::Balance;
    type Hash = <ink::env::DefaultEnvironment as Environment>::Hash;
    type BlockNumber = <ink::env::DefaultEnvironment as Environment>::BlockNumber;
    type Timestamp = <ink::env::DefaultEnvironment as Environment>::Timestamp;

    /// Integrating our ChainExtension
    /// 
    type ChainExtension = ChainExtension;

}

/// Ink! contract for retrieving the reputation score of a staked contract
/// 
#[ink::contract(env = self::CustomEnvironment)]
mod fetch_reputation {

    use super::*;

    /// Storage struct requirement for the contract.  
    /// It does not hold any state.
    /// 
    #[ink(storage)]
    pub struct FetchReputation {}

    impl Default for FetchReputation {

        /// Provides a default implementation that calls the `new` constructor
        /// 
        fn default() -> Self {
            Self::new()
        }

    }

    impl FetchReputation {

        /// Constructor to initialize the contract.
        /// 
        #[ink(constructor)]
        pub fn new() -> Self {
            Self {}
        }

        /// Fetches the reputation of a staked contract
        /// 
        #[ink(message)]
        pub fn fetch_reputation(&self, contract_addr: AccountId) -> Result<u32, Error> {
            let reputation = self.env()
                .extension()
                .reputation(contract_addr)
                .map_err(|_| Error::ReputationFetchFailed)?;
            
            Ok(reputation)
        }
    }
}
