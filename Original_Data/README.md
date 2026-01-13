# Original Data

This folder contains the **state-level policy outcome datasets** used in the analysis. Each file indicates whether a state has adopted a liberal (1) or conservative (0) policy stance on a given issue.

---

## Policy Data Files

| File | Policy Topic | Coding |
|------|--------------|--------|
| `abortion_policy_data.csv` | Abortion Access | 1 = Liberal (fewer restrictions) |
| `gun_control_policy_data.csv` | Gun Control | 1 = Liberal (more restrictions) |
| `death_penalty_policy_data.csv` | Capital Punishment | 1 = Liberal (abolished) |
| `drugsentence_policy_data.csv` | Drug Sentencing | 1 = Liberal (reform/reduced sentences) |
| `minwage_policy_data.csv` | Minimum Wage | 1 = Liberal (above federal minimum) |
| `renewable_policy_data.csv` | Renewable Energy | 1 = Liberal (RPS mandate) |
| `medicaid_policy_data.csv` | Medicaid Expansion | 1 = Liberal (expanded under ACA) |
| `paidleave_policy_data.csv` | Paid Family Leave | 1 = Liberal (state mandate) |

### File Structure

Each CSV contains:
- `state`: State name
- `year`: Year of policy measurement
- `policy_score`: Binary indicator (0 = conservative, 1 = liberal)

---

## Survey Data (Not Included)

Due to file size limits, the national survey datasets used to estimate public opinion via MRP are **not included** in this repository. These files are publicly available for free download:

### Download Links

| Survey | Year | Topics Covered | Link |
|--------|------|----------------|------|
| **ANES Time Series** | 2020 | Abortion, Gun Control, Capital Punishment | [ANES Data Center](https://electionstudies.org/data-center/2020-time-series-study) |
| **CCES** | 2018 | Minimum Wage | [Harvard Dataverse](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910/DVN/ZSBZ7K) |
| **CCES** | 2020 | Drug Sentencing, Renewable Energy | [Harvard Dataverse](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910/DVN/E9N6PH) |
| **CCES** | 2021 | Medicaid Expansion, Paid Family Leave | [Harvard Dataverse](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910/DVN/OPQOCU) |

### Replication Instructions

1. Download the survey files from the links above
2. Place them in your local data directory
3. Update file paths in `Scripts/` to point to your local copies
4. Run scripts in order

---

## Demographic Data

Census demographic data for poststratification is downloaded automatically via the `tidycensus` R package using the **ACS 5-Year Estimates (2021)**. 

A Census API key is required. Get one free at:  
https://api.census.gov/data/key_signup.html

---

## Data Sources & Citations

### Survey Data
- American National Election Studies. 2021. *ANES 2020 Time Series Study*. https://electionstudies.org
- Cooperative Election Study. 2018, 2020, 2021. Harvard Dataverse. https://cces.gov.harvard.edu

### Census Data
- U.S. Census Bureau. American Community Survey 5-Year Estimates (2021). Accessed via `tidycensus`.

---

## Questions?

For questions about data sourcing or file formats:

📧 jpersano@stanford.edu
