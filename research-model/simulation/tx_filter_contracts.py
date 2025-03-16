import os
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
from tqdm import tqdm
import pickle
from pygtrie import StringTrie

# Function to create an index from a Parquet file
def create_index(parquet_file_path):
    """
    Create an index of unique "to_address" values from a Parquet file.

    Args:
        parquet_file_path (str): Path to the Parquet file.

    Returns:
        set: Set of unique "to_address" values.
    """
    df = pq.read_table(parquet_file_path).to_pandas()
    index = df['to_address'].unique()
    return set(index)

# Function to check if an address is present in the trie
def is_address_present(address, trie):
    """
    Check if an address exists in the trie.

    Args:
        address (str): The address to check.
        trie (StringTrie): The trie data structure.

    Returns:
        bool: True if the address is present in the trie, False otherwise.
    """
    return trie.has_subtrie(address)

# Function to process a chunk of rows
def process_chunk(chunk, trie):
    """
    Process a chunk of rows based on address presence in the trie.

    Args:
        chunk (DataFrame): Chunk of rows from a Parquet file.
        trie (StringTrie): The trie data structure.

    Returns:
        list: List of processed rows.
    """
    return [row for _, row in chunk.iterrows() if str(row['to_address']) in trie]

# Function to process a Parquet file and save the modified data
def process_parquet(parquet_file_path, index_file_path, trie, output_folder, micro_pbar):
    """
    Process a Parquet file, filter rows using the trie, and save the modified data.

    Args:
        parquet_file_path (str): Path to the input Parquet file.
        index_file_path: The index file for address lookup (not used in the code).
        trie (StringTrie): The trie data structure.
        output_folder (str): Path to the output folder for modified Parquet files.
        micro_pbar (tqdm): Micro-progress bar for the current file.

    Returns:
        str or None: Path to the output Parquet file if modified data is saved, None otherwise.
    """
    pq_file = pq.ParquetFile(parquet_file_path)
    num_row_groups = pq_file.num_row_groups
    processed_rows = []

    for i in range(num_row_groups):
        df_chunk = pq_file.read_row_group(i).to_pandas()
        processed_rows.extend(process_chunk(df_chunk, trie))

        # Convert the processed rows to a PyArrow Table
        table = pa.Table.from_pandas(pd.DataFrame(processed_rows))

        # Serialize the table to get the data size
        data_size = table.nbytes

        # Update the progress bar with the processed data size
        micro_pbar.update(data_size)

    if processed_rows:
        # Convert the processed rows to a Pandas DataFrame
        processed_df = pd.DataFrame(processed_rows)

        # Write the modified DataFrame to a new Parquet file in the output folder
        output_parquet_file_path = os.path.join(output_folder, os.path.basename(parquet_file_path).replace(".parquet", "_modified.parquet"))
        table = pa.Table.from_pandas(processed_df)
        pq.write_table(table, output_parquet_file_path)

        return output_parquet_file_path
    else:
        return None

# Main function
def main():
    # Get input folder path and output folder path from the user during runtime
    folder_path = input("Enter the absolute path of the folder containing Parquet files: ")
    output_folder = input("Enter the absolute path of the output folder for modified Parquet files: ")

    # Load the .trie file
    trie_file_path = input("Enter the absolute path of the .trie file: ")
    trie = None
    with open(trie_file_path, 'rb') as f:
        trie = pickle.load(f)

    # Create the output folder if it doesn't exist
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Process each Parquet file in the folder
    for file_name in os.listdir(folder_path):
        if file_name.endswith(".parquet"):
            parquet_file_path = os.path.join(folder_path, file_name)
            index_file_path = create_index(parquet_file_path)

            # Create the micro progress bar for the current file
            file_size = os.path.getsize(parquet_file_path)
            micro_pbar = tqdm(total=file_size, unit='B', unit_scale=True, leave=False, desc=f"Processing {file_name}")

            output_parquet_file_path = process_parquet(parquet_file_path, index_file_path, trie, output_folder, micro_pbar)

            # Close the micro progress bar for the current file
            micro_pbar.close()

            if output_parquet_file_path:
                print(f"Modified Parquet file {file_name} has been created at: {output_parquet_file_path}")
            else:
                print(f"No matching rows found in {file_name}")

if __name__ == "__main__":
    main()
