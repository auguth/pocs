import os
import pyarrow.parquet as pq
import pandas as pd
import pyarrow  # Add this line

# Input folder path as user input
input_folder = input("Enter the path to the input folder: ")

# Output folder path as user input
output_folder = input("Enter the path to the output folder: ")

# Create the output folder if it doesn't exist
os.makedirs(output_folder, exist_ok=True)

# Function to process each Parquet file
def process_parquet_file(file_path):
    table = pq.read_table(file_path)
    df = table.to_pandas()
    
    # Group by 'to_address' and count the rows for each address
    grouped = df.groupby('to_address').size().reset_index(name='reputation')
    
    # Get the original file name (without extension)
    file_name = os.path.splitext(os.path.basename(file_path))[0]
    
    # Create a new Parquet table from the grouped data
    new_table = pyarrow.Table.from_pandas(grouped)  # Corrected here
    
    # Construct the output file path with the same name as the input
    output_file_path = os.path.join(output_folder, f'{file_name}.parquet')
    
    # Write the new Parquet table to the output file
    pq.write_table(new_table, output_file_path)

# Process each Parquet file in the input folder
for file_name in os.listdir(input_folder):
    if file_name.endswith('.parquet'):
        file_path = os.path.join(input_folder, file_name)
        process_parquet_file(file_path)

print("Processing completed. Modified files saved in the output folder.")
