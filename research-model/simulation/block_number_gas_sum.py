import pandas as pd
import pyarrow.parquet as pq
from multiprocessing import Pool, cpu_count
from functools import partial
import os

def process_chunk(chunk):
    grouped = chunk.groupby('block_number')['receipt_gas_used'].sum()
    return grouped.reset_index()

def main(input_folder, output_folder):
    num_processes = cpu_count()
    input_files = [f for f in os.listdir(input_folder) if f.endswith('.parquet')]

    with Pool(processes=num_processes) as pool:
        for input_file in input_files:
            input_file_path = os.path.join(input_folder, input_file)
            parquet_file = pq.ParquetFile(input_file_path)
            chunks = [parquet_file.read_row_group(i).to_pandas() for i in range(parquet_file.num_row_groups)]

            process_chunk_partial = partial(process_chunk)
            results = pool.map(process_chunk_partial, chunks)

            final_result = pd.concat(results, ignore_index=True)
            final_result = final_result.groupby('block_number')['receipt_gas_used'].sum().reset_index()

            # Create output file path
            output_file_path = os.path.join(output_folder, input_file)

            # Create the output folder if it doesn't exist
            os.makedirs(output_folder, exist_ok=True)

            # Save the final result to a new Parquet file
            final_result.to_parquet(output_file_path, index=False)

if __name__ == "__main__":
    input_folder = input("Enter the path to the input folder: ")
    output_folder = input("Enter the path to the output folder: ")

    main(input_folder, output_folder)
