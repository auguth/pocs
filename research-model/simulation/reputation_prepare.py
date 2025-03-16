import os
import pandas as pd
import multiprocessing
import pyarrow.parquet as pq

# Function to remove duplicated rows from Parquet files in a folder using Pandas with chunking
def remove_duplicates_from_parquet_folder(input_folder_path, output_folder_path):
    # Get the number of CPU cores
    num_cores = multiprocessing.cpu_count()

    # Set the chunk size to the number of CPU cores
    chunk_size = num_cores

    # Create the output folder if it doesn't exist
    if not os.path.exists(output_folder_path):
        os.makedirs(output_folder_path)

    # Iterate over all files in the input folder
    for file_name in os.listdir(input_folder_path):
        if file_name.endswith(".parquet"):
            input_file_path = os.path.join(input_folder_path, file_name)
            output_file_path = os.path.join(output_folder_path, file_name)

            # Initialize an empty DataFrame to store the processed data
            processed_data = pd.DataFrame()

            # Read the Parquet file using pyarrow.parquet.ParquetFile
            parquet_file = pq.ParquetFile(input_file_path)

            # Get the total number of row groups in the file
            num_row_groups = parquet_file.num_row_groups

            # Iterate over row groups in chunks
            for i in range(0, num_row_groups, chunk_size):
                # Read a chunk of row groups
                row_group_chunk = parquet_file.read_row_groups(range(i, min(i + chunk_size, num_row_groups)))

                # Convert the row group chunk to a DataFrame
                chunk = row_group_chunk.to_pandas()

                # Drop duplicated rows based on the two columns
                chunk = chunk.drop_duplicates(subset=['to_address', 'block_number'])

                # Append the processed chunk to the result DataFrame
                processed_data = pd.concat([processed_data, chunk])

            # Drop duplicates again after processing all chunks
            processed_data.drop_duplicates(subset=['to_address', 'block_number'], inplace=True)

            # Save the processed DataFrame to a new Parquet file
            processed_data.to_parquet(output_file_path, index=False)

# Take input folder path from the user
input_folder_path = input("Enter the path to the folder containing input Parquet files: ")
output_folder_path = input("Enter the path for the folder to save the output Parquet files: ")

# Call the function to remove duplicates using Pandas with chunking for all files in the folder
remove_duplicates_from_parquet_folder(input_folder_path, output_folder_path)
