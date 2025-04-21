# Original Data Folder

This folder contains the **raw policy datasets** used in my policy responsiveness honors thesis. These datasets capture whether each U.S. state had adopted liberal or conservative policies across eight issue areas, and serve as the original inputs for policy congruence and responsiveness analysis.

---

## Included in This Folder:

**Policy Data (CSV format):**
- `abortion_policy_data.csv`
- `death_penalty_policy_data.csv`
- `drugsentence_policy_data.csv`
- `gun_control_policy_data.csv`
- `medicaid_policy_data.csv`
- `minwage_policy_data.csv`
- `paidleave_policy_data.csv`
- `renewable_policy_data.csv`

Each CSV contains a row per U.S. state and binary indicators representing whether the state’s policy aligns with a liberal (1) or conservative (0) stance on the topic, as of the relevant year.

---

## Not Included (Survey Data)

Due to GitHub’s file size limits, the national survey datasets used to estimate public opinion via Multilevel Regression and Poststratification (MRP) **are not included here**. These files exceed the upload limits but are publicly available and free to download from the following sources:

### Survey Datasets Used:

| Survey       | Topics Covered                                  | Download Link |
|--------------|--------------------------------------------------|----------------|
| **ANES 2020** | Abortion, Gun Control, Capital Punishment        | https://electionstudies.org/data-center/2020-time-series-study |
| **CCES 2018** | Minimum Wage                                     | https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910/DVN/ZSBZ7K |
| **CCES 2020** | Drug Sentencing Reform, Renewable Energy Mandates| https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910/DVN/E9N6PH |
| **CCES 2021** | Medicaid Expansion, Paid Family Leave            | https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910/DVN/OPQOCU |

To replicate the full analysis pipeline, download these files manually and place them in your own local `Data/Original/` directory before running the scripts.

---

For questions about sourcing, usage rights, or file formats, feel free to reach out at [jessicapersano01@gmail.com](mailto:jessicapersano01@gmail.com).
