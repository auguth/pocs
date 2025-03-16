import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Function to process CSV files in the specified folder and generate output files
def process_csv_files(folder_path, output_folder):
    data = [] # Initialize an empty list to store data
    cumulative_sum = 0 # Initialize a cumulative sum variable
    
    # Get a list of CSV files in the folder and sort them by range value
    csv_files = [filename for filename in os.listdir(folder_path)
                 if filename.startswith("contracts_tx_range_") and filename.endswith(".csv")]
    csv_files.sort(key=lambda x: int(x.split("_")[-1].split(".")[0]))
    
    # Loop through each CSV file in the sorted order
    for filename in csv_files:
        file_path = os.path.join(folder_path, filename)
        df = pd.read_csv(file_path) # Read the CSV file into a Pandas DataFrame
        
        # Extract X and Y values from the DataFrame
        x_value = int(filename.split("_")[-1].split(".")[0])
        y_value = df["stake_score"].sum()
        cumulative_sum += y_value
        
        # Append the X and Y values to the data list
        data.append({"X1": x_value, "Y1": cumulative_sum})
    
    # Create a new DataFrame from the collected data
    output_df = pd.DataFrame(data)
    
    # Check if the output folder exists, and create it if it doesn't
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    
    # Define output file paths for CSV and image
    output_path_csv = os.path.join(output_folder, "network_stake_supply.csv")
    output_path_img = os.path.join(output_folder, "network_stake_supply.png")
    
    # Save the DataFrame to a CSV file
    output_df.to_csv(output_path_csv, index=False)
    
    # Smooth and plot the data, and save the chart as an image
    x_smooth = np.linspace(min(output_df["X1"]), max(output_df["X1"]), 300)
    y_smooth = np.interp(x_smooth, output_df["X1"], output_df["Y1"])
    
    plt.figure(figsize=(10, 6))
    plt.fill_between(x_smooth, y_smooth, alpha=0.3)
    plt.plot(x_smooth, y_smooth,label='Stake Supply', linewidth=2)
    plt.xlabel("Ethereum PoCS Monthly Period")
    plt.ylabel("Stake Supply Amount in gas units")
    plt.title("Ethereum PoCS Network Stake Supply")
    plt.legend()
    plt.grid(True)
    plt.xticks(np.arange(min(x_smooth), max(x_smooth)+1, step=5))
    plt.savefig(output_path_img) # Save the chart as an image
    plt.close() # Close the plot

# Entry point of the script
if __name__ == "__main__":
    input_folder = input("Enter the folder path containing CSV files: ")
    output_folder = input("Enter the output folder path: ")
    
    # Call the function to process CSV files and generate output files
    process_csv_files(input_folder, output_folder)
    process_csv_files(input_folder, output_folder)
    
    # Print a success message
    print("CSV file 'network_stake_supply.csv' and chart 'network_stake_supply.png' generated successfully in the output folder.")
