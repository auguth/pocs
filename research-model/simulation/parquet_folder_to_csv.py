import pandas as pd
import os
import concurrent.futures
from tqdm import tqdm

def convert_parquet_to_csv(input_path, output_path):
    try:
        # Read the Parquet file into a DataFrame
        df = pd.read_parquet(input_path)

        # Create the output directory if it doesn't exist
        os.makedirs(os.path.dirname(output_path), exist_ok=True)

        # Write the DataFrame to a CSV file
        df.to_csv(output_path, index=False)
        
        print(f"Conversion complete: {input_path} -> {output_path}")
    except Exception as e:
        print(f"Error converting {input_path} to {output_path}: {e}")

def process_folder(input_folder, output_folder):
    # List all files in the input folder
    file_list = os.listdir(input_folder)
    parquet_files = [filename for filename in file_list if filename.endswith(".parquet")]

    # Initialize the progress bar
    progress_bar = tqdm(total=len(parquet_files), desc="Converting Parquet files", unit="files")

    # Assuming you want to convert multiple files concurrently, set max_workers to None.
    with concurrent.futures.ThreadPoolExecutor(max_workers=None) as executor:
        for filename in parquet_files:
            input_path = os.path.join(input_folder, filename)
            output_path = os.path.join(output_folder, f"{os.path.splitext(filename)[0]}.csv")
            executor.submit(convert_parquet_to_csv, input_path, output_path)

            # Update the progress bar after submitting each task
            progress_bar.update(1)

    # Close the progress bar after completion
    progress_bar.close()

def main():
    input_folder_path = input("Enter the input folder path containing Parquet files: ")
    output_folder_path = input("Enter the output folder path for CSV files: ")

    process_folder(input_folder_path, output_folder_path)

if __name__ == "__main__":
    main()
