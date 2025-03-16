
//! THIS FILE WAS AUTO-GENERATED USING THE SUBSTRATE BENCHMARK CLI VERSION 4.0.0-dev
//! DATE: 2024-01-21 (Y/M/D)
//!
//! DATABASE: `RocksDb`, RUNTIME: `Local Testnet`
//! BLOCK-NUM: `BlockId::Number(0)`
//! SKIP-WRITE: `false`, SKIP-READ: `false`, WARMUPS: `1`
//! STATE-VERSION: `V1`, STATE-CACHE-SIZE: ``
//! WEIGHT-PATH: ``
//! METRIC: `Average`, WEIGHT-MUL: `1.0`, WEIGHT-ADD: `0`

// Executed Command:
//   ./target/release/pocs
//   benchmark
//   storage
//   --state-version
//   1

/// Storage DB weights for the `Local Testnet` runtime and `RocksDb`.
pub mod constants {
	use frame_support::weights::constants;
	use sp_core::parameter_types;
	use sp_weights::RuntimeDbWeight;

	parameter_types! {
		/// By default, Substrate uses `RocksDB`, so this will be the weight used throughout
		/// the runtime.
		pub const RocksDbWeight: RuntimeDbWeight = RuntimeDbWeight {
			/// Time to read one storage item.
			/// Calculated by multiplying the *Average* of all values with `1.0` and adding `0`.
			///
			/// Stats nanoseconds:
			///   Min, Max: 1_875, 1_465_917
			///   Average:  17_746
			///   Median:   4_000
			///   Std-Dev:  140665.33
			///
			/// Percentiles nanoseconds:
			///   99th: 10_375
			///   95th: 6_625
			///   75th: 4_875
			read: 17_746 * constants::WEIGHT_REF_TIME_PER_NANOS,

			/// Time to write one storage item.
			/// Calculated by multiplying the *Average* of all values with `1.0` and adding `0`.
			///
			/// Stats nanoseconds:
			///   Min, Max: 10_500, 18_401_584
			///   Average:  195_309
			///   Median:   22_792
			///   Std-Dev:  1768366.04
			///
			/// Percentiles nanoseconds:
			///   99th: 54_375
			///   95th: 36_125
			///   75th: 27_959
			write: 195_309 * constants::WEIGHT_REF_TIME_PER_NANOS,
		};
	}

	#[cfg(test)]
	mod test_db_weights {
		use super::constants::RocksDbWeight as W;
		use sp_weights::constants;

		/// Checks that all weights exist and have sane values.
		// NOTE: If this test fails but you are sure that the generated values are fine,
		// you can delete it.
		#[test]
		fn bound() {
			// At least 1 µs.
			assert!(
				W::get().reads(1).ref_time() >= constants::WEIGHT_REF_TIME_PER_MICROS,
				"Read weight should be at least 1 µs."
			);
			assert!(
				W::get().writes(1).ref_time() >= constants::WEIGHT_REF_TIME_PER_MICROS,
				"Write weight should be at least 1 µs."
			);
			// At most 1 ms.
			assert!(
				W::get().reads(1).ref_time() <= constants::WEIGHT_REF_TIME_PER_MILLIS,
				"Read weight should be at most 1 ms."
			);
			assert!(
				W::get().writes(1).ref_time() <= constants::WEIGHT_REF_TIME_PER_MILLIS,
				"Write weight should be at most 1 ms."
			);
		}
	}
}
