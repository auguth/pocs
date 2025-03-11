import os
import pandas as pd
from multiprocessing import Pool

def process_file(input_file_path, output_folder, k):
    df = pd.read_parquet(input_file_path)
    df['to_address'] = 'attackAddress'
    df['receipt_gas_used'] = (df['receipt_gas_used'] * -k) / (k - 1)
    df['receipt_gas_used'] = df['receipt_gas_used'].astype(int)
    
    output_file_path = os.path.join(output_folder, os.path.basename(input_file_path))
    df.to_parquet(output_file_path, index=False)
    print(f"Processed {input_file_path} and saved to {output_file_path}")

def main():
    input_folder = input("Enter the path to the input folder containing Parquet files: ")
    output_folder = input("Enter the path to the output folder for processed Parquet files: ")
    k = float(input("Enter the value of k (between 0 and 1): "))
    
    files = [f for f in os.listdir(input_folder) if f.endswith('.parquet')]
    file_paths = [os.path.join(input_folder, f) for f in files]
    
    os.makedirs(output_folder, exist_ok=True)
    
    with Pool() as pool:
        for file_path in file_paths:
            pool.apply_async(process_file, args=(file_path, output_folder, k))
        
        pool.close()
        pool.join()
    
    print("All files processed and saved.")

if __name__ == "__main__":
    main()
