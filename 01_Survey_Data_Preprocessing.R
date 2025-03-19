# ==========================================
# Preprocessing Survey Data for MRP Analysis
# ==========================================
# This script handles the preprocessing of survey data used for 
# Multilevel Regression and Poststratification (MRP).
# It supports multiple survey datasets, including ANES, CCES, and GSS.
# ==========================================

# Load required libraries
library(tidyverse)  # For data wrangling
library(haven)      # For reading .dta (Stata) and .sav (SPSS) files

# ==========================================
# Step 1: Load Survey Data
# ==========================================

# Define dataset source
survey_source <- "anes"  # Options: "anes", "cces", "gss" (Modify as needed)

# Load the dataset based on the source
if (survey_source == "anes") {
  df_survey <- read_dta("path/to/anes_data.dta") # Update file path
} else if (survey_source == "cces") {
  df_survey <- read_csv("path/to/cces_data.csv") # Update file path
} else if (survey_source == "gss") {
  df_survey <- read_sav("path/to/gss_data.sav")  # Update file path
} else {
  stop("Invalid survey source specified. Choose from 'anes', 'cces', or 'gss'.")
}

# Ensure column names are clean
colnames(df_survey) <- trimws(tolower(colnames(df_survey)))

# Debug: Print column names to verify variable names
print("✅ Checking column names:")
print(colnames(df_survey))

# ==========================================
# Step 2: Identify and Extract Relevant Variables
# ==========================================

# Define variable mappings based on survey source
if (survey_source == "anes") {
  df_survey <- df_survey %>%
    select(any_of(c("v201014b", "v201507x", "v201600", "v201549x", 
                    "v201510", "opinion_var", "v201546")))
  var_names <- c(state = "v201014b", age = "v201507x", gender = "v201600",
                 race = "v201549x", edu = "v201510", opinion = "opinion_var",
                 hispanic = "v201546")
} else if (survey_source == "cces") {
  df_survey <- df_survey %>%
    select(any_of(c("inputstate", "birthyr", "gender", "race", 
                    "educ", "opinion_var", "hispanic")))
  var_names <- c(state = "inputstate", age = "birthyr", gender = "gender",
                 race = "race", edu = "educ", opinion = "opinion_var",
                 hispanic = "hispanic")
} else if (survey_source == "gss") {
  df_survey <- df_survey %>%
    select(any_of(c("stateid", "age", "sex", "race", 
                    "educ", "opinion_var", "hispanic")))
  var_names <- c(state = "stateid", age = "age", gender = "sex",
                 race = "race", edu = "educ", opinion = "opinion_var",
                 hispanic = "hispanic")
}

# Rename variables for consistency
df_survey <- df_survey %>%
  rename(!!!var_names)

# Debug: Print first few rows to verify selection
print("✅ Checking selected variables:")
print(head(df_survey))

# ==========================================
# Step 3: Clean and Recode Variables
# ==========================================

df_survey_cleaned <- df_survey %>%
  mutate(
    # Convert missing state values to NA (Modify values based on survey data)
    state = ifelse(state %in% c(-1, -9, -8, 86), NA, state),
    
    # Convert missing age values to NA
    age = as.numeric(age),
    age = ifelse(age < 18 | age > 100, NA, age),
    
    # Categorize Age Groups (Modify values based on survey data)
    age_group = case_when(
      age < 30 ~ "18-29",
      age < 45 ~ "30-44",
      age < 65 ~ "45-64",
      age >= 65 ~ "65+",
      TRUE ~ NA_character_
    ),
    
    # Recode Gender (Modify values based on survey data)
    gender = case_when(
      gender %in% c(1, "Male") ~ "Male",
      gender %in% c(2, "Female") ~ "Female",
      TRUE ~ NA_character_
    ),
    
    # Recode Race (Modify values based on survey data)
    race = case_when(
      race == 1 ~ "White",
      race == 2 ~ "Black",
      race == 3 ~ "American Indian/Alaska Native",
      race == 4 ~ "Asian",
      race == 5 ~ "Native Hawaiian/Pacific Islander",
      race == 6 ~ "Multiple Races",
      TRUE ~ "Other"
    ),
    
    # Recode Hispanic Ethnicity (Modify values based on survey data)
    hispanic = case_when(
      hispanic == 1 ~ "Hispanic",
      hispanic == 2 ~ "Not Hispanic",
      hispanic %in% c(-9, -8) ~ NA_character_
    ),
    
    # Recode Education Levels (Modify values based on survey data)
    edu = case_when(
      edu == 1 ~ "NoHS",          # No high school diploma
      edu == 2 ~ "HS",            # High school graduate
      edu %in% c(3, 4) ~ "SomeCol", # Some college, including associate degrees
      edu == 5 ~ "CollegeOrHigher", # Bachelor's degree
      edu %in% c(6, 7, 8) ~ "PostGrad", # Master's, Professional, or Doctorate
      TRUE ~ NA_character_
    ),
    
    # Recode Public Opinion Variable (Modify values based on survey data)
    opinion = case_when(
      opinion == 1 ~ "Strongly Oppose",   # Example: Strongly oppose policy
      opinion == 2 ~ "Somewhat Oppose",   # Example: Somewhat oppose policy
      opinion == 3 ~ "Neutral",           # Example: Neither support nor oppose
      opinion == 4 ~ "Somewhat Support",  # Example: Somewhat support policy
      opinion == 5 ~ "Strongly Support",  # Example: Strongly support policy
      opinion %in% c(-9, -8) ~ NA_character_
    )
    
    # IMPORTANT: Modify `opinion` categories for each specific policy area.
    # For example, for abortion, climate policy, healthcare, gun control, etc.,
    # the levels and labels may differ across surveys.
  )

# Debug: Summary of cleaned data
print("✅ Checking cleaned data summary:")
print(summary(df_survey_cleaned))

# ==========================================
# Step 4: Save Cleaned Dataset
# ==========================================

write_csv(df_survey_cleaned, "cleaned_survey_data.csv") # Modify file path

# ==========================================
# Notes:
# 1. The script extracts and cleans ONE public opinion question at a time.
#    Modify the `opinion` variable selection for each policy area.
#
# 2. Different survey sources use different variable names and coding.
#    Adjust column names and encoding based on the dataset used.
#
# 3. The cleaned dataset is now ready for MRP analysis.
# ==========================================
