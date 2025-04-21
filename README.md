# Policy-Responsiveness-Thesis

This repository contains the R scripts and datasets for my UCLA Political Science Honors Thesis,  
**"The Determinants of Policy Representation: Evaluating the Role of Policy Type in the US States."**  

My research examines how different types of policies—categorized by **salience** and **morality**—affect the degree to which state policies align with public opinion. Using **Multilevel Regression and Poststratification (MRP)**, I estimate state-level public opinion and analyze:

- **Policy Responsiveness**: Whether policy changes in response to shifts in public opinion.  
- **Policy Congruence**: Whether policy outcomes match the majority opinion.

---

## Repository Overview

This repository contains a complete pipeline for analyzing state-level policy representation using MRP and regression-based measures of responsiveness and congruence. While the repository currently showcases the full analysis for **abortion policy**, the same process has been completed for **eight distinct policy topics**, with abortion provided here as an illustrative example.

---

## Core Components (Abortion Case Study)

1. **`Abortion_Data_Preprocessing.R`**  
   Cleans and recodes raw ANES survey data, preparing demographic and opinion variables for MRP.

2. **`Abortion_MRP.R`**  
   Estimates state-level public opinion on abortion using MRP with survey and U.S. Census ACS data.

3. **`Abortion_Merge.R`**  
   Merges MRP-generated opinion estimates with state-level abortion policy data.

4. **`Abortion_Responsiveness.R`**  
   Uses logistic regression to assess whether policy adoption aligns with shifts in public opinion.

5. **`Abortion_Congruence.R`**  
   Calculates whether state policy direction matches majority public opinion.

6. **`Final_Results.R`**  
   Aggregates summary statistics and visualizations across **all eight policy topics**.  
   Once individual results are saved, this script compiles:
   - Overall responsiveness and congruence tables  
   - Category summaries by policy type and salience  
   - Final publication-ready visualizations

---

## Adaptability

Each script is modular and reproducible, enabling easy substitution of topic-specific variables, datasets, and file paths. This design supports consistent comparative analysis across a wide range of issue areas.

---

## Contribution

This research contributes to the fields of **political representation**, **public opinion**, and **state policy analysis**, offering a replicable framework for understanding when and why policies reflect constituent preferences. The abortion policy example serves as a detailed case study to demonstrate the full methodology.

---

## Contact

For questions, collaborations, or feedback, feel free to reach out:

- 📧 Email: [jessicapersano01@gmail.com](mailto:jessicapersano01@gmail.com)  
- 🔗 LinkedIn: [linkedin.com/in/jessica-persano](https://www.linkedin.com/in/jessica-persano/)

---

*Expect frequent updates as I refine my analysis and expand the dataset.*
