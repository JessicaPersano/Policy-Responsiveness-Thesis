# ==========================================
# Merge MRP State-Level Public Opinion with Policy Data
# ========================================== 

# Load required libraries
library(tidyverse)

# Step 1: Load and Clean MRP Public Opinion Data
state_avg_opinion <- read_csv("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/abortion_opinion_state.csv") %>%
  mutate(state = str_to_title(state))  # Standardize state names

# Step 2: Load and Clean Policy Data
policy_data <- read_csv("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Original/Abortion_Policy_Data.csv") %>%
  mutate(
    state = str_to_title(state),  # Standardize state names
    year = as.numeric(year)  # Ensure `year` is numeric before merging
  )

# Step 3: Merge Public Opinion and Policy Data
merged_data <- policy_data %>%
  left_join(state_avg_opinion, by = "state")

# Step 4: Validate Merged Dataset
# Check for missing values
missing_values <- merged_data %>%
  summarize(across(everything(), ~ sum(is.na(.))))
print(missing_values)

# Check for missing state matches
missing_states <- anti_join(policy_data, state_avg_opinion, by = "state") %>%
  select(state)
print(missing_states)

# Step 5: Save the Merged Dataset
write_csv(merged_data, "C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/merged_abortion_data.csv")

# Example Output:
# State       Policy_Topic         Year     Policy_Score     Opinion     Salience     Morality
# California  Abortion             2022     1               0.67        1            1
# Texas       Abortion             2021     0               0.34        1            1
