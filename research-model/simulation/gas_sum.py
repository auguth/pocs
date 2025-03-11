import pandas as pd
import pyarrow.parquet as pq
from multiprocessing import Pool, cpu_count
from functools import partial
import os

# Function to process a chunk of data
def process_chunk(chunk):
    # Group data by 'to_address' and calculate the sum of 'receipt_gas_used'
    grouped = chunk.groupby('to_address')['receipt_gas_used'].sum()
    return grouped.reset_index()

# Main function to process Parquet files in parallel
def main(input_folder, output_folder):
    # Get the number of available CPU cores
    num_processes = cpu_count()

    # List all Parquet files in the input folder
    input_files = [f for f in os.listdir(input_folder) if f.endswith('.parquet')]

    # Create a multiprocessing Pool
    with Pool(processes=num_processes) as pool:
        # Process each Parquet file in parallel
        for input_file in input_files:
            # Create the full input file path
            input_file_path = os.path.join(input_folder, input_file)
            # Open the Parquet file
            parquet_file = pq.ParquetFile(input_file_path)
            # Read each row group from the Parquet file and convert it to a Pandas DataFrame
            chunks = [parquet_file.read_row_group(i).to_pandas() for i in range(parquet_file.num_row_groups)]
            # Create a partial function for processing each chunk
            process_chunk_partial = partial(process_chunk)
            # Map the processing function to the chunks and get the results
            results = pool.map(process_chunk_partial, chunks)
            
            # Concatenate the results and group by 'to_address' again to obtain the final result
            final_result = pd.concat(results, ignore_index=True)
            final_result = final_result.groupby('to_address')['receipt_gas_used'].sum().reset_index()

            # Create output file path
            output_file_path = os.path.join(output_folder, input_file)

            # Create the output folder if it doesn't exist
            os.makedirs(output_folder, exist_ok=True)

            # Save the final result to a new Parquet file
            final_result.to_parquet(output_file_path, index=False)

# Entry point of the script
if __name__ == "__main__":
    # Prompt the user for the input and output folder paths
    input_folder = input("Enter the path to the input folder: ")
    output_folder = input("Enter the path to the output folder: ")
    
    # Call the main function with the provided folder paths
    main(input_folder, output_folder)
