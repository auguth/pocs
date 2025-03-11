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

def main():
    input_file_path = input("Enter the input Parquet file path: ")
    output_file_path = input("Enter the output CSV file path: ")

    # Initialize the progress bar
    progress_bar = tqdm(total=1, desc="Converting Parquet to CSV", unit="file")

    # Assuming you want to convert only one file at a time, set max_workers=1.
    with concurrent.futures.ThreadPoolExecutor(max_workers=1) as executor:
        executor.submit(convert_parquet_to_csv, input_file_path, output_file_path)

        # Update the progress bar after submitting the task
        progress_bar.update(1)

    # Close the progress bar after completion
    progress_bar.close()

if __name__ == "__main__":
    main()
