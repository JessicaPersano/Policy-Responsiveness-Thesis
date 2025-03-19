# ==========================================
# Multilevel Regression and Poststratification (MRP) - General Script
# ==========================================
# This script estimates state-level public opinion using MRP.
# It requires:
# - A cleaned survey dataset with demographic variables.
# - Census ACS data for poststratification.
# ==========================================

# Load required libraries
library(tidyverse)   # For data manipulation
library(lme4)        # For multilevel modeling
library(tidycensus)  # For retrieving Census data

# ==========================================
# 1. Data Cleaning for MRP
# ==========================================

# 🔹 Load the cleaned survey data
df_survey_cleaned <- read.csv("path/to/cleaned_survey_data.csv")  # 🔹 Modify with actual file path

# 🔹 Define the public opinion variable for analysis
opinion_var <- "opinion_question"  # 🔹 Replace with the specific opinion variable name (e.g., abortion_opinion, climate_opinion)

# 🔹 Ensure the opinion variable exists in the dataset
if (!opinion_var %in% colnames(df_survey_cleaned)) {
  stop(paste0("Column '", opinion_var, "' not found in survey data. Please check your dataset."))
}

# 🔹 Rename selected opinion variable for analysis
df_survey_cleaned$current_opinion <- df_survey_cleaned[[opinion_var]]

# 🔹 Remove rows with missing key variables (ensures complete cases for MRP)
df_survey_cleaned <- df_survey_cleaned %>%
  drop_na(state, age_group, gender, race, hispanic, edu, current_opinion)

# ==========================================
# Convert numeric state FIPS codes to state names (Modify if state names are already present)
# ==========================================

fips_to_state <- c(
  "1" = "Alabama", "2" = "Alaska", "4" = "Arizona", "5" = "Arkansas", "6" = "California",
  "8" = "Colorado", "9" = "Connecticut", "10" = "Delaware", "11" = "District of Columbia",
  "12" = "Florida", "13" = "Georgia", "15" = "Hawaii", "16" = "Idaho", "17" = "Illinois",
  "18" = "Indiana", "19" = "Iowa", "20" = "Kansas", "21" = "Kentucky", "22" = "Louisiana",
  "23" = "Maine", "24" = "Maryland", "25" = "Massachusetts", "26" = "Michigan", "27" = "Minnesota",
  "28" = "Mississippi", "29" = "Missouri", "30" = "Montana", "31" = "Nebraska", "32" = "Nevada",
  "33" = "New Hampshire", "34" = "New Jersey", "35" = "New Mexico", "36" = "New York",
  "37" = "North Carolina", "38" = "North Dakota", "39" = "Ohio", "40" = "Oklahoma",
  "41" = "Oregon", "42" = "Pennsylvania", "44" = "Rhode Island", "45" = "South Carolina",
  "46" = "South Dakota", "47" = "Tennessee", "48" = "Texas", "49" = "Utah", "50" = "Vermont",
  "51" = "Virginia", "53" = "Washington", "54" = "West Virginia", "55" = "Wisconsin",
  "56" = "Wyoming"
)

df_survey_cleaned$state <- as.character(df_survey_cleaned$state)
df_survey_cleaned$state <- fips_to_state[df_survey_cleaned$state]

# 🔹 Standardize state and race names to match Census format
df_survey_cleaned <- df_survey_cleaned %>%
  mutate(
    state = str_to_title(state),  
    state = recode(state, "District of Columbia" = "District Of Columbia"),  
    race = recode(race, "Multiple Races" = "Two or More Races")  
  ) %>%
  drop_na(state)  # 🔹 Drop rows with missing state values

# ==========================================
# Standardize Categorical Variables (Ensure consistency across datasets)
# ==========================================

df_survey_cleaned <- df_survey_cleaned %>%
  mutate(
    gender = factor(gender),
    hispanic = factor(hispanic),
    race = factor(race),
    edu = factor(edu),
    age_group = factor(age_group, levels = c("18-29", "30-44", "45-64", "65+"))
  )

# 🔹 Save cleaned data for MRP
write.csv(df_survey_cleaned, "path/to/cleaned_survey_data_ready_for_mrp.csv", row.names = FALSE)  # Modify file path

# ==========================================
# 2. Multilevel Regression for MRP
# ==========================================

# 🔹 Fit the MRP multilevel model
model_opinion <- lmer(
  current_opinion ~ gender + hispanic + (1 | edu) + (1 | race) + (1 | age_group) + (1 | state), 
  data = df_survey_cleaned
)

# ==========================================
# 3. Download Census Data for Poststratification
# ==========================================

# 🔹 Set Census API key
census_api_key("your_api_key_here", install = TRUE, overwrite = TRUE)

# 🔹 Define Census variables (Modify if adding more demographic groups)
acs_variables <- c(
  "B01001_002E" = "male_population",
  "B01001_026E" = "female_population",
  "B03002_003E" = "white_population",
  "B03002_004E" = "black_population",
  "B03002_012E" = "hispanic_population"
)

# 🔹 Download ACS Data
acs_data <- get_acs(
  geography = "state",
  variables = acs_variables,
  year = 2020,
  survey = "acs1"
)

# ==========================================
# 4. Process Census Data for Poststratification
# ==========================================

#Process census data (Modify as needed)
poststrat_table <- acs_data %>% 
  mutate(
    race = case_when(
      variable == "B03002_003E" ~ "White",
      variable == "B03002_004E" ~ "Black",
      variable == "B03002_012E" ~ "Hispanic",
      TRUE ~ "Other"
    ),
    gender = case_when(
      variable == "B01001_002E" ~ "Male",
      variable == "B01001_026E" ~ "Female",
      TRUE ~ NA_character_
    )
  ) %>%
  group_by(state, race, gender) %>%
  summarise(freq = sum(estimate), .groups = "drop")

# 🔹 Convert long format into wide format
poststrat_wide <- poststrat_table %>%
  pivot_wider(names_from = race, values_from = freq, values_fill = 0)

# 🔹 Compute state proportions for poststratification
poststrat_wide <- poststrat_wide %>%
  group_by(state) %>%
  mutate(state_prop = freq / sum(freq, na.rm = TRUE)) %>%
  ungroup()

# ==========================================
# 5. Generate Predictions & Compute State-Level Estimates
# ==========================================

# 🔹 Predict public opinion for each demographic group
poststrat_wide$predictions <- predict(model_opinion, newdata = poststrat_wide, allow.new.levels = TRUE)

# 🔹 Apply poststratification weighting
poststrat_wide$weighted_preds <- poststrat_wide$predictions * poststrat_wide$state_prop

# 🔹 Compute state-level public opinion estimates
state_avg_opinion <- poststrat_wide %>%
  group_by(state) %>%
  summarise(estimated_opinion = sum(weighted_preds, na.rm = TRUE), .groups = "drop")

# ==========================================
# 6. Save & Print Results
# ==========================================

write.csv(state_avg_opinion, "path/to/state_opinion_results.csv", row.names = FALSE)

print(state_avg_opinion)
