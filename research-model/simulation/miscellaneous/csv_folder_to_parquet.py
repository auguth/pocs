import os
import pandas as pd

def convert_csv_to_parquet(csv_path, output_path):
    try:
        # Read the CSV file using pandas
        df = pd.read_csv(csv_path)

        # Convert to Parquet format and write to the output path
        df.to_parquet(output_path)

        print(f"{csv_path} converted to Parquet successfully!")
    except Exception as e:
        print(f"An error occurred: {e}")

def process_folder(input_folder, output_folder):
    # Create the output folder if it does not exist
    os.makedirs(output_folder, exist_ok=True)

    # Get a list of all files in the input folder
    file_list = os.listdir(input_folder)

    # Process each CSV file and convert to Parquet
    for filename in file_list:
        if filename.endswith('.csv'):
            csv_file_path = os.path.join(input_folder, filename)
            parquet_file_path = os.path.join(output_folder, f"{os.path.splitext(filename)[0]}.parquet")
            convert_csv_to_parquet(csv_file_path, parquet_file_path)

if __name__ == "__main__":
    # Get the folder paths from the user
    input_folder_path = input("Enter the input folder path containing CSV files: ")
    output_folder_path = input("Enter the output folder path for Parquet files: ")

    # Call the function to convert CSVs in the folder to Parquet
    process_folder(input_folder_path, output_folder_path)
