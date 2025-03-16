#![cfg_attr(not(feature = "std"), no_std, no_main)]
#![allow(unexpected_cfgs)]

use ink::env::{
        call::{build_call, Call, ExecutionInput, Selector},
        DefaultEnvironment,
    };

/// Ink! contract for simply calling another contract
/// 
#[ink::contract]
mod simple_caller {
    
    use super::*;

    /// Storage struct requirement for the contract.  
    /// It does not hold any state.
    /// 
    #[ink(storage)]
    pub struct Caller {}

    impl Default for Caller {
        
        /// Provides a default implementation that calls the `new` constructor
        /// 
        fn default() -> Self {
            Self::new()
        }
    }

    impl Caller {

        /// Constructor to initialize the contract.
        /// 
        #[ink(constructor)]
        pub fn new() -> Self {
            Self {}
        }

        /// Calls the specified contract
        /// 
        #[ink(message)]
        pub fn call(
            &mut self,
            contract_addr: AccountId,
        ) {
            build_call::<DefaultEnvironment>()
                .call_type(Call::new(contract_addr))
                .exec_input(ExecutionInput::new(Selector::new(ink::selector_bytes!("flip"))))
                .returns::<bool>()
                .invoke();
        }

    }
}
