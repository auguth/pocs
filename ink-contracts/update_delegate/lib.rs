#![cfg_attr(not(feature = "std"), no_std, no_main)]
#![allow(unexpected_cfgs)]

use ink::env::{chain_extension::FromStatusCode, Environment, ContractEnv};
use parity_scale_codec::{Decode, Encode};
use scale_info::TypeInfo;
use ink::env::call::{
    build_create,
    ExecutionInput,
    Selector,
};
use ink::ToAccountId;
use flipper::FlipperRef;


/// PoCS ChainExtension: Chain Extension with registered ID 1300
/// 
#[ink::chain_extension(extension = 1300)] 
pub trait StakeDelegateExtension {

    /// The error type returned by the message functions
    /// 
    type ErrorCode = Error;

    /// Updates the delegate of a contract which is owned by our contract
    /// 
    #[ink(function = 1005, handle_status = false)]
    fn delegate(
        account_addr: <CustomEnvironment as Environment>::AccountId, 
        delegate_to: <CustomEnvironment as Environment>::AccountId
    ) -> Result<(), Error>;
}

/// Represents possible errors that can occur in our contract
/// 
#[derive(Debug, PartialEq, Eq, Encode, Decode, TypeInfo)]
pub enum Error {
    DelegateFail = 1,
    UnknownError = 2,
}

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
            1 => Error::DelegateFail,
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
            1 => Err(Error::DelegateFail),
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
    type ChainExtension = StakeDelegateExtension;
}

// Implement ink! ContractEnv for our CustomEnvironment
impl ContractEnv for CustomEnvironment {
    type Env = CustomEnvironment;
}

/// Ink! contract for Updating Delegate of contracts that are instantiated by our contract
/// 
#[ink::contract(env = self::CustomEnvironment)]
mod update_delegate {

    use super::*;

    /// Storage struct to store the contract address of the instantiated contract
    /// 
    #[ink(storage)]
    pub struct UpdateDelegate { }

    impl Default for UpdateDelegate {

        /// Provides a default implementation that calls the `new` constructor
        /// 
        fn default() -> Self {
            Self::new()
        }
    }

    impl UpdateDelegate {

        /// Constructor to initialize the contract.
        /// 
        #[ink(constructor)]
        pub fn new() -> Self {
            Self {}
        }

        /// Updates the delegate information of our contract owned contract
        /// 
        #[ink(message)]
        pub fn update_delegate(&mut self, contract_addr: AccountId, delegate_to: AccountId ) -> Result<(), Error> {

            self.env()
                .extension()
                .delegate(contract_addr, delegate_to)
                .map_err(|_| Error::DelegateFail)?;

            Ok(())
        }

        /// Instantiates an already uploaded code hash contract
        ///
        #[ink(message)]
        pub fn deploy_contract(&mut self, code_hash: Hash, salt: i32)-> AccountId{

            let contract_ref: FlipperRef = build_create::<FlipperRef>()
                .instantiate_v1()                          
                .code_hash(code_hash)                       
                .gas_limit(0)                               
                .endowment(0)                   
                .exec_input(
                    ExecutionInput::new(Selector::new(ink::selector_bytes!("new")))
                        .push_arg(salt)                
                )
                .salt_bytes(&[0xDE, 0xAD, 0xBE, 0xEF])      
                .returns::<FlipperRef>()             
                .instantiate();                 

            contract_ref.to_account_id()

        }
    }
}