#![cfg_attr(not(feature = "std"), no_std, no_main)]
#![allow(unexpected_cfgs)]

use ink::storage::Mapping;
use ink::env::{chain_extension::FromStatusCode, Environment};
use parity_scale_codec::{Decode, Encode};
use scale_info::TypeInfo;

/// PoCS StakeDelegateExtension: Chain Extension with registered ID 1200
#[ink::chain_extension(extension = 1200)]
pub trait StakeDelegateExtension {

    /// The error type returned by the message functions
    type ErrorCode = StakeDelegateError;

    /// Retrieves the validator `AccountId` that the given contract is delegated to
    #[ink(function = 1000)]
    fn delegate_of(account_id: <CustomEnvironment as Environment>::AccountId) 
        -> <CustomEnvironment as Environment>::AccountId;

    /// Retrieves the block number at which the contract last updated its delegate information
    #[ink(function = 1001)]
    fn delegate_at(account_id: <CustomEnvironment as Environment>::AccountId) -> u32;

    /// Retrieves the stake score associated with the given contract
    #[ink(function = 1002)]
    fn stake_score(account_id: <CustomEnvironment as Environment>::AccountId) -> u128;

    /// Retrieves the reputation score of the given contract
    #[ink(function = 1003)]
    fn reputation(account_id: <CustomEnvironment as Environment>::AccountId) -> u32;

    /// Retrieves the `AccountId` of the owner of the given contract
    #[ink(function = 1004)]
    fn owner(account_id: <CustomEnvironment as Environment>::AccountId) 
        -> <CustomEnvironment as Environment>::AccountId;
}


/// Represents possible errors that can occur in our contract
#[derive(Debug, PartialEq, Eq, Encode, Decode, TypeInfo)]
pub enum StakeDelegateError {
    /// The provided contract address is not delegated to our contract
    InvalidDelegate = 1,

    /// The stake score is insufficient to claim rewards
    InsufficientStakeScore = 2,

    /// The caller is not the valid owner of the contract attempting operations
    InvalidContractOwner = 3,

    /// Insufficient balance to process the reward claim
    InsufficientFunds = 4,

    /// The registered contract address has updated its delegate information after registration
    InvalidRegistration = 5,

    /// No reward has been allocated for the given contract address
    NoRewardAllocated = 6,

    /// Transfer operation failed due to an unknown error
    TransferFailed = 7,

    /// An unknown or unspecified error occurred
    UnknownError = 8,
}

/// Implements conversion from `u8` integer error code to `StakeDelegateError`
/// 
/// This allows mapping raw error codes returned by the chain extension functions into error variants
impl From<u8> for StakeDelegateError {

    fn from(value: u8) -> Self {
        match value {
            1 => StakeDelegateError::InvalidDelegate,
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
            1 => Err(StakeDelegateError::InvalidDelegate),
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

/// Ink! contract for managing stake delegation and reward distribution
#[ink::contract(env = self::CustomEnvironment)]
mod delegate_registry {

    use super::*;

    /// Storage structure for the Delegate Registry.
    #[ink(storage)]
    pub struct DelegateRegistry {
        /// Mapping of contract addresses to their registration time delegation info
        /// - `u32` represents the block number when delegation was updated
        /// - `u128` represents the stake score at registration time
        delegates: Mapping<AccountId, (u32, u128)>,
        ///
        /// Total stake score pool accumulated in the contract
        /// Maps to total balance of our contract excluding minimum balance (existential deposit)
        pool: u128,
    }

    impl DelegateRegistry {

        /// Initializes a new `DelegateRegistry` instance during instantiation of our contract
        #[ink(constructor)]
        pub fn new() -> Self {
            Self {
                delegates: Mapping::default(),
                pool: 0,
            }
        }

        /// Registers a contract in the `DelegateRegistry` mapping
        ///
        /// This function performs the following:
        /// 1. Ensures the caller is the owner of the contract
        /// 2. Ensures the contract is properly delegated to our contract as validator
        /// 3. Fetches the contract's stake score and delegation blocknumber
        /// 4. Stores the contract's delegation data in the `DelegateRegistry`
        /// 5. Updates the total stake pool by adding the contract's stake score
        ///
        #[ink(message)]
        pub fn register(&mut self, contract: AccountId) -> Result<(), StakeDelegateError> {

            // Ensure that the caller is the contract owner
            self.owner_check(contract)?;

            // Ensure that the contract is properly delegated
            self.delegate_check(contract)?;

            // Retrieve stake score and delegation timestamp from the chain extension
            let stake_score = self.env().extension().stake_score(contract)?;
            let delegate_at = self.env().extension().delegate_at(contract)?;

            // Store the delegation details in the mapping
            let value = (delegate_at, stake_score);
            self.delegates.insert(contract, &value);

             // Update the total stake pool
            self.pool = self.pool.saturating_add(stake_score);

            Ok(())
        }

        /// Claims rewards for a registered contract by updating its current stake score
        ///
        /// This function performs the following steps:
        /// 1. Ensures the caller is the contract owner
        /// 2. Checks if the contract is already registered and retrieves its stored delegation data
        /// 3. Fetches the contract’s latest stake score from the chain extension
        /// 4. Calculates the stake difference and processes the reward allocation and transfer
        /// 5. Updates the stored delegation data with the new stake score
        ///
        #[ink(message)]
        pub fn claim(&mut self, contract: AccountId) -> Result<(), StakeDelegateError> {

            // Ensure that the caller is the owner of the contract
            self.owner_check(contract)?;

             // Check if the contract is registered in `DelegateRegistry` and retrieve stored delegation details
            let (delegate_at,old_stake_score) = self.registration_check(contract)?;

            // Fetch the updated stake score from the chain extension
            let new_stake_score = self.env().extension().stake_score(contract)?;

            // Further process reward allocation based on stake increase
            self.ping(contract, new_stake_score,old_stake_score)?;

            // Update the stored delegation details with the new stake score
            let value = (delegate_at, new_stake_score);
            self.delegates.insert(contract, &value);

            Ok(())
        }

        #[ink(message)]
        pub fn cancel(&mut self, contract: AccountId) -> Result<(), StakeDelegateError> {
            self.claim(contract)?;
            self.delegates.remove(contract);
            Ok(())
        }

        /// Processes the stake score difference and allocates rewards if applicable.
        ///
        /// This helper function calculates the increase in stake score and updates the pool.
        /// If the stake score has increased, it transfers the corresponding rewards.
        ///
        fn ping(
            &mut self, 
            contract: AccountId, 
            new_stake_score: u128,
            old_stake_score: u128) -> Result<(), StakeDelegateError>
        {
            // Calculate the difference in stake score
            let difference = new_stake_score.saturating_sub(old_stake_score);

            // If no stake increase, return an error (no rewards allocated)
            if difference < 1 { return Err(StakeDelegateError::NoRewardAllocated)}

            // Increase the total stake pool
            self.pool = self.pool.saturating_add(difference);

            // Transfer the allocated rewards to the contract owner
            self.transfer(contract,difference)?;

            Ok(())
        }

        /// Transfers the allocated reward to the specified contract's owner account.
        ///
        /// This helper function calculates the transferable amount based on the contract's balance,
        /// ensuring it does not fall below the minimum balance.
        fn transfer(
            &mut self, 
            contract:AccountId, 
            difference: u128) -> Result<(), StakeDelegateError>
        {
            // Fetch the contract owner
            let owner = self.env().extension().owner(contract)?;

            // Get the contract's current balance and minimum required balance
            let balance = self.env().balance();
            let minimum_balance = self.env().minimum_balance();

             // If the contract balance is at the minimum (existential deposit), no rewards can be transferred
            if balance == minimum_balance {return Err(StakeDelegateError::InsufficientFunds)}

            // Calculate the transferable reward amount using a proportional distribution formula:
            // to_transfer = ((Balance * Stake Score) + (Pool / 2)) / Pool
            //
            // This formula ensures fair reward distribution based on stake scores while avoiding
            // rounding errors since floating-point arithmetic is not available in ink!.
            let to_transfer = ((difference.saturating_mul(balance))
                                .saturating_add(self.pool.saturating_div(2)))
                                .checked_div(self.pool).unwrap_or(0);

            // Ensure the transfer does not cause the balance to drop below the minimum
            let final_transfer_amount = if balance.saturating_sub(to_transfer) < minimum_balance {
                to_transfer.saturating_sub(minimum_balance)
            } else {
                to_transfer
            };

            // Attempt to transfer the calculated reward to the owner
            self.env().transfer(owner, final_transfer_amount)
                .map_err(|_| StakeDelegateError::TransferFailed)?;

            // Deduct the transferred amount from the pool
            self.pool = self.pool.saturating_sub(difference);

            Ok(())

        }

        /// Checks if the caller is the owner of a specified contract
        ///
        /// This helper function ensures that only the owner of a contract can carry on operations,
        /// such as registering or claiming rewards.
        /// 
        fn owner_check(&mut self, contract:AccountId) -> Result<(), StakeDelegateError>{

            // Fetch the registered owner of the contract from the chain extension
            // Compare with the caller of the transaction
            if self.env().extension().owner(contract)? != self.env().caller() {
                return Err(StakeDelegateError::InvalidContractOwner)
            }

            Ok(())

        }

        /// Verifies if a given contract is registered to us and has valid delegation information
        /// returns the valid tuple value in the `delegates` mapping 
        ///
        /// This helper function checks:
        /// - If the contract exists in the `delegates` mapping
        /// - If the contract's delegation info is consistent with the latest chain extension data
        /// 
        fn registration_check(&mut self, contract:AccountId) -> Result<(u32,u128), StakeDelegateError>{

            // Ensure the contract is present in the local delegate registry
            if !self.delegates.contains(contract) {
                return Err(StakeDelegateError::InvalidDelegate);
            }

            // Retrieve stored delegation data (block number & stake score)
            let (delegate_at,stake_score) = self.delegates.get(contract).unwrap();

            // Fetch the latest delegation timestamp from the chain extension
            let new_delegate_at = self.env().extension().delegate_at(contract)?;

            // Ensure that the stored delegation timestamp matches the latest value on-chain.
            // If the timestamp has changed, it indicates that the contract updated its delegate information
            // without notifying our reward contract by first canceling via the `cancel` function.
            // This prevents outdated or inconsistent delegation data in our local storage.
            //
            // Additionally, failing to properly cancel before updating delegation causes **pool inflation**.
            // The previous stake score's rewards remain unclaimed and cannot be retrieved, 
            //
            if delegate_at != new_delegate_at {
                return Err(StakeDelegateError::InvalidRegistration);
            }

            Ok((delegate_at,stake_score))
            
        }

        /// Checks if a given contract is delegated to our contract as a validator
        /// This ensures that only contracts properly delegated to our contract can interact with us
        /// 
        fn delegate_check(&mut self, contract:AccountId) -> Result<(), StakeDelegateError>{

            // Fetch the delegate information for the contract from the chain extension
            // Verify that the contract is delegated to this contract instance
            if self.env().extension().delegate_of(contract)? != self.env().account_id(){
                return Err(StakeDelegateError::InvalidDelegate)
            }

            Ok(())
        }
        
    }
}