import os
import pyarrow as pa
import pyarrow.parquet as pq
import marisa_trie
import pickle
from tqdm import tqdm
import psutil
from multiprocessing import Pool
from functools import partial
import subprocess
import shutil

# Function to check available memory
def get_available_memory():
    """
    Retrieve the available memory in gigabytes (GB).

    Returns:
        float: Available memory in GB.
    """
    available_memory_gb = psutil.virtual_memory().available / (1024 ** 3)
    return available_memory_gb

# Function to build a trie from a Parquet file
def build_trie_from_parquet(parquet_file):
    """
    Build a trie data structure from a Parquet file containing Ethereum transaction data.

    Args:
        parquet_file (str): Path to the Parquet file.

    Returns:
        marisa_trie.Trie: Trie data structure.
        str: Path to the input Parquet file.
    """
    table = pq.read_table(parquet_file)
    column_data = table['receipt_contract_address'].to_pandas()

    # Convert the 'receipt_contract_address' column data to a list of strings
    address_list = column_data.tolist()

    # Initialize the trie
    trie_root = marisa_trie.Trie(address_list)

    return trie_root, parquet_file

# Function to find missing Parquet files
def find_missing_files(folder_path, start_file_number, end_file_number):
    """
    Find missing Parquet files within a specified range of file numbers.

    Args:
        folder_path (str): Path to the folder containing Parquet files.
        start_file_number (int): Start of the file number range.
        end_file_number (int): End of the file number range.

    Returns:
        list: List of missing Parquet file names.
    """
    present_files = set()
    missing_files = []

    for filename in os.listdir(folder_path):
        if filename.endswith('.parquet'):
            file_number = int(filename.split('-')[1].split('.')[0])
            present_files.add(file_number)

    for i in range(start_file_number, end_file_number + 1):
        if i not in present_files:
            missing_files.append(f'tx-{str(i).zfill(12)}.parquet')

    return missing_files

# Function to process a Parquet file
def process_file(output_directory, file_path):
    """
    Process a Parquet file, filter data, and save the modified data to a new file.

    Args:
        output_directory (str): Directory to save the modified Parquet files.
        file_path (str): Path to the input Parquet file.

    Returns:
        str: Path to the processed Parquet file.
    """
    table = pq.read_table(file_path)
    df = table.to_pandas()
    filtered_df = df[df['to_address'].isnull() | (df['to_address'] == '0x')]

    output_file_path = os.path.join(output_directory, f"modified_{os.path.basename(file_path)}")
    modified_table = pa.Table.from_pandas(filtered_df)
    pq.write_table(modified_table, output_file_path)

    return file_path

# Function to process Parquet files in parallel
def process_parquet_files(input_directory, output_directory):
    """
    Process Parquet files in parallel, filtering data and saving the modified files.

    Args:
        input_directory (str): Directory containing input Parquet files.
        output_directory (str): Directory to save the processed Parquet files.
    """
    num_cores = psutil.cpu_count(logical=False)
    pool = Pool(processes=num_cores)

    file_paths = [os.path.join(input_directory, filename) for filename in os.listdir(input_directory) if filename.endswith(".parquet")]

    progress_bar_files = tqdm(total=len(file_paths), desc="Files", position=0)
    progress_bar_process = tqdm(total=len(file_paths), desc="Progress", position=1)

    partial_process_file = partial(process_file, output_directory)

    def update_progress_bar(*_):
        progress_bar_files.update()
        progress_bar_process.update()

    for _ in pool.imap_unordered(partial_process_file, file_paths):
        update_progress_bar()

    pool.close()
    pool.join()

    progress_bar_files.close()
    progress_bar_process.close()

# Function to merge trie files
def merge_trie_files(input_folder, output_file):
    """
    Merge trie files stored in a folder into a single trie and save it.

    Args:
        input_folder (str): Directory containing trie files.
        output_file (str): Path to the output merged trie file.
    """
    trie_data = {}
    trie_files = [file_name for file_name in os.listdir(input_folder) if file_name.endswith('.trie')]
    total_files = len(trie_files)
    with tqdm(total=total_files, desc="Merging Trie Files", unit="file") as pbar:
        for file_name in trie_files:
            with open(os.path.join(input_folder, file_name), 'rb') as file:
                trie = pickle.load(file)
                for key, value in trie.items():
                    if key in trie_data:
                        trie_data[key] += value
                    else:
                        trie_data[key] = value
            pbar.update(1)

    with open(os.path.join(input_folder, output_file), 'wb') as output:
        pickle.dump(trie_data, output)

if __name__ == "__main__":
    # Get user inputs for processing Parquet files
    input_directory = input("Enter the directory path containing parquet files: ")
    # Get the directory of the current script file
    script_directory = os.path.dirname(os.path.abspath(__file__))
    # Set the output directory to the same directory as the script
    output_directory = script_directory
    start_file_number = int(input("Enter the start file number: "))
    end_file_number = int(input("Enter the end file number: "))
    
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)

    # Check for missing files
    missing_files = find_missing_files(input_directory, start_file_number, end_file_number)

    if missing_files:
        print("Missing files:")
        for missing_file in missing_files:
            print(missing_file)
    else:
        print("No missing files found. Proceeding with find_contract_address script.")

        # Process Parquet files
        processed_output_directory = os.path.join(output_directory, "processed")
        os.makedirs(processed_output_directory, exist_ok=True)
        process_parquet_files(input_directory, processed_output_directory)

    # Build tries from processed Parquet files
    trie_output_directory = os.path.join(output_directory, "tries")
    os.makedirs(trie_output_directory, exist_ok=True)

    parquet_files = [os.path.join(processed_output_directory, filename) for filename in os.listdir(processed_output_directory) if filename.endswith(".parquet")]

    num_processes = psutil.cpu_count(logical=False)
    pool = Pool(processes=num_processes)

    try:
        progress_bar = tqdm(total=len(parquet_files), desc="Processing Parquet files", unit="file")

        for trie_root, parquet_file in pool.imap_unordered(build_trie_from_parquet, parquet_files):
            filename = os.path.splitext(os.path.basename(parquet_file))[0]

            # Save the trie to the output file using pickle in the trie_output_directory
            trie_output_file_path = os.path.join(trie_output_directory, filename + ".trie")
            with open(trie_output_file_path, 'wb') as f:
                pickle.dump(trie_root, f)

            progress_bar.update(1)

    finally:
        pool.close()
        pool.join()
        progress_bar.close()

    print("All tries have been saved to the output directory.")

    # Merge the trie files
    merged_trie_output_file_path = os.path.join(output_directory, "merged.trie")
    merge_trie_files(trie_output_directory, merged_trie_output_file_path)
    print(f"Trie files merged and saved as 'merged.trie' in the output_directory.")

    print("The 'tx_filter.py' script has been started.")
    # Construct the output_folder for tx_filter.py
    tx_filter_output_folder = os.path.join(output_directory, "tx_filtered")

    # Start the "tx_filter.py" script and pass the inputs
    tx_filter_script = os.path.join(os.path.dirname(__file__), "tx_filter.py")
    subprocess.run(["python", tx_filter_script], input=f"{input_directory}\n{tx_filter_output_folder}\n".encode())
    print("The 'tx_filter_contracts.py' script has been started.")

    # Construct the output_folder for tx_filter_contracts.py
    tx_filter_contracts_output_folder = os.path.join(output_directory, "contracts_tx")

    # Start the "tx_filter_contracts.py" script and pass the inputs
    tx_filter_contracts_script = os.path.join(os.path.dirname(__file__), "tx_filter_contracts.py")
    subprocess.run(["python", tx_filter_contracts_script], input=f"{tx_filter_output_folder}\n{tx_filter_contracts_output_folder}\n{merged_trie_output_file_path}\n".encode())
    
    # Delete the folders "processed", "tries", and "tx_filtered"
    for folder_name in ["processed", "tries", "tx_filtered"]:
            folder_path = os.path.join(script_directory, folder_name)
            if os.path.exists(folder_path):
                shutil.rmtree(folder_path)
                print(f"Deleted {folder_name} folder.")
