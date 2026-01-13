# The Determinants of Policy Representation: Evaluating the Role of Policy Type in the U.S. States

**UCLA Political Science Honors Thesis**  
**Author:** Jessica Persano  
**Advisor:** [Advisor name if you want to include]  
**Date:** April 2025

---

## Abstract

This thesis examines how different types of policies—categorized by **salience** and **morality**—affect the degree to which state policies align with public opinion. Using **Multilevel Regression and Poststratification (MRP)** to estimate state-level public opinion, I analyze two dimensions of representation:

- **Policy Responsiveness**: Whether policy changes in response to shifts in public opinion
- **Policy Congruence**: Whether policy outcomes match majority opinion

The analysis covers eight distinct policy areas, with abortion policy provided as a fully documented case study.

📄 **[Read the full thesis (PDF)](Persano_Policy_Responsiveness_Thesis.pdf)**

---

## Repository Structure

```
Policy-Responsiveness-Thesis/
├── Original_Data/          # Raw datasets with documentation
│   └── README.md           # Data sources and descriptions
├── Scripts/                # R analysis pipeline
│   ├── Abortion_Data_Preprocessing.R
│   ├── Abortion_MRP.R
│   ├── Abortion_Merge.R
│   ├── Abortion_Responsiveness.R
│   ├── Abortion_Congruence.R
│   ├── Compile_All_Policy_Results.R
│   └── README.md           # Script documentation
├── Persano_Policy_Responsiveness_Thesis.pdf
└── README.md
```

---

## Methodology

### Data
- **Survey Data:** [Specify sources, e.g., CCES, ANES, etc.]
- **Policy Data:** [Specify sources]
- **Demographic Data:** U.S. Census / ACS

### Analysis Pipeline

| Script | Purpose |
|--------|---------|
| `Abortion_Data_Preprocessing.R` | Cleans and recodes raw survey data |
| `Abortion_MRP.R` | Estimates state-level opinion via MRP |
| `Abortion_Merge.R` | Combines MRP estimates with policy outcomes |
| `Abortion_Responsiveness.R` | Models opinion-policy relationship |
| `Abortion_Congruence.R` | Calculates policy-opinion alignment |
| `Compile_All_Policy_Results.R` | Aggregates results across all 8 policy areas |

---

## Replication

Scripts are modular and designed for reproducibility. To adapt for other policy areas:

1. Update input data paths
2. Adjust variable names and recoding logic
3. Run scripts in sequential order

### Requirements
- R (≥ 4.0)
- Required packages: `tidyverse`, `brms`, `lme4`, [add others you use]

---

## Citation

If you use this code or find this research helpful, please cite:

```
Persano, Jessica. 2025. "The Determinants of Policy Representation: Evaluating 
the Role of Policy Type in the U.S. States." Honors Thesis, University of 
California, Los Angeles.
```

---

## Contact

**Jessica Persano**  
Predoctoral Research Fellow, Stanford Graduate School of Business

- 📧 jpersano@stanford.edu
- 🔗 [jessicapersano.github.io](https://jessicapersano.github.io)
- 💼 [LinkedIn](https://www.linkedin.com/in/jessica-persano/)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
