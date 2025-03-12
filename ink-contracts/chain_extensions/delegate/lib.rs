#![cfg_attr(not(feature = "std"), no_std, no_main)]
#![allow(unexpected_cfgs)]

use ink::env::{chain_extension::FromStatusCode, Environment};
use parity_scale_codec::{Decode, Encode};
use scale_info::TypeInfo;

/// PoCS ChainExtension: Chain Extension with registered ID 1200
/// 
#[ink::chain_extension(extension = 1200)] 
pub trait ChainExtension {

    /// The error type returned by the chain extension functions
    /// 
    type ErrorCode = Error;

    /// Updates the delegate information of a deployed contract  
    /// where a contract itself is the owner of another contract.  
    /// Since extrinsics cannot be created, a chain extension is provided.  
    /// This function can only be called by a owner contract.  
    ///
    #[ink(function = 1005, handle_status = false)]
    fn delegate(
        account_addr: <CustomEnvironment as Environment>::AccountId, 
        delegate_to: <CustomEnvironment as Environment>::AccountId
    ) -> Result<[u8; 32], Error>;
        
}

/// Represents possible errors that can occur in our contract
/// 
#[derive(Debug, PartialEq, Eq, Encode, Decode, TypeInfo)]
pub enum Error {
    DelegateUpdateFailed = 1,
    UnknownError = 2,
}

/// Implements Scale Codec Error to `Error`
/// 
impl From<parity_scale_codec::Error> for Error {

    fn from(_: parity_scale_codec::Error) -> Self {
        Error::UnknownError 
    }

}

/// Maps raw integer error codes into `Error` variants
/// 
impl From<u8> for Error {

    fn from(value: u8) -> Self {
        match value {
            1 => Error::DelegateUpdateFailed,
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
            1 => Err(Error::DelegateUpdateFailed),
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
    
    /// Type alias from default environment required for our chain extension custom environment
    /// 
    type AccountId = <ink::env::DefaultEnvironment as Environment>::AccountId;
    type Balance = <ink::env::DefaultEnvironment as Environment>::Balance;
    type Hash = <ink::env::DefaultEnvironment as Environment>::Hash;
    type BlockNumber = <ink::env::DefaultEnvironment as Environment>::BlockNumber;
    type Timestamp = <ink::env::DefaultEnvironment as Environment>::Timestamp;

    /// Integrating our ChainExtension
    type ChainExtension = ChainExtension;

}

/// Ink! contract for updating delegate information of a contract-owned contract
/// 
#[ink::contract(env = self::CustomEnvironment)]
mod update_delegate {

    use super::*;

    /// Storage struct requirement for the contract.  
    /// It does not hold any state.
    /// 
    #[ink(storage)]
    pub struct FetchDelegateTo {}

    impl Default for FetchDelegateTo {

        /// Provides a default implementation that calls the `new` constructor
        /// 
        fn default() -> Self {
            Self::new()
        }

    }

    impl FetchDelegateTo {

        /// Constructor to initialize the contract.
        /// 
        #[ink(constructor)]
        pub fn new() -> Self {
            Self {}
        }

        /// Updates the delegate information of a contract to `delegate_to`,
        /// where our contract is the owner of `contract_addr`
        ///
        /// It Includes
        /// - `contract_addr` - The address of the contract whose delegate is being updated
        /// - `delegate_to` - The account ID to which delegation is assigned
        ///
        #[ink(message)]
        pub fn update_delegate(
            &self, 
            contract_addr: AccountId,
            delegate_to: AccountId
        ) -> Result<[u8; 32], Error> {

            let delegate_result= self.env()
                .extension()
                .delegate(contract_addr,delegate_to)
                .map_err(|_| Error::DelegateUpdateFailed)?;

                Ok(delegate_result)

        }
    }
}