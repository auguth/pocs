import os
import pandas as pd
import concurrent.futures
from tqdm import tqdm

# Define a function to process and add the 'transaction_fee' column to a Parquet file
def process_parquet_file(file_path):
    # Load the Parquet file into a DataFrame
    df = pd.read_parquet(file_path)
    
    # Calculate the transaction fee column
    df["transaction_fee"] = df["receipt_gas_used"] * df["gas_price"]
    
    # Save the updated DataFrame back to the Parquet file
    df.to_parquet(file_path, index=False)
    
    return file_path

# Define a function to add the 'transaction_fee' column to Parquet files in parallel
def add_transaction_fee_parallel(directory_path):
    parquet_files = []
    
    # Traverse the directory and gather a list of Parquet files
    for root, _, files in os.walk(directory_path):
        for file in files:
            if file.endswith(".parquet"):
                file_path = os.path.join(root, file)
                parquet_files.append(file_path)
    
    # Use a ThreadPoolExecutor to process files in parallel
    with concurrent.futures.ThreadPoolExecutor(max_workers=os.cpu_count()) as executor:
        results = list(tqdm(executor.map(process_parquet_file, parquet_files), total=len(parquet_files)))
    
    print("Added 'transaction_fee' column to all Parquet files:")
    for result in results:
        print(result)

# Prompt the user for the directory path
directory_path = input("Enter the directory path: ")
add_transaction_fee_parallel(directory_path)
