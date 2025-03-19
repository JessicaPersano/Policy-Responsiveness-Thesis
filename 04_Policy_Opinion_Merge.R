# ==========================================
# Merge MRP State-Level Public Opinion with Policy Data
# ==========================================
# This script merges estimated public opinion from MRP with policy data
# for a given policy area (e.g., abortion, climate, healthcare).
# Modify the file paths and variable names based on the specific policy analysis.
# ==========================================

# Load required libraries
library(tidyverse)

# ==========================================
# 1. Load and Clean MRP Public Opinion Data
# ==========================================

# 🔹 Define the opinion dataset file (Change this based on the policy topic)
opinion_file <- "path/to/state_opinion_results.csv"  # Replace with actual file path

# 🔹 Load MRP public opinion data
state_avg_opinion <- read_csv(opinion_file) %>%
  rename(estimated_opinion = value) %>%  # 🔹 Rename column for clarity (if needed)
  mutate(state = str_to_title(state))  # 🔹 Standardize state names to match policy data

# ==========================================
# 2. Load and Clean Policy Data
# ==========================================

# 🔹 Define the policy dataset file (Change this based on the policy topic)
policy_file <- "path/to/policy_data.csv"  # Replace with actual file path

# 🔹 Load policy data
policy_data <- read_csv(policy_file) %>%
  mutate(
    state = str_to_title(state),  # 🔹 Standardize state names
    year = as.numeric(year)  # 🔹 Ensure `year` is numeric before merging
  )

# ==========================================
# 3. Merge Public Opinion and Policy Data
# ==========================================

merged_data <- policy_data %>%
  left_join(state_avg_opinion, by = "state")  # 🔹 Keep all policy data, even if no opinion data exists

# ==========================================
# 4. Validate Merged Dataset
# ==========================================

# 🔹 Check for missing values in the merged dataset
missing_values <- merged_data %>%
  summarize(across(everything(), ~ sum(is.na(.))))
print("Missing values summary:")
print(missing_values)

# 🔹 Identify states in policy data that have no matching opinion data
missing_states <- anti_join(policy_data, state_avg_opinion, by = "state") %>%
  select(state)
print("States missing from opinion dataset:")
print(missing_states)

# ==========================================
# 5. Save the Merged Dataset
# ==========================================

# 🔹 Define the output file path (Change this based on the policy topic)
output_file <- "path/to/merged_policy_opinion_data.csv"  # Replace with actual file path

write_csv(merged_data, output_file)

# ==========================================
# Example Output:
# ==========================================
# State       Policy_Topic         Year     Policy_Score     Estimated_Opinion     Salience     Morality
# California  Abortion             2022     1               0.67                  1            1
# Texas       Minimum Wage         2021     0               0.34                  1            0

# 🔹 Modify this script for different policy areas by updating:
# 1. `opinion_file` – The path to the estimated public opinion dataset.
# 2. `policy_file` – The path to the corresponding policy dataset.
# 3. `output_file` – The output file path for the merged dataset.
# 4. Any variable renaming needed in `state_avg_opinion`.

# This script ensures **reproducibility** across **multiple policy analyses**.
