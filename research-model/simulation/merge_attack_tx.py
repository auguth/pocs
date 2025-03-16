import os
import pandas as pd

def combine_parquet_folders(folder1_path, folder2_path, output_folder):
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    folder1_files = os.listdir(folder1_path)
    folder2_files = os.listdir(folder2_path)

    common_files = set(folder1_files) & set(folder2_files)

    for filename in common_files:
        file_path1 = os.path.join(folder1_path, filename)
        file_path2 = os.path.join(folder2_path, filename)

        df1 = pd.read_parquet(file_path1)
        df2 = pd.read_parquet(file_path2)

        # Ensure columns are in the same order
        df2 = df2[df1.columns]

        combined_df = pd.concat([df1, df2], ignore_index=True)

        output_path = os.path.join(output_folder, filename)
        combined_df.to_parquet(output_path, index=False)

        print(f"Processed: {filename}")

    print("Parquet files combined and saved to the output folder.")

if __name__ == "__main__":
    input_folder1 = input("Enter path to the first input folder: ")
    input_folder2 = input("Enter path to the second input folder: ")
    output_folder = input("Enter path to the output folder: ")

    combine_parquet_folders(input_folder1, input_folder2, output_folder)
