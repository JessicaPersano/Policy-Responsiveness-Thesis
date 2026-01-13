# Scripts

This folder contains the R scripts for analyzing state-level policy representation. The abortion policy pipeline is provided as a fully documented case study; the same modular structure was used for all eight policy topics.

---

## Pipeline Overview

```
┌─────────────────────────────┐
│ 1. Data Preprocessing       │  ← Clean raw survey data
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 2. MRP Model                │  ← Estimate state-level opinion
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 3. Merge                    │  ← Combine opinion + policy data
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 4. Responsiveness           │  ← Logistic regression analysis
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 5. Congruence               │  ← Policy-opinion alignment
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 6. Aggregate Results        │  ← Compile all 8 policy areas
└─────────────────────────────┘
```

---

## Scripts

### 1. `Abortion_Data_Preprocessing.R`

**Purpose:** Prepare raw ANES survey data for MRP modeling.

**Packages:** `tidyverse`, `haven`

**Key Steps:**
- Load ANES 2020 Time Series data (Stata format)
- Select and rename variables: state (FIPS), age, gender, race, Hispanic origin, education, abortion opinion
- Recode categorical variables into standardized categories
- Convert FIPS codes to state names
- Export cleaned CSV

---

### 2. `Abortion_MRP.R`

**Purpose:** Implement Multilevel Regression and Poststratification to estimate state-level public opinion.

**Packages:** `tidyverse`, `lme4`, `tidycensus`

**Key Steps:**
- Standardize demographic categories to match Census
- Fit multilevel logistic regression:
  ```r
  abortion_opinion ~ gender + hispanic + (1|edu) + (1|race) + (1|age_group) + (1|state)
  ```
- Download ACS 5-Year demographic data via Census API
- Poststratify predictions using Census population weights
- Export state-level opinion estimates

**Note:** Requires Census API key. Get one at: https://api.census.gov/data/key_signup.html

---

### 3. `Abortion_Merge.R`

**Purpose:** Merge MRP opinion estimates with state policy outcomes.

**Packages:** `tidyverse`

**Key Steps:**
- Load MRP state estimates and policy data
- Standardize state names
- Left join on state
- Validate for missing matches
- Export merged dataset

---

### 4. `Abortion_Responsiveness.R`

**Purpose:** Analyze policy responsiveness—does public opinion predict policy adoption?

**Packages:** `tidyverse`, `ggplot2`, `ggthemes`

**Key Steps:**
- Fit logistic regression: `policy_score ~ estimated_opinion`
- Extract coefficients and standard errors
- Create scatter plot with logistic regression curve and 95% CI
- Export results and visualization

---

### 5. `Abortion_Congruence.R`

**Purpose:** Analyze policy congruence—does policy match majority opinion?

**Packages:** `tidyverse`, `ggplot2`, `ggthemes`

**Key Steps:**
- Define congruence using 0.5 threshold on opinion estimates
- Calculate state-level and overall congruence rates
- Create bar charts for overall and state-level congruence
- Export results and visualizations

---

### 6. `Aggregate_Policy_Analysis_Results.R`

**Purpose:** Compile and summarize results across all eight policy topics.

**Packages:** `dplyr`, `readr`, `ggplot2`

**Key Steps:**
- Load all responsiveness and congruence CSV files
- Generate summary tables with coefficients and significance
- Categorize policies by type (moral/technical) and salience (high/low)
- Create publication-ready bar charts
- Export compiled summary dataset

---

## Required Packages

```r
install.packages(c(
  "tidyverse",
  "haven",
  "lme4", 
  "tidycensus",
  "ggplot2",
  "ggthemes",
  "dplyr",
  "readr"
))
```

---

## Adapting to Other Policy Topics

Each script is modular. To analyze a new policy:

1. **Preprocessing:** Update survey variable names and recoding logic
2. **MRP:** Adjust opinion variable name
3. **Merge:** Point to new policy data file
4. **Responsiveness/Congruence:** Update file paths
5. **Aggregate:** Add new policy to `name_mapping` tibble

---

## Output Files

Scripts generate the following outputs (saved to `Data/Results/`):

| File | Description |
|------|-------------|
| `[policy]_responsiveness_results.csv` | Regression coefficients |
| `[policy]_responsiveness_plot.png` | Scatter plot with regression |
| `[policy]_state_congruence.csv` | State-level congruence rates |
| `[policy]_congruence_plot.png` | Overall congruence bar chart |
| `[policy]_state_congruence_plot.png` | State-level congruence chart |
| `new_compiled_policy_results.csv` | All policies summary |
| `new_category_summary_table.csv` | Results by policy type/salience |
