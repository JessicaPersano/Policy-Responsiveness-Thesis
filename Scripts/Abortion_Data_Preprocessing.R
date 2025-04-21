# ==========================================
# Process Raw Survey Data
# ========================================== 

library(tidyverse)
library(haven)

# Load dataset
df_survey <- read_dta("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Original/anes_timeseries_2020_stata_20220210/anes_timeseries_2020_stata_20220210.dta")

# Ensure column names are clean
colnames(df_survey) <- trimws(tolower(colnames(df_survey)))

# Debug: Print column names to verify
print(colnames(df_survey))

# Select variables safely 
df_survey <- df_survey %>%
  select(any_of(c("v201014b", "v201507x", "v201600", "v201549x", "v201510", "v201336", "v201546")))

# Debug: Check missing values before transformation
summary(df_survey)

# Recode and clean variables
df_survey_cleaned <- df_survey %>%
  rename(
    state = v201014b,  
    age = v201507x,
    gender = v201600,
    race = v201549x,
    edu = v201510,
    abortion_opinion = v201336,
    hispanic = v201546
  ) %>%
  mutate(
    # Remove invalid state codes and convert FIPS to state names
    state = ifelse(state %in% c(-1, -8, -9, 86), NA, state),
    state = case_when(
      state == 1 ~ "Alabama", state == 2 ~ "Alaska", state == 4 ~ "Arizona",
      state == 5 ~ "Arkansas", state == 6 ~ "California", state == 8 ~ "Colorado",
      state == 9 ~ "Connecticut", state == 10 ~ "Delaware", state == 11 ~ "District Of Columbia",
      state == 12 ~ "Florida", state == 13 ~ "Georgia", state == 15 ~ "Hawaii",
      state == 16 ~ "Idaho", state == 17 ~ "Illinois", state == 18 ~ "Indiana",
      state == 19 ~ "Iowa", state == 20 ~ "Kansas", state == 21 ~ "Kentucky",
      state == 22 ~ "Louisiana", state == 23 ~ "Maine", state == 24 ~ "Maryland",
      state == 25 ~ "Massachusetts", state == 26 ~ "Michigan", state == 27 ~ "Minnesota",
      state == 28 ~ "Mississippi", state == 29 ~ "Missouri", state == 30 ~ "Montana",
      state == 31 ~ "Nebraska", state == 32 ~ "Nevada", state == 33 ~ "New Hampshire",
      state == 34 ~ "New Jersey", state == 35 ~ "New Mexico", state == 36 ~ "New York",
      state == 37 ~ "North Carolina", state == 38 ~ "North Dakota", state == 39 ~ "Ohio",
      state == 40 ~ "Oklahoma", state == 41 ~ "Oregon", state == 42 ~ "Pennsylvania",
      state == 44 ~ "Rhode Island", state == 45 ~ "South Carolina", state == 46 ~ "South Dakota",
      state == 47 ~ "Tennessee", state == 48 ~ "Texas", state == 49 ~ "Utah",
      state == 50 ~ "Vermont", state == 51 ~ "Virginia", state == 53 ~ "Washington",
      state == 54 ~ "West Virginia", state == 55 ~ "Wisconsin", state == 56 ~ "Wyoming",
      TRUE ~ NA_character_
    ),
    
    # Fix missing age (-9 to NA)
    age = as.numeric(age),  # Ensure age is recognized
    age = ifelse(age %in% c(-8, -9), NA, as.numeric(age)),
    age_group = case_when(
      age < 30 ~ "18-29",
      age < 45 ~ "30-44",
      age < 65 ~ "45-64",
      age >= 65 ~ "65+",
      TRUE ~ NA_character_
    ),
    
    # Recode Gender
    gender = case_when(
      gender == 1 ~ "Male",
      gender == 2 ~ "Female",
      TRUE ~ NA_character_
    ),
    
    # Recode Race (separate Hispanic category)
    race = case_when(
      race == 1 ~ "White",
      race == 2 ~ "Black",
      race == 3 ~ "American Indian/Alaska Native",
      race == 4 ~ "Asian",
      race == 5 ~ "Native Hawaiian/Pacific Islander",
      race == 6 ~ "Multiple Races",
      TRUE ~ NA_character_
    ),
    
    # Recode Hispanic Ethnicity separately
    hispanic = case_when(
      hispanic == 1 ~ "Hispanic",
      hispanic == 2 ~ "Not Hispanic",
      hispanic %in% c(-9, -8) ~ NA_character_
    ),
    
    # Recode Education
    edu = case_when(
      edu == 1 ~ "NoHS",        # Less than high school credential
      edu == 2 ~ "HS",          # High school diploma or equivalent
      edu == 3 ~ "SomeCol",     # Some college, no degree
      edu %in% c(4, 5) ~ "Associate",  # Associate degree (vocational/academic)
      edu == 6 ~ "Bachelors",    # Bachelor's degree
      edu %in% c(7, 8) ~ "Postgrad",  # Master's, Professional, or Doctorate
      edu == 95 ~ NA_character_,  # Other (unclear category, better to remove)
      edu %in% c(-9, -8) ~ NA_character_
    ),
    
    # Fix encoding issues in education (Bachelor’s appearing weird)
    edu = iconv(edu, from = "UTF-8", to = "ASCII//TRANSLIT"),
    
    # Recode Abortion Opinion (-9, -8 converted to NA)
    abortion_opinion = case_when(
      abortion_opinion == 1 ~ "Never Permitted",
      abortion_opinion == 2 ~ "Only in Cases of Rape/Incest/Life Danger",
      abortion_opinion == 3 ~ "Limited Circumstances",
      abortion_opinion == 4 ~ "Always Allowed",
      abortion_opinion == 5 ~ "Other",
      abortion_opinion %in% c(-9, -8) ~ NA_character_
    )
  )

# Debug: Check missing values after transformation
summary(df_survey_cleaned)

# Debug: Check if state values look correct
print(table(df_survey_cleaned$state, useNA = "always"))

# Save cleaned dataset for Abortion
write_csv(df_survey_cleaned, "C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/abortion_cleaned_survey_data.csv")
