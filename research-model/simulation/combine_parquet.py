import os
import pandas as pd
import concurrent.futures

# Function to read a Parquet file
def read_parquet_file(file_path):
    return pd.read_parquet(file_path)

# Function to get a list of Parquet files in a folder
def get_parquet_files_in_folder(folder_path):
    file_list = []
    for file in os.listdir(folder_path):
        if file.endswith('.parquet'):
            file_list.append(file)
    return file_list

# Function to combine Parquet files in a subdirectory
def combine_parquet_files_in_subdirectory(subdirectory_path, output_folder_path, batch_size=None):
    subdirectory_name = os.path.basename(subdirectory_path)
    file_list = get_parquet_files_in_folder(subdirectory_path)
    
    if not file_list:
        print(f"No Parquet files found in the subdirectory {subdirectory_name}.")
        return

    combined_data = None

    # Use ThreadPoolExecutor for parallel file reading
    with concurrent.futures.ThreadPoolExecutor() as executor:
        results = list(executor.map(read_parquet_file, [os.path.join(subdirectory_path, file) for file in file_list]))

        for result in results:
            if result is not None:
                if combined_data is None:
                    combined_data = result
                else:
                    combined_data = pd.concat([combined_data, result])

    if combined_data is not None:
        output_file_name = subdirectory_name + ".parquet"
        output_file_path = os.path.join(output_folder_path, output_file_name)
        
        print(f"Saving the combined data from {subdirectory_name} to the output file...")
        combined_data.to_parquet(output_file_path, index=False)
        print(f"Data from {subdirectory_name} saved to {output_file_path}.")

if __name__ == "__main__":
    folder_path = input("Enter the folder path containing subdirectories with Parquet files: ").strip()
    if not os.path.exists(folder_path):
        print("Invalid folder path. Please provide a valid path.")
    else:
        output_folder_path = input("Enter the output folder path for the combined Parquet data: ").strip()

        if not os.path.exists(output_folder_path):
            os.makedirs(output_folder_path)  # Create the output folder if it doesn't exist

        # Loop through subdirectories and combine Parquet files in each subdirectory
        for subdirectory in os.listdir(folder_path):
            subdirectory_path = os.path.join(folder_path, subdirectory)
            if os.path.isdir(subdirectory_path):
                combine_parquet_files_in_subdirectory(subdirectory_path, output_folder_path, batch_size=1000)
