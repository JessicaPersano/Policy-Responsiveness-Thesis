# ==========================================
# 1. Data Cleaning for MRP - Abortion
# ==========================================

# Load required libraries
library(tidyverse)
library(lme4)
library(tidycensus)

# Load the cleaned survey data
df_survey_cleaned <- read.csv("C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/abortion_cleaned_survey_data.csv")

# Remove rows with missing key variables
df_survey_cleaned <- df_survey_cleaned %>%
  drop_na(state, age_group, gender, race, hispanic, edu, abortion_opinion)

#Standardize categorical variables
df_survey_cleaned <- df_survey_cleaned %>%
  mutate(
    # Fix state naming to match Census format
    state = str_to_title(state),
    state = recode(state, "District of Columbia" = "District Of Columbia"),
    state = factor(state),
    
    # Recode gender to match Census exactly
    gender = factor(recode(gender,
                           "Male" = "Male",
                           "Female" = "Female")),
    
    # Recode hispanic as a binary factor
    hispanic = factor(recode(hispanic,
                             "Hispanic" = "Hispanic",
                             "Not Hispanic" = "Not Hispanic")),
    
    # Standardize Race Categories
    # Recode Race (separate Hispanic category)
    race = factor(recode(race, 
                         "White" = "White", 
                         "Black" = "Black",
                         "American Indian/Alaska Native" = "Native American",
                         "Asian" = "Asian",
                         "Native Hawaiian/Pacific Islander" = "Pacific Islander",
                         "Multiple Races" = "Two or More Races")),
    
    # Recode Education
    edu = factor(recode(edu, 
                        "NoHS" = "NoHS", 
                        "HS" = "HS",
                        "SomeCol" = "SomeCol", 
                        "Associate" = "SomeCol",  
                        "Bachelors" = "CollegeOrHigher", 
                        "Postgrad" = "CollegeOrHigher")),
    
    # Recode age group with explicit factor levels
    age_group = factor(recode(age_group,
                              "18-29" = "18-29",
                              "30-44" = "30-44",
                              "45-64" = "45-64",
                              "65+" = "65+"),
                       levels = c("18-29", "30-44", "45-64", "65+")),
    
    # Standardize **Abortion Opinion Scale**
    abortion_opinion = recode(abortion_opinion, 
                              "Never Permitted" = 0,
                              "Only in Cases of Rape/Incest/Life Danger" = 0,
                              "Limited Circumstances" = 1, 
                              "Always Allowed" = 1,
                              .default = NA_real_) 
  )

# Save cleaned data
write.csv(df_survey_cleaned, "C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/abortion_cleaned_MRP_data.csv", row.names = FALSE)

# Debugging: Check unique values in standardized ANES survey data
print("Checking unique categories in standardized ANES survey data:")
print(list(
  edu = unique(df_survey_cleaned$edu),
  race = unique(df_survey_cleaned$race),
  gender = unique(df_survey_cleaned$gender),
  age_group = unique(df_survey_cleaned$age_group),
  state = unique(df_survey_cleaned$state),
  hispanic = unique(df_survey_cleaned$hispanic)
)) 

# ==========================================
# 2. Multilevel Regression and Poststratification (MRP)
# ==========================================

# Fit the MRP multilevel model
model_opinion <- lmer(
  abortion_opinion ~ gender + hispanic + (1 | edu) + (1 | race) + (1 | age_group) + (1 | state), 
  data = df_survey_cleaned
)

# Set Census API key
census_api_key("insert_api_key", install = TRUE, overwrite = TRUE)

# Manually read in the stored API key
readRenviron("~/.Renviron")  # Reload the environment

# Confirm API key is set
Sys.getenv("CENSUS_API_KEY")  # Check if the key is set correctly

# Download Census ACS 5-Year data for poststratification (in batches)

# Fetch AGE data
acs_data_part1 <- get_acs(
  geography = "state",
  variables = c(
    "B01001_007E", "B01001_008E", "B01001_009E", "B01001_010E", "B01001_011E",
    "B01001_012E", "B01001_013E", "B01001_014E", "B01001_015E", "B01001_016E",
    "B01001_017E", "B01001_018E", "B01001_019E", "B01001_020E", "B01001_021E",
    "B01001_022E", "B01001_023E", "B01001_024E", "B01001_025E",
    
    "B01001_031E", "B01001_032E", "B01001_033E", "B01001_034E", "B01001_035E",
    "B01001_036E", "B01001_037E", "B01001_038E", "B01001_039E", "B01001_040E",
    "B01001_041E", "B01001_042E", "B01001_043E", "B01001_044E", "B01001_045E",
    "B01001_046E", "B01001_047E", "B01001_048E", "B01001_049E"
  ),
  year = 2021,
  survey = "acs5",
  cache_table = TRUE 
) %>%
  rename(state = NAME) %>%
  mutate(
    variable = recode(variable,
                      "B01001_007" = "male_age_18_19", "B01001_008" = "male_age_20", "B01001_009" = "male_age_21",
                      "B01001_010" = "male_age_22_24", "B01001_011" = "male_age_25_29", "B01001_012" = "male_age_30_34",
                      "B01001_013" = "male_age_35_39", "B01001_014" = "male_age_40_44", "B01001_015" = "male_age_45_49",
                      "B01001_016" = "male_age_50_54", "B01001_017" = "male_age_55_59", "B01001_018" = "male_age_60_61",
                      "B01001_019" = "male_age_62_64", "B01001_020" = "male_age_65_66", "B01001_021" = "male_age_67_69",
                      "B01001_022" = "male_age_70_74", "B01001_023" = "male_age_75_79", "B01001_024" = "male_age_80_84",
                      "B01001_025" = "male_age_85_plus",
                      
                      "B01001_031" = "female_age_18_19", "B01001_032" = "female_age_20", "B01001_033" = "female_age_21",
                      "B01001_034" = "female_age_22_24", "B01001_035" = "female_age_25_29", "B01001_036" = "female_age_30_34",
                      "B01001_037" = "female_age_35_39", "B01001_038" = "female_age_40_44", "B01001_039" = "female_age_45_49",
                      "B01001_040" = "female_age_50_54", "B01001_041" = "female_age_55_59", "B01001_042" = "female_age_60_61",
                      "B01001_043" = "female_age_62_64", "B01001_044" = "female_age_65_66", "B01001_045" = "female_age_67_69",
                      "B01001_046" = "female_age_70_74", "B01001_047" = "female_age_75_79", "B01001_048" = "female_age_80_84",
                      "B01001_049" = "female_age_85_plus"
    )
  )

Sys.sleep(3)  # Prevent API rate limit errors

# Fetch RACE & HISPANIC data
acs_data_part2 <- get_acs(
  geography = "state",
  variables = c(
    "B03002_003E", "B03002_004E", "B03002_005E", "B03002_006E",
    "B03002_007E", "B03002_008E", "B03002_009E", "B03002_012E"
  ),
  year = 2021,
  survey = "acs5",
  cache_table = TRUE
) %>%
  rename(state = NAME) %>%
  mutate(
    variable = recode(variable,
                      "B03002_003" = "White",
                      "B03002_004" = "Black",
                      "B03002_005" = "Native American",
                      "B03002_006" = "Asian",
                      "B03002_007" = "Pacific Islander",
                      "B03002_008" = "Other",
                      "B03002_009" = "Two or More Races",
                      "B03002_012" = "Hispanic or Latino"
    )
  )

Sys.sleep(3)  # Prevent API rate limit errors

# Fetch GENDER data
acs_data_part3 <- get_acs(
  geography = "state",
  variables = c("B01001_002E", "B01001_026E"),
  year = 2021,
  survey = "acs5",
  cache_table = TRUE  
) %>%
  rename(state = NAME) %>%
  mutate(
    variable = recode(variable,
                      "B01001_002" = "Male",
                      "B01001_026" = "Female"
    )
  )

Sys.sleep(3)  # Prevent API rate limit errors

# Fetch EDUCATION data
acs_data_part4 <- get_acs(
  geography = "state",
  variables = c(
    "B15002_003E", "B15002_004E", "B15002_005E", "B15002_006E", 
    "B15002_007E", "B15002_008E", "B15002_009E", "B15002_010E", 
    "B15002_011E", "B15002_012E", "B15002_013E", "B15002_014E", 
    "B15002_015E", "B15002_016E", "B15002_017E", "B15002_018E", 
    "B15002_020E", "B15002_021E", "B15002_022E", "B15002_023E", 
    "B15002_024E", "B15002_025E", "B15002_026E", "B15002_027E", 
    "B15002_028E", "B15002_029E", "B15002_030E", "B15002_031E", 
    "B15002_032E", "B15002_033E", "B15002_034E", "B15002_035E"
  ),
  year = 2021,
  survey = "acs5",
  cache_table = TRUE 
) %>%
  rename(state = NAME) %>%
  mutate(
    variable = recode(variable,
                      # No High School
                      "B15002_003" = "NoHS", "B15002_004" = "NoHS", "B15002_005" = "NoHS",
                      "B15002_006" = "NoHS", "B15002_007" = "NoHS", "B15002_008" = "NoHS",
                      "B15002_009" = "NoHS", "B15002_010" = "NoHS",
                      "B15002_020" = "NoHS", "B15002_021" = "NoHS", "B15002_022" = "NoHS",
                      "B15002_023" = "NoHS", "B15002_024" = "NoHS", "B15002_025" = "NoHS",
                      "B15002_026" = "NoHS", "B15002_027" = "NoHS",
                      
                      # High School Graduate
                      "B15002_011" = "HS", "B15002_028" = "HS",
                      
                      # Some College **(Now Includes Associate Degrees)**
                      "B15002_012" = "SomeCol", "B15002_013" = "SomeCol", "B15002_014" = "SomeCol",
                      "B15002_029" = "SomeCol", "B15002_030" = "SomeCol", "B15002_031" = "SomeCol",
                      "B15002_015" = "SomeCol", "B15002_016" = "SomeCol",  # **Moved Associate Degrees to SomeCol**
                      
                      # College or Higher
                      "B15002_017" = "CollegeOrHigher", "B15002_018" = "CollegeOrHigher",
                      "B15002_032" = "CollegeOrHigher", "B15002_033" = "CollegeOrHigher",
                      "B15002_034" = "CollegeOrHigher", "B15002_035" = "CollegeOrHigher"
    )
  ) 

Sys.sleep(3)  # Prevent API rate limit errors

# Combine census data into one
acs_data <- bind_rows(acs_data_part1, acs_data_part2, acs_data_part3, acs_data_part4)

# Debugging: Check unique variable names before processing
print("Unique variable names in Census data:")
print(unique(acs_data$variable))

# Convert to title case and remove Puerto Rico
poststrat_table <- acs_data %>%
  mutate(state = str_to_title(state)) %>%
  filter(state != "Puerto Rico")

# Aggregate estimates before reshaping to wide format
poststrat_table <- poststrat_table %>%
  group_by(GEOID, state, variable) %>%
  summarize(estimate = sum(estimate), .groups = "drop")

# Pivot the table from long format to wide format
poststrat_wide <- poststrat_table %>%
  pivot_wider(
    names_from = variable,
    values_from = estimate
  )

# View transformed data (for debugging)
print(head(poststrat_wide))

#Process Census data 
poststrat_wide <- poststrat_wide %>%
  mutate(
    # Assign Hispanic category
    hispanic = ifelse(`Hispanic or Latino` > 0, "Hispanic", "Not Hispanic"),
    
    # Assign Race categories
    race = case_when(
      White > 0 ~ "White",
      Black > 0 ~ "Black",
      `Native American` > 0 ~ "Native American",
      Asian > 0 ~ "Asian",
      `Pacific Islander` > 0 ~ "Pacific Islander",
      `Two or More Races` > 0 ~ "Two or More Races",
      TRUE ~ NA_character_
    ),
    
    # Assign Gender categories
    gender = case_when(
      Male > 0 ~ "Male",
      Female > 0 ~ "Female",
      TRUE ~ NA_character_
    ),
    
    # Assign Education categories
    edu = case_when(
      NoHS > 0 ~ "NoHS",
      HS > 0 ~ "HS",
      SomeCol > 0 ~ "SomeCol",
      CollegeOrHigher > 0 ~ "CollegeOrHigher",
      TRUE ~ NA_character_
    ),
    
    # Assign Age Group categories based on presence of age variables
    age_group = case_when(
      `male_age_18_19` > 0 | `male_age_20` > 0 | `male_age_21` > 0 | 
        `male_age_22_24` > 0 | `male_age_25_29` > 0 |
        `female_age_18_19` > 0 | `female_age_20` > 0 | `female_age_21` > 0 | 
        `female_age_22_24` > 0 | `female_age_25_29` > 0 ~ "18-29",
      
      `male_age_30_34` > 0 | `male_age_35_39` > 0 | `male_age_40_44` > 0 |
        `female_age_30_34` > 0 | `female_age_35_39` > 0 | `female_age_40_44` > 0 ~ "30-44",
      
      `male_age_45_49` > 0 | `male_age_50_54` > 0 | `male_age_55_59` > 0 |
        `male_age_60_61` > 0 | `male_age_62_64` > 0 |
        `female_age_45_49` > 0 | `female_age_50_54` > 0 | `female_age_55_59` > 0 |
        `female_age_60_61` > 0 | `female_age_62_64` > 0 ~ "45-64",
      
      `male_age_65_66` > 0 | `male_age_67_69` > 0 | `male_age_70_74` > 0 |
        `male_age_75_79` > 0 | `male_age_80_84` > 0 | `male_age_85_plus` > 0 |
        `female_age_65_66` > 0 | `female_age_67_69` > 0 | `female_age_70_74` > 0 |
        `female_age_75_79` > 0 | `female_age_80_84` > 0 | `female_age_85_plus` > 0 ~ "65+",
      
      TRUE ~ NA_character_
    )
  )

# Debugging: Check for missing values **before filtering**
print("Checking missing values BEFORE filtering:")
print(colSums(is.na(poststrat_wide)))

# Ensure all mappings are **correct before filtering**
print("Sample rows with missing values in Census Data:")
print(poststrat_wide %>% filter(is.na(age_group) | is.na(race) | is.na(gender) | is.na(edu)) %>% head(10))

# **Filter only after verifying that mappings are correct**
poststrat_wide <- poststrat_wide %>%
  filter(!is.na(age_group) & !is.na(race) & !is.na(gender) & !is.na(edu) & !is.na(state))

# Debugging: Check **final** missing values after filtering
print("Checking missing values AFTER filtering:")
print(colSums(is.na(poststrat_wide)))

# Summarize and compute demographic frequencies within each state
census <- poststrat_wide %>%
  pivot_longer(cols = where(is.numeric), names_to = "variable", values_to = "estimate") %>%
  group_by(state, age_group, race, hispanic, gender, edu, variable) %>%
  summarise(freq = sum(estimate, na.rm = TRUE), .groups = "drop")

# Compute state proportions for poststratification
census <- census %>%
  group_by(state) %>%
  mutate(state_prop = freq / sum(freq, na.rm = TRUE)) %>%  # Compute within-state proportions
  ungroup()

# Debugging: Ensure proportions sum to 1 within each state
print(census %>% group_by(state) %>% summarise(total_prop = sum(state_prop, na.rm = TRUE)))

print(summary(census))  # Debug: Ensure census is not empty
print(head(census))  # Debug: Check computed `state_prop` values

# ==========================================
# 3. Generate Predictions & Compute State-Level Estimates
# ==========================================

# Generate Predictions & Compute State-Level Estimates
census$predictions <- predict(model_opinion, newdata = census, allow.new.levels = TRUE)

# Apply poststratification weighting
census$weighted_preds <- census$predictions * census$state_prop

# Aggregate to state level by summing weighted predictions
state_avg_opinion <- census %>%
  group_by(state) %>%
  summarise(estimated_opinion = sum(weighted_preds, na.rm = TRUE), .groups = "drop")

# Save the results to CSV
write.csv(state_avg_opinion, "C:/Users/jessi/Dropbox/Honors_Thesis/Data/Cleaned/abortion_opinion_state.csv", row.names = FALSE)

# Print summary of state-level estimates
print(state_avg_opinion)
