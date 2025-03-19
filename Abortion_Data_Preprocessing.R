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
    # Convert missing state values (-1, 9, -8, 86) to NA
    state = ifelse(state %in% c(-1, -9, -8, 86), NA, state), 
    
    # Fix missing age (-9 to NA)
    age = as.numeric(age),  # Ensure age is recognized
    age = ifelse(age == -9, NA, age),
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
      edu == 6 ~ "CollegeOrHigher",    # Bachelor's degree
      edu %in% c(7, 8) ~ "CollegeOrHigher",  # Master's, Professional, or Doctorate
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

# Save cleaned dataset
write_csv(df_survey_cleaned, "C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/cleaned_survey_data_abortion.csv")
