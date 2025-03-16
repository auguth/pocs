import os
import pandas as pd
import matplotlib.pyplot as plt

def calculate_inequality_ratio(data):
    data = sorted(data)
    lowest_percentile = data[0]
    highest_percentile = data[-1]
    
    inequality_ratio = highest_percentile / lowest_percentile
    return inequality_ratio

def process_files(file_paths):
    cumulative_scores = []
    inequality_ratios = []

    cumulative_data = {}  # To accumulate stake scores for each person across ranges

    for file_path in file_paths:
        df = pd.read_csv(file_path)
        for person, score in zip(df['to_address'], df['stake_score']):
            cumulative_data[person] = cumulative_data.get(person, 0) + score
        
        cumulative_scores.append(sum(df['stake_score']))
        inequality_ratios.append(calculate_inequality_ratio([score for person, score in cumulative_data.items()]))

    return cumulative_scores, inequality_ratios

def main():
    script_directory = os.path.dirname(os.path.abspath(__file__))
    folder_name = "stake_score_range"
    folder_path = os.path.join(script_directory, folder_name)
    
    files = [f for f in os.listdir(folder_path) if f.startswith("contracts_tx_range_") and f.endswith(".csv")]

    # Extract and sort the numeric parts of the filenames
    numeric_parts = [int(f.split("_")[-1].split(".")[0]) for f in files]
    sorted_indices = sorted(range(len(numeric_parts)), key=lambda k: numeric_parts[k])

    # Sort files based on the sorted indices
    sorted_files = [files[i] for i in sorted_indices]
    
    file_paths = [os.path.join(folder_path, f) for f in sorted_files]

    cumulative_scores, inequality_ratios = process_files(file_paths)

    x_values = range(1, len(sorted_files) + 1)
    
    x_tick_step = 5  # Show every 5th tick

    plt.figure(figsize=(10, 6))
    plt.plot(x_values, inequality_ratios, marker='o', linestyle='-', color='b')
    plt.xlabel("Ethereum PoCS Monthly Period")
    plt.ylabel("Inequality Ratio")
    plt.title("Cumulative Inequality Ratio Variation Over Time")
    
    # Set x-axis ticks to show every x_tick_step value
    plt.xticks(x_values[::x_tick_step])
    
    plt.grid(True)
    
    # Create the "Outputs" folder if it doesn't exist
    outputs_folder = os.path.join(script_directory, "Outputs")
    os.makedirs(outputs_folder, exist_ok=True)
    
    # Save the plot as a JPEG image inside the "Outputs" folder
    output_file_path = os.path.join(outputs_folder, "inequality_ratio_plot.jpg")
    plt.savefig(output_file_path, dpi=200, format='jpeg')
    
    plt.show()

if __name__ == "__main__":
    main()
