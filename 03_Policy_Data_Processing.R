# ==========================================
# This file collects and processes policy data to analyze responsiveness and congruence.
# ========================================== 

# Load required libraries
library(tidyverse)  # For data wrangling

# Step 1: Load Separate Policy Datasets
# Each public opinion question corresponds to its policy dataset.
# Replace file paths with the actual paths to your datasets.

# Example: Abortion policies dataset
abortion_policies <- read_csv("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Original/abortion_policy_data.csv")  # Policies enacted 2020 or later

# Example: Healthcare policies dataset
healthcare_policies <- read_csv("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Original/healthcare_policy_data.csv")  # Policies enacted 2020 or later

# Add similar steps for other policy datasets (e.g., zoning, same-sex marriage).

# Step 2: Clean and Process Each Policy Dataset
# Example: Cleaning the abortion policy dataset
abortion_policies <- abortion_policies %>%
  mutate(
    policy_score = ifelse(policy_type == "liberal", 1, 0),  # Liberal = 1, Conservative = 0
    salience = 1,  # High salience for abortion policies
    morality = 1   # Moral dimension for abortion policies
  )

# Example: Cleaning the healthcare policy dataset
healthcare_policies <- healthcare_policies %>%
  mutate(
    policy_score = ifelse(policy_type == "liberal", 1, 0),  # Liberal = 1, Conservative = 0
    salience = 1,  # High salience for healthcare policies
    morality = 0   # Technical dimension for healthcare policies
  )

# Add similar cleaning steps for other policy datasets.
# Adjust `salience` and `morality` based on the specific topic.

# Step 3: Validate and Summarize Each Dataset
# Example: Summarizing the abortion policies dataset
summary(abortion_policies)
any(is.na(abortion_policies))

# Example: Summarizing the healthcare policies dataset
summary(healthcare_policies)
any(is.na(healthcare_policies))

# Step 4: Save Cleaned Policy Data
# Save each cleaned dataset for integration with public opinion data.
write_csv(abortion_policies, "C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/cleaned_abortion_policy_data.csv")
write_csv(healthcare_policies, "C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/cleaned_healthcare_policy_data.csv")

# Add similar save steps for other policy datasets.

# Step 5: Prepare Simplified Datasets for Analysis
# Example: Simplify the abortion policies dataset
abortion_policy_dataset <- abortion_policies %>%
  select(state, policy_topic, enacted_year, policy_score, salience, morality)

# Example: Simplify the healthcare policies dataset
healthcare_policy_dataset <- healthcare_policies %>%
  select(state, policy_topic, enacted_year, policy_score, salience, morality)

# Save the simplified datasets
write_csv(abortion_policy_dataset, "C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/simplified_abortion_policy_data.csv")
write_csv(healthcare_policy_dataset, "C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/simplified_healthcare_policy_data.csv")

# Add similar simplification steps for other policy datasets.

# Notes:
# 1. Replace file paths with your actual dataset paths for each policy topic.
# 2. Ensure each dataset includes only policies enacted in or after the survey year for the corresponding public opinion question.
# 3. Customize `salience` and `morality` coding for each policy topic.
# 4. This approach maintains topic-specific datasets for clarity and avoids mixing unrelated policies.

# Example Output for Each Dataset:
# State       Policy_Topic         Enacted_Year     Policy_Type     Policy_Score     Salience     Morality
# California  Abortion             2022             Liberal         1               1            1
# Texas       Healthcare           2023             Conservative    0               1            0

# ==========================================
# Data Checks
# ========================================== 

# Load necessary library
library(tidyverse)

# Step 1: Load Your Final Policy Data
policy_data <- read_csv("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/merged_policy_data.csv")

colnames(policy_data)
head(policy_data)

# Step 2: Validate the Dataset
summary(policy_data)  # Provides summary statistics
any(is.na(policy_data))  # Checks for missing values

# Step 3: Check for Any Duplicates (Optional)
policy_data %>%
  group_by(state) %>%
  filter(n() > 1) %>%
  print()  # Shows duplicate states if any exist

# Step 4: Save Cleaned Policy Data (Only if Needed)
#write_csv(policy_data, "C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/final_cleaned_policy_data.csv")
