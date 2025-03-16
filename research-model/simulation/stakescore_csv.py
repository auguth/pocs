import pandas as pd
import os
import shutil

# Prompt the user for the input and output folder paths
gas_used_folder = input("Enter the path to the folder containing Parquet files for 'to_address' and 'receipt_gas_used': ")
reputation_folder = input("Enter the path to the folder containing Parquet files for 'to_address' and 'reputation': ")
output_folder = input("Enter the path to the output folder: ")

# Create the output folder if it doesn't exist
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# List all the Parquet files in the input folders
gas_used_files = [file for file in os.listdir(gas_used_folder) if file.endswith('.parquet')]
reputation_files = [file for file in os.listdir(reputation_folder) if file.endswith('.parquet')]

# Process each matching pair of Parquet files
for gas_file, reputation_file in zip(gas_used_files, reputation_files):
    # Read the Parquet files into dataframes
    gas_used_df = pd.read_parquet(os.path.join(gas_used_folder, gas_file))
    reputation_df = pd.read_parquet(os.path.join(reputation_folder, reputation_file))

    # Merge the dataframes on the "to_address" column
    merged_df = pd.merge(gas_used_df, reputation_df, on='to_address', how='inner')

    # Calculate the "stake_score" as the product of "receipt_gas_used" and "reputation"
    merged_df["stake_score"] = merged_df["receipt_gas_used"] * merged_df["reputation"]

    # Select only the necessary columns "to_address" and "stake_score"
    output_df = merged_df[["to_address", "stake_score"]]

    # Save the output as a CSV file in the output folder
    output_file_name = os.path.splitext(gas_file)[0] + ".csv"  # Use the same input file name with .csv extension
    output_csv_path = os.path.join(output_folder, output_file_name)
    output_df.to_csv(output_csv_path, index=False)

print("Output CSV files have been created successfully.")
