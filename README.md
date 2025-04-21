# Policy-Responsiveness-Thesis

This repository contains the R scripts and datasets for my UCLA Political Science Honors Thesis,  
**"The Determinants of Policy Representation: Evaluating the Role of Policy Type in the US States."**  

My research examines how different types of policies—categorized by **salience** and **morality**—affect the degree to which state policies align with public opinion. Using **Multilevel Regression and Poststratification (MRP)**, I estimate state-level public opinion and analyze:

- **Policy Responsiveness**: Whether policy changes in response to shifts in public opinion.  
- **Policy Congruence**: Whether policy outcomes match the majority opinion.

---

## Repository Overview

This repository contains a complete, modular pipeline for analyzing state-level policy representation using survey data, policy datasets, MRP modeling, and statistical analysis. While the repository currently showcases the full analysis for **abortion policy**, the same process has been completed for **eight distinct policy topics**, with abortion provided here as a case study.

All scripts are housed in the `Scripts/` folder, and original datasets are located in the `Data/Original/` folder.  
Each folder includes a dedicated `README.md` file explaining its contents in detail, including data sources and code functionality.

---

## Core Components (Abortion Case Study)

- `Abortion_Data_Preprocessing.R`: Cleans and recodes raw survey data.
- `Abortion_MRP.R`: Runs MRP to estimate state-level public opinion.
- `Abortion_Merge.R`: Combines MRP estimates with policy outcomes.
- `Abortion_Responsiveness.R`: Models the relationship between opinion and policy.
- `Abortion_Congruence.R`: Calculates whether policy matches majority opinion.
- `Compile_All_Policy_Results.R`: Summarizes results across all 8 policy areas.

---

## Adaptability

Each script is modular and reproducible, enabling easy substitution of topic-specific variables, datasets, and file paths. This design supports consistent comparative analysis across a wide range of policy areas.

The pipeline can be adapted to new policy topics by updating input data and adjusting variable names or recoding logic in each script.

---

## Contribution

This project contributes to scholarship on **political representation**, **public opinion**, and **state policy outcomes**, offering a replicable, survey-based framework for evaluating whether and when governments respond to constituent preferences. The abortion policy case study provides a fully implemented example.

---

## Contact

For questions, collaborations, or feedback, feel free to reach out:

- 📧 Email: [jessicapersano01@gmail.com](mailto:jessicapersano01@gmail.com)  
- 🔗 LinkedIn: [linkedin.com/in/jessica-persano](https://www.linkedin.com/in/jessica-persano/)

---

*Expect frequent updates as I refine the analysis and expand coverage across additional policy domains.*
