import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

# Load the CSV file into a pandas DataFrame
csv_file = input("Enter the path to the CSV file: ")
data = pd.read_csv(csv_file)

# Extract data
x_values = data['X1']
y1_values = data['Y1']
y2_values = data['Y2']
y3_values = data['Y3']

# Extract filename from the path and replace underscores with spaces for the chart title
chart_title = os.path.splitext(os.path.basename(csv_file))[0].replace('_', ' ')

# Calculate the sum of Y3 values
total_stake_reward = sum(y3_values)

# Create figure and axis
fig, ax1 = plt.subplots(figsize=(10, 6))

# Plot Y1 with a solid line and filled area
ax1.plot(x_values, y1_values, label='Network Stake Supply', linewidth=1.5)
ax1.fill_between(x_values, y1_values, alpha=0.3)

# Plot Y2 with a solid line and filled area
ax1.plot(x_values, y2_values, label='Project/Contract Stake Supply', linewidth=1.5)
ax1.fill_between(x_values, y2_values, alpha=0.6)

# Create a twin y-axis for Y3
ax2 = ax1.twinx()

# Plot Y3 as translucent bars on the twin y-axis
ax2.bar(x_values, y3_values, label='Stake Rewards', color='green', alpha=0.45)

# Set labels and titles
ax1.set_xlabel('Ethereum PoCS Monthly Time Period')
ax1.set_ylabel('Ethereum PoCS Stake Supply', fontsize=10)
ax2.set_ylabel('PoCS Stake Rewards in Ether Unit', fontsize=10)

# Set chart title with bigger and bold font
plt.title(chart_title, fontsize=16, fontweight='bold')

# Adjust x-axis limits
ax1.set_xlim(min(x_values), max(x_values))

# Adjust y-axis limits
ax1.set_ylim(0, max(max(y1_values), max(y2_values)))

# Rotate x-axis tick labels by 60 degrees
ax1.set_xticks(x_values)
ax1.xaxis.set_tick_params(rotation=60, labelsize=8)

# Set y-axis label spacing
ax1.yaxis.labelpad = 15
ax2.yaxis.labelpad = 15

# Add space between y-axis ticks and labels
ax1.tick_params(axis='y', which='major', pad=5)
ax2.tick_params(axis='y', which='major', pad=5)

# Add total stake reward annotation with a highlighted box
total_annotation = f"Total Stake Reward: {total_stake_reward:,.2f} Ether"
plt.annotate(total_annotation, xy=(0.5, 0), xytext=(0, -50), ha='center', fontsize=10, color='black',
             xycoords='axes fraction', textcoords='offset points', bbox=dict(facecolor='yellow', edgecolor='black', boxstyle='round,pad=0.3'))

# Add grid
ax1.grid(True)

# Add legend inside the plot
lines1, labels1 = ax1.get_legend_handles_labels()
lines2, labels2 = ax2.get_legend_handles_labels()
ax2.legend(lines1 + lines2, labels1 + labels2, loc='upper left', bbox_to_anchor=(0.02, 0.98))

# Show the plot
plt.tight_layout()
plt.show()
