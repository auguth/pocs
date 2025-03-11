#![cfg_attr(not(feature = "std"), no_std, no_main)]
#![allow(unexpected_cfgs)]

/// Ink! contract for flipping booleans
#[ink::contract]
mod flipper {

    /// Storage struct that stores the flipped boolean
    #[ink(storage)]
    pub struct Flipper {
        value: bool,
    }

    impl Default for Flipper {
        
        /// Provides a default implementation that calls the `new` constructor
        fn default() -> Self {
            Self::new()
        }
    }

    impl Flipper {

        /// Constructor to initialize the contract.
        #[ink(constructor)]
        pub fn new() -> Self {
            Self { value: false }
        }

        /// Flips and stores boolean
        #[ink(message)]
        pub fn flip(&mut self) -> bool {
            self.value = !self.value;
            self.value
        }

    }

}
