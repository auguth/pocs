# Simulating Proof of Contract Stake (PoCS) on Ethereum Transaction History

In order to conduct a PoCS (Proof of Contract Stake) simulation, it is essential to locally store the complete Ethereum Transaction History in an efficient Table lookup format (made available by the [Ethereum ETL Project](https://github.com/blockchain-etl/ethereum-etl)) and further segregate contract accounts and their associated transactions. Ethereum Block Rewards will not be considered in this simulation.

Directly executing custom BigQuery SQL scripts for filtering transactions to simulate PoCS can become costly. Therefore, it is recommended to locally download the entire Ethereum block history of transactions to facilitate script execution and obtain optimal results. The provided Python scripts have been optimized for lowered memory usage via parallel execution of multiple smaller sized inputs by utilizing concurrent.futures and multiprocessing, making them compatible with PCs having a **minimum of 16 GB RAM and 16 thread (8 cores)**. Since all scripts are restricted to I/O bound tasks, there is no GPU required to execute these simulations. To achieve the desired outcomes, please follow the script execution order and ensure that you provide appropriate input folders and parquet files (which can be downloaded from Ethereum BigQuery on Google).

It is important to note that, since we are downloading the block history from a centralized provider without running an ethereum full node or validating the blocks for authenticity, there may be some instances of missing blocks and transactions. While these discrepancies are not expected to significantly impact the final results, it is essential to be aware of them.

## Downloading Data from BigQuery

The Ethereum Transaction History can be downloaded from [BigQuery crypto.ethereum](https://bigquery.cloud.google.com/dataset/bigquery-public-data:crypto_ethereum). The relevant input table is "Transactions" which is around 600 GB in size.

As exporting directly from BigQuery is not possible, you will need to create a Google Cloud Bucket and export the Transactions table from BigQuery to your preferred Bucket. Ensure that the bucket is configured with regional settings that offer high-speed download bandwidth for local downloads. When exporting, set the compression to "none" and choose the file format as "parquet". Parquet format is recommended as it offers efficient reading and writing while minimizing disk memory usage. Please note that the simulation scripts are specifically designed to work with only parquet file format.

After exporting, locally download the entire folder containing the transactions table from the Bucket Storage to your local storage (Downloads can be made through Google Cloud CLI). Make sure to verify that all the parquet files associated with the transactions table have been successfully downloaded. It is important to be aware that BigQuery may not necessarily export data in block height order and may mix up transactions. Consequently, the parquet files will need to be uncompressed and organized in a format where transactions are ordered according to the block height. This reorganization will be carried out during the ordered script execution phase.

# Simulation 1 : Ethereum PoCS Stake Supply Chart

In this simulation, our goal is to determine the PoCS stake supply of the Ethereum network using the PoCS (Proof of Contract Stake) formulas. We calculate the stake supply with the following equation:

$$StakeScore (SS) = k \times (r - A) \times R \times g$$

Where:
- $k$ is a proportionality constant (currently set to 1).
- $r$ represents the recent block height contract execution (used for calculating stake age).
- $A$ is the staked block height (currently set to contract deployed block height, but subject to change with actual PoCS protocol implementation).
- $R$ is a value determined by contracts' reputation.
- $g$ represents the gas usage history.

Please note that for the sake of data readability, gas history normalization is not applied in these simulations. As a result, the results will always be long positive integers.

## Simulation Steps for Stake Supply Analysis

To perform the stake supply simulation and analyze the PoCS network, follow these detailed steps:

### 1. Download the PoCS Simulation Directory

- Begin by downloading the [PoCS Simulation directory](simulation/pocs) that contains the simulation scripts.
- Once downloaded, navigate to this directory using your local terminal.
- Install the libraries which are mentioned in [pip-install.txt](pip-install.txt)

### 2. Filtering Contracts' Transactions

#### Step 2.1: Execute Contracts Filter Script
- Execute the [Contracts Filter](contracts_filter.py) script to initiate the process.
- You will be prompted to provide the following information:
   1. The path to a directory containing BigQuery downloaded Parquet files.
   2. Specify the start and end file numbers to define the range of expected files downloaded from BigQuery (please provide the start and end numbers).
- The [Contracts Filter](contracts_filter.py) script runs in parallel and checks for missing files from the BigQuery export.
- If successful without missing files, it identifies transactions with a "NULL" "to_address" (as specified in the [Ethereum Yellowpaper](https://ethereum.github.io/yellowpaper/paper.pdf)) for contract creation transactions.
- Data from the 'receipt_contract_address' column is extracted to create and save a trie data structure (efficient in storage and verifiable lookup) from these addresses.

#### Step 2.2: Execute Transaction Filtering Sub-Scripts
- After saving the trie of contract addresses, the script executes the [tx_filter.py](tx_filter.py) as a sub-script automatically.
- [tx_filter.py](tx_filter.py) keeps only the columns "to_address," "block_number," and "receipt_gas_used" from the BigQuery Transactions Table folder containing Parquet files, which are required for our analysis.
- The modified Parquet files, still as individual files (not merged), are saved to a specified location determined by the [Contracts Filter](contracts_filter.py) script.
- The second subscript continuously runs [tx_filter_contracts.py](tx_filter_contracts.py), which takes the previously built trie file and the output folder of [tx_filter.py](tx_filter.py). This step results in an output folder containing only contract addresses but individual Parquet files to reduce memory overhead in further scripts.
- During the execution of subscripts, the user is not required to provide arguments as they are automatically determined by the script.
- Once these subscripts finish executing, the trie file and intermediate folders are deleted.
- The folder containing the contract information for PoCS stake score calculation is then returned to the user for further execution.

### 3. Sorting via Range of Blocks

#### Step 3.1: Sort Contracts Transactions
- Execute the [Contracts Tx Index](contracts_tx_index.py) script to sort Parquet files containing contract transactions into specific block ranges.
- This step allows efficient grouping of blocks into specified timeframes, such as 1 month, 3 months, or 6 months.
- For this simulation, we use a 1-month period, which corresponds to approximately 210,000 blocks (we assume that the Ethereum block time averaging around 12 seconds).
- Required user inputs:
   1. Use the final output folder returned by the [Contracts Filter](contracts_filter.py) script.
   2. Specify the output folder path.

#### Step 3.2: Combine Parquet Files
- Execute the [Combine Parquet](combine_parquet.py) script to combine all Parquet files inside subdirectories into a single Parquet file for each specified range.
- Required user inputs:
   1. The folder path containing the subdirectories, which is the output folder of the [Contracts Tx Index](contracts_tx_index.py) script.
   2. Specify the output folder path.

### 4. Calculating Gas Usage

#### Step 4.1: Execute Gas Sum Script
- Execute the [Gas Sum](gas_sum.py) script, which groups unique "to_address" (contract addresses) and calculates the total "receipt_gas_used" for each contract over a specific timeframe.
- Required user inputs:
   1. The input folder path, obtained from the output folder of the [Combine Parquet](combine_parquet.py) script.
   2. Specify the output folder path.
- This step results in Parquet files organized by timeframe, each containing contract addresses and their respective total gas usage over the defined period (e.g., 1 month).

### 5. Reputation Calculation

#### Step 5.1: Execute Reputation Prepare Script
- Execute the [Reputation Prepare](reputation_prepare.py) script to prepare for reputation calculation. Duplicate rows, representing multiple calls to the same contract within a single block, are removed.
- Required user inputs:
   1. The input folder path, obtained from the output folder of the [Contracts Tx Index](contracts_tx_index.py) script.
   2. Specify the output folder path.

#### Step 5.2: Execute Reputation Counter Script
- Execute the [Reputation Counter](reputation_counter.py) script to count the remaining rows after duplicate removal. Each row count represents the number of blocks in which a contract is called or executed.
- Required user inputs:
   1. The input folder path, obtained from the output folder of the [Reputation Prepare](reputation_prepare.py) script.
   2. Specify the output folder path.
- This process results in two-column Parquet files containing "to_address" and "reputation" values for subsequent timeframes, typically measured in blocks.

### 6. Stake Score CSV Table

#### Step 6.1: Execute Stake Score CSV Script
- Execute the [Stake Score CSV](stakescore_csv.py) script to generate a stake score CSV table for each specified range. The script calculates the stake score by multiplying the "receipt_gas_used" and "reputation" values of individual contract addresses ("to_address").
- Required user inputs:
   1. The input folder path, obtained from the output folder of the [Gas Sum](gas_sum.py) script, to fetch the "receipt_gas_used".
   2. The input folder path, obtained from the output folder of the [Reputation Counter](reputation_counter.py) script, to fetch the "reputation".
   3. Specify the output folder path.
- For each matching "to_address" within specific timeframes, the script calculates and saves the stake score.

### 7. Network Stake Score Chart (Final Output)

#### Step 7.1: Generate Network Stake Supply Chart
- Execute the [Network Stake Supply Chart](network_stake_supply_chart.py) script to generate

 a chart image representing the network-wide stake supply via contract addresses.
- Required user input is obtained from the output folder of the [Stake Score CSV](stakescore_csv.py) script.
- The script iterates over each timeframe and calculates the cumulative sum of all stake scores for each contract per timeframe. The Y-values of the chart represent the stake supply, while the X-values represent the time frame (e.g., 1 month).

- This simulation should be viewed as probabilistic, as it doesn't consider various factors such as stake age, stake purging, and other elements that may affect the documented PoCS protocol. Due to inherent uncertainty, the simulation is based on general assumptions, and it generates an Ethereum PoCS network-wide stake supply chart image.

# Simulation 2 : Uniswap's Stake Score on Ethereum PoCS

With the output of the ethereum pocs network stake supply simulation, which provides pocs stake scores for individual contract addresses, we can perform more detailed analyses on specific decentralized applications such as Uniswap. Specifically, we can calculate probabilistic staking rewards and determine the stake percentage of these individual contracts in relation to the total network stake supply at a current time period with cumulative scores.

The following scripts have been developed to assist in calculating stake percentages and rewards in Ether (1 Wei * 10^18) for individual contracts. In the context of a decentralized application like Uniswap, which may execute internal calls to various contracts to facilitate decentralized swaps, it's crucial to identify and specify the contracts addresses deployed by the organization or DAO. 

These scripts are designed to generate charts that illustrate the staking dynamics, but with certain assumptions:

- **Validators and Block Producer Selection**: Due to the inherent randomness in proof-of-stake (PoS) protocols and the network's avoidance of selecting the highest stake holder to ensure protocol fairness, simulating validator information and block producer selection is not feasible. Consequently, we make the assumption that stake percentages can only be used to calculate rewards based on the law of large numbers.

It's essential to note that these rewards encompass transaction fees, while block rewards are not factored into the calculation.

These scripts enable a more detailed analysis of the staking behavior of individual contracts within the Ethereum PoCS network, offering insights into potential rewards and the stake percentage contribution of specific contracts.

## Simulation Steps for Uniswap PoCS Analysis

To perform the Uniswap PoCS simulation and analyze its staking dynamics, follow these detailed steps:

### 1. Calculating Transaction Fees

#### Step 1.1: Filtering Columns
- Initiate the process by executing the [Filter Columns](filter_columns.py) script, which extracts and retains essential columns from the Ethereum transactions Parquet files obtained from BigQuery.
- Required user inputs:
   1. The input folder should point to the directory containing the Ethereum transactions data downloaded from BigQuery.
   2. Specify the output folder path.

#### Step 1.2: Sorting by Range
- Execute the [Sort Range](tx_range_index.py) script to categorize Parquet files, containing transactions with fee calculation columns, into specific block ranges. This step enables efficient grouping of blocks into predefined timeframes.
- The objective is to calculate the total transaction fees collected within each timeframe, such as 1 month or 210,000 blocks. This data will be crucial for estimating staking rewards based on the stake percentage held by the Uniswap application/contract.
- Required user inputs:
   1. Use the output folder returned by the [Filter Columns](filter_columns.py) script as the input.
   2. Specify the output folder path.

#### Step 1.3: Transaction Fee Calculation
- Execute the [Tx Fee Column](transaction_fee_addition.py) script to add an extra column, "transaction_fee," to every row in each Parquet file. This column represents the product of "receipt_gas_used" and "gas_price" for each transaction, calculating the transaction fee.
- Required user inputs:
   1. Use the output folder returned by the previous step as the input.
   2. Specify the output folder path.

#### Step 1.4: Summing Transaction Fees per Range
- Execute the [Sum Transaction fee per range](transaction_fee_sum_range.py) script to generate a single CSV file containing the total transaction fee collected within each timeframe. This step involves summing the transaction fees from all rows within each range.
- Required user inputs:
   1. Utilize the output folder returned by the previous step as the input.
   2. Specify the output CSV file path.

### 2. Project's Stake Chart

#### Step 2.1: Project Data CSV Generation
- Execute the [Project data CSV generation](projects_ethereum_pocs_csv.py) script, providing specific inputs.
- Required user inputs:
   1. Use the output folder returned by the [Stake Score CSV](stakescore_csv.py) script as the folder containing the stakescore CSV files.
   2. Specify the output folder path for this step.
   3. Enter the Project Name (e.g., Uniswap, MakerDAO, etc.).
   4. Provide the Contract Addresses (including "0x"), separated by commas.
   5. Use the output CSV file path returned by the [Sum Transaction fee per range](transaction_fee_sum_range.py) script.

- The [Project data CSV generation](projects_ethereum_pocs_csv.py) script creates a CSV table with the project name as the filename. It includes columns such as:
   - 'X1' for monthly timeframes.
   - 'Y1' for network cumulative stake supply.
   - 'Y2' for the project's/contract's cumulative stake score.
   - 'Y3' for stake rewards in Ether for each specific month (not cumulative).

#### Step 2.2: Generating Project Chart
- Execute the [Project Chart](projects_ethereum_pocs_charts.py) script, providing the CSV output file path returned by the [Project data CSV generation](projects_ethereum_pocs_csv.py) script as input. This script generates a chart plot with appropriate labels.
- Users can save the plotted chart for further analysis and visualization purposes.

By following these simulation steps, you can perform a comprehensive analysis of the staking dynamics and potential rewards for the Uniswap decentralized application within the Ethereum PoCS network.
## Ethereum PoCS Collusion Attack Simulation

In the Collusion Attack simulation, we explore the hypothetical scenario of a collusion attack on the Ethereum PoCS network. This attack involves adding certain attack transactions that could consume a significant portion of the block's gas used. The attack's effectiveness is represented by a constant percentage, denoted as 'K,' ranging from 0 to 1. For example, a 10% attack implies that 10% of the block's gas used will be consumed by the attacker address, with the attacker paying the gas fees. The goal is to determine the timeframe at which an attack starting with all blocks consumed by the attacker can result in controlling 51% of the network's stake.

This simulation serves as a theoretical exercise, as real-world attacks cannot consistently gain a fixed percentage of every sequential block due to various factors, including the need for the attacker to pay significant fees and the presence of other honest contracts saturating gas usage. However, this analysis provides insights into the hypothetical scenario.

### Simulation Steps

Follow these steps to perform the Collusion Attack simulation:

### 1. Attacker's `receipt_gas_used`

#### Step 1.1: Finding Block Number's Total Gas Usage
- Execute the [Block Number Gas Sum](block_number_gas_sum.py) script.
- This script groups unique 'block_number' values and calculates the total 'receipt_gas_used' for each block.
- Use the output folder of the [Combine Parquet](combine_parquet.py) script as input.

#### Step 1.2: Finding Attack Address Gas Usage
- Execute the [Attack Tx](attack_tx.py) script.
- Provide the following arguments:
   1. The input folder, which is the output folder of the [Block Number Gas Sum](block_number_gas_sum.py) script.
   2. 'K,' representing a percentage in the range of 0 to 1 (e.g., 0.1 or 0.2 for 10% or 20% attack).
- The script calculates the attack address's 'receipt_gas_used' for each block number.

### 2. Adding Attacker's Transaction
- The output of the [Attack Tx](attack_tx.py) script produces rows with values 'block_number,' 'to_address' (set to 'attackAddress' for readability), and 'receipt_gas_used,' constituting K% of the 'block_number.'
- Instead of replacing existing transactions, we add the attack transaction to each block's contents as an additional transaction. This approach increases the attacker's reputation and enhances the exploitation scenario.

#### Step 2.1: Merging Attack Transactions
- Execute the [Merge Attack Tx](merge_attack_tx.py) script.
- Provide the following arguments:
   1. The output folder of the [Combine Parquet](combine_parquet.py) script.
   2. The output folder of the [Attack Tx](attack_tx.py) script.
- This script matches the timeframe Parquet files based on their filenames and generates merged transaction data with the attacker's transaction included in each block.

### 3. Combined Stake Score Calculation
#### Step 3.1
- With the contract transaction data now merged with the collusion attack's attacker transaction in every block, we need to recalculate the stake score CSV table.
- Using the output of the [Merge Attack Tx](merge_attack_tx.py) script, repeat the steps from [Gas Sum](#step-41-execute-gas-sum-script) to [Stake Score CSV](#step-61-execute-stake-score-csv-script) to generate a CSV table. This table contains each contract address and its stake score for specific block ranges (e.g., 1 month or 210,000 blocks).

### 4. Plotting Chart Data

- With the stake scores generated for each contract address, you can manually plot chart data for each range, considering a 51% attack as successful, and then proceed to the next timeframe (e.g., month).
- You can find the generated table for 10% and 20% PoCS block attacks [here](https://docs.google.com/spreadsheets/d/1otk8y6Vq2JDS2FZ5KkG1AuWX7jMFemvZg7V9FFj8yiU/edit?usp=sharing).

Please note that this simulation is for theoretical purposes and does not consider various real-world complexities and limitations.