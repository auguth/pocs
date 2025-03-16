import os
import pyarrow as pa
import pyarrow.parquet as pq
import pandas as pd
import multiprocessing

# Define the function to process and save Parquet files
def process_and_save(parquet_file, output_folder, range_data):
    try:
        print(f"Processing: {parquet_file}")
        
		# Read the Parquet file into a table
        table = pq.read_table(parquet_file)
        df = table.to_pandas()

		# Extract filename and range data
        filename = os.path.basename(parquet_file)
        range_number, start_block, end_block = range_data
        
		# Filter the DataFrame based on block number range
        filtered_df = df[(df['block_number'] >= start_block) & (df['block_number'] <= end_block)]
            
        if not filtered_df.empty:  # Only create folder and file if data exists in the range
            # Create a folder specific to the range
            range_folder = os.path.join(output_folder, f"contracts_tx_range_{range_number}")
            os.makedirs(range_folder, exist_ok=True)
            
			# Define the output file path
            output_filename = f"range_{range_number}_{filename}"
            output_path = os.path.join(range_folder, output_filename)
            
			# Convert filtered DataFrame to a Parquet table and save it
            filtered_table = pa.Table.from_pandas(filtered_df)
            pq.write_table(filtered_table, output_path)
            print(f"Processed range {range_number}: {output_filename}")
        else:
            print(f"No data in range {range_number} for {parquet_file}")
        
        print(f"Processing complete: {parquet_file}")
    except Exception as e:
        print(f"Error processing {parquet_file}: {e}")

# Define the function to process a Parquet file for multiple ranges
def process_file(input_folder, output_folder, file_name, ranges):
    input_path = os.path.join(input_folder, file_name)
    for range_data in ranges:
        process_and_save(input_path, output_folder, range_data)

if __name__ == "__main__":
    # Get input and output folder paths from user
    input_folder = input("Enter the path to the input folder: ").strip()
    output_folder = input("Enter the path to the output folder: ").strip()

    # Create the output folder if it doesn't exist
    os.makedirs(output_folder, exist_ok=True)
    
	# Define the block ranges for processing
    ranges = [
      (1, 0, 210000),
      (2, 210001, 420000),
      (3, 420001, 630000),
	  (4, 630001, 840000),
	  (5, 840001, 1050000),
	  (6, 1050001, 1260000),
      (7, 1260001, 1470000),
	  (8, 1470001, 1680000),
	  (9, 1680001, 1890000),
	  (10, 1890001, 2100000),
	  (11, 2100001, 2310000),
	  (12, 2310001, 2520000),
	  (13, 2520001, 2730000),
	  (14, 2730001, 2940000),
	  (15, 2940001, 3150000),
	  (16, 3150001, 3360000),
	  (17, 3360001, 3570000),
	  (18, 3570001, 3780000),
	  (19, 3780001, 3990000),
	  (20, 3990001, 4200000),
	  (21, 4200001, 4410000),
	  (22, 4410001, 4620000),
	  (23, 4620001, 4830000),
	  (24, 4830001, 5040000),
	  (25, 5040001, 5250000),
	  (26, 5250001, 5460000),
	  (27, 5460001, 5670000),
	  (28, 5670001, 5880000),
	  (29, 5880001, 6090000),
	  (30, 6090001, 6300000),
	  (31, 6300001, 6510000),
	  (32, 6510001, 6720000),
	  (33, 6720001, 6930000),
	  (34, 6930001, 7140000),
	  (35, 7140001, 7350000),
	  (36, 7350001, 7560000),
	  (37, 7560001, 7770000),
	  (38, 7770001, 7980000),
	  (39, 7980001, 8190000),
	  (40, 8190001, 8400000),
	  (41, 8400001, 8610000),
	  (42, 8610001, 8820000),
	  (43, 8820001, 9030000),
	  (44, 9030001, 9240000),
	  (45, 9240001, 9450000),
	  (46, 9450001, 9660000),
	  (47, 9660001, 9870000),
	  (48, 9870001, 10080000),
	  (49, 10080001, 10290000),
	  (50, 10290001, 10500000),
	  (51, 10500001, 10710000),
	  (52, 10710001, 10920000),
	  (53, 10920001, 11130000),
	  (54, 11130001, 11340000),
	  (55, 11340001, 11550000),
	  (56, 11550001, 11760000),
	  (57, 11760001, 11970000),
	  (58, 11970001, 12180000),
	  (59, 12180001, 12390000),
	  (60, 12390001, 12600000),
	  (61, 12600001, 12810000),
	  (62, 12810001, 13020000),
	  (63, 13020001, 13230000),
	  (64, 13230001, 13440000),
	  (65, 13440001, 13650000),
	  (66, 13650001, 13860000),
	  (67, 13860001, 14070000),
	  (68, 14070001, 14280000),
	  (69, 14280001, 14490000),
	  (70, 14490001, 14700000),
	  (71, 14700001, 14910000),
	  (72, 14910001, 15120000),
	  (73, 15120001, 15330000),
	  (74, 15330001, 15540000),
	  (75, 15540001, 15750000),
	  (76, 15750001, 15960000),
	  (77, 15960001, 16170000),
	  (78, 16170001, 16380000),
	  (79, 16380001, 16590000),
	  (80, 16590001, 16800000),
	  (81, 16800001, 17010000),
	  (82, 17010001, 17220000),
	  (83, 17220001, 17430000),
	  (84, 17430001, 17640000),
      (85, 17640001, 17850000),
      (86, 17850002, 18060000)
    ]

    num_processes = multiprocessing.cpu_count()  # Get the number of available CPU cores
    with multiprocessing.Pool(processes=num_processes) as pool:
        file_names = [file_name for file_name in os.listdir(input_folder) if file_name.endswith(".parquet")]
        print("List of files:", file_names)

		# Process each file in parallel using a pool of processes
        pool.starmap(process_file, [(input_folder, output_folder, file_name, ranges) for file_name in file_names])
        print("All files processed.")