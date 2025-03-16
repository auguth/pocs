import os
import pandas as pd
import numpy as np

def process_csv_files(folder_path, output_folder, project_name, specific_addresses, transaction_fee_csv):

    # Initialize data containers
    data = []
    cumulative_sum = 0
    cumulative_sum_address = 0

    # List CSV files in the folder and sort them by range
    csv_files = [filename for filename in os.listdir(folder_path)
                 if filename.startswith("contracts_tx_range_") and filename.endswith(".csv")]
    csv_files.sort(key=lambda x: int(x.split("_")[-1].split(".")[0]))
    
    # Process each CSV file
    for filename in csv_files:
        file_path = os.path.join(folder_path, filename)
        df = pd.read_csv(file_path)
        
        x_value = int(filename.split("_")[-1].split(".")[0])
        y_value = df["stake_score"].sum()
        cumulative_sum += y_value
        
        y_value_address = df[df["to_address"].isin(specific_addresses)]["stake_score"].sum()
        cumulative_sum_address += y_value_address
        
        data.append({"X1": x_value, "Y1": cumulative_sum, "Y2": cumulative_sum_address})
    
    output_df = pd.DataFrame(data)
    
    # Read the transaction fee CSV
    fee_df = pd.read_csv(transaction_fee_csv)
    
    # Convert "summed_transaction_fee" column to numeric
    fee_df["summed_transaction_fee"] = pd.to_numeric(fee_df["summed_transaction_fee"], errors="coerce")
    
    # Calculate Y3 values
    output_df["Y3"] = ((output_df["Y2"] / output_df["Y1"]) * fee_df["summed_transaction_fee"]) / 10**18
    
    # Create the output folder if it doesn't exist
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    
    # Define the path for the output CSV
    output_path_values_csv = os.path.join(output_folder, f"{project_name}_on_Ethereum_PoCS.csv")

    # Prepare data for the output CSV
    values_data = {"X1": output_df["X1"], "Y1": output_df["Y1"], "Y2": output_df["Y2"], "Y3": output_df["Y3"]}
    values_df = pd.DataFrame(values_data)

    # Save the output CSV
    values_df.to_csv(output_path_values_csv, index=False)
    
    addresses_str = '_'.join(specific_addresses)
    print(f"CSV file '{project_name}_on_Ethereum_PoCS.csv' generated successfully in the output folder.")

if __name__ == "__main__":
    input_folder = input("Enter the folder path containing stake_score CSV files: ")
    output_folder = input("Enter the output folder path: ")
    project_name = input("Enter the project name: ")
    specific_addresses_input = input("Enter the specific to_addresses separated by commas: ")
    specific_addresses = [address.strip() for address in specific_addresses_input.split(",")]
    fee_csv_path = input("Enter the path to the transaction fee CSV: ")
    
    process_csv_files(input_folder, output_folder, project_name, specific_addresses, fee_csv_path)
