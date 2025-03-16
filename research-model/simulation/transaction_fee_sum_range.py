import os
import re
import pandas as pd
from tqdm import tqdm
from decimal import Decimal

# Define a function to process Parquet files in a subdirectory and calculate the total transaction fee
def process_subdirectory(subdir_path):
    total_transaction_fee = Decimal(0)
    for filename in os.listdir(subdir_path):
        if filename.endswith('.parquet'):
            file_path = os.path.join(subdir_path, filename)
            df = pd.read_parquet(file_path)
            
            # Convert transaction_fee column to Decimal
            df['transaction_fee'] = df['transaction_fee'].apply(Decimal)
            total_transaction_fee += df['transaction_fee'].sum()
    return total_transaction_fee

# Define a function to update the CSV file with the calculated total transaction fee
def update_csv(csv_path, n, total_fee):
    if os.path.exists(csv_path):
        result_df = pd.read_csv(csv_path)
        new_row = pd.DataFrame({'n': [n], 'summed_transaction_fee': [total_fee]})
        result_df = pd.concat([result_df, new_row], ignore_index=True)
    else:
        result_df = pd.DataFrame({'n': [n], 'summed_transaction_fee': [total_fee]})
    
    result_df.to_csv(csv_path, index=False)

# Main function to process subdirectories and update the CSV
def main(base_directory, output_csv):

    # Get a list of subdirectories sorted by range number
    subdirectories = [subdir for subdir in os.listdir(base_directory) if os.path.isdir(os.path.join(base_directory, subdir))]
    subdirectories = sorted(subdirectories, key=lambda x: int(re.search(r'contracts_tx_range_(\d+)', x).group(1)))
    
    # Process each subdirectory
    for subdir_name in tqdm(subdirectories, desc="Processing"):
        subdir_path = os.path.join(base_directory, subdir_name)
        total_fee = process_subdirectory(subdir_path)
        n = int(re.search(r'contracts_tx_range_(\d+)', subdir_name).group(1))
        update_csv(output_csv, n, total_fee)

if __name__ == "__main__":
    base_directory = input("Enter the base directory path: ")
    output_csv = input("Enter the output CSV path: ")
    main(base_directory, output_csv)
