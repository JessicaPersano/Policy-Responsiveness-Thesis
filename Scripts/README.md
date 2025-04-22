# Scripts Folder

This folder contains all R scripts used to process, analyze, and summarize state-level policy representation using survey data and policy outcome data. While the abortion policy pipeline is featured here as a case study, the same modular structure was used for all eight policy topics in the full analysis.

Below is a description of each script:

---

### 1. `Abortion_Data_Preprocessing.R`

**Purpose:**  
Prepares raw survey data for use in Multilevel Regression and Poststratification (MRP).

**Key Steps:**  
- Loads raw ANES 2020 data.
- Selects and recodes key variables: state, age, gender, race, education, Hispanic origin, and abortion opinion.
- Converts FIPS codes to state names and categorizes demographics.
- Saves a cleaned CSV for use in MRP modeling.

---

### 2. `Abortion_MRP.R`

**Purpose:**  
Implements MRP to estimate state-level public opinion on abortion.

**Key Steps:**  
- Standardizes cleaned survey data for model input.
- Fits a multilevel logistic regression predicting abortion opinion by demographics.
- Downloads ACS Census data using the `tidycensus` package.
- Poststratifies to generate weighted state-level opinion estimates.
- Saves final public opinion estimates for merging.

---

### 3. `Abortion_Merge.R`

**Purpose:**  
Merges MRP-generated public opinion estimates with state-level abortion policy outcomes.

**Key Steps:**  
- Loads state-level opinion estimates and abortion policy data.
- Standardizes state names and formats.
- Merges datasets by state.
- Saves merged dataset for use in regression and congruence analysis.

---

### 4. `Abortion_Responsiveness.R`

**Purpose:**  
Analyzes **policy responsiveness**—whether policy adoption is predicted by public opinion.

**Key Steps:**  
- Loads the merged abortion data.
- Runs a logistic regression of policy on estimated opinion.
- Saves regression coefficients and model summary.
- Visualizes the relationship between public opinion and abortion policy using a jittered scatter plot with a 95% confidence interval.

---

### 5. `Abortion_Congruence.R`

**Purpose:**  
Analyzes **policy congruence**—whether the policy matches majority public opinion in each state.

**Key Steps:**  
- Defines binary congruence using a 0.5 threshold on opinion estimates.
- Calculates congruence at the state and overall level.
- Saves congruence summary to CSV.
- Creates bar plots showing overall and state-level congruence.

---

### 6. `Aggregate_Policy_Analysis_Results.R`  

**Purpose:**  
Aggregates and summarizes results across **all eight policy topics** (not just abortion).

**Key Steps:**  
- Loads all responsiveness and congruence CSVs.
- Generates summary tables of responsiveness coefficients and congruence rates by topic.
- Categorizes each policy by type (moral/technical) and salience (high/low).
- Creates final publication-ready bar charts and a compiled summary dataset used in the results section of the thesis.

---

### Adaptability

Each script is modular and can be adapted to other policy topics by:
- Replacing input survey and policy data files,
- Adjusting variable names and recoding logic,
- Repeating the MRP and regression steps using the same structure.

For more details on how to replicate the analysis for other policy areas, see the main project `README.md`.
