import os
import glob
import pandas as pd
from multiprocessing import Pool, cpu_count
from tqdm import tqdm

# Define the columns to keep in the DataFrame
COLUMNS_TO_KEEP = ["to_address", "block_number", "receipt_gas_used"]

# Function to process a single Parquet file
def process_parquet_file(args):
    input_file, output_folder = args
    filename = os.path.basename(input_file)
    output_file = os.path.join(output_folder, filename)
    
    try:
        df = pd.read_parquet(input_file)
        
        # Keep only the specified columns in the DataFrame
        df = df[COLUMNS_TO_KEEP]
        
        # Save the modified DataFrame to a new Parquet file
        df.to_parquet(output_file, index=False)
        
    except Exception as e:
        print(f"Error processing file {input_file}: {e}")

# Main function    
def main(input_folder, output_folder):
    # Create output folder if it doesn't exist
    os.makedirs(output_folder, exist_ok=True)
    
    # Get a list of all .parquet files in the input folder
    parquet_files = glob.glob(os.path.join(input_folder, "*.parquet"))
    
    # Use multiprocessing to process files in parallel
    args_list = [(file, output_folder) for file in parquet_files]
    
    # Get the number of available CPU cores
    num_threads = cpu_count()
    print(f"Number of threads used for parallel processing: {num_threads}")

    with Pool(processes=num_threads) as pool, tqdm(total=len(args_list)) as pbar:
        for _ in pool.imap_unordered(process_parquet_file, args_list):
            pbar.update(1)

if __name__ == "__main__":
    # Prompt the user for input and output folder paths
    contracts_input_folder = input("Enter the Input Folder full path: ").strip()
    contracts_output_folder = input("Enter the Output Folder full path: ").strip()
    
    # Call the main function with the provided folder paths
    main(contracts_input_folder, contracts_output_folder)
