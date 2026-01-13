# The Determinants of Policy Representation
### Evaluating the Role of Policy Type in the U.S. States

**UCLA Political Science Honors Thesis**  
Jessica Persano | April 2025

---

## Overview

This thesis examines how policy type—categorized by **salience** and **morality**—affects the degree to which state policies align with public opinion. Using Multilevel Regression and Poststratification (MRP), I estimate state-level opinion and analyze **policy responsiveness** and **policy congruence** across eight issue areas.

📄 **[Read the full thesis](Persano_Policy_Responsiveness_Thesis.pdf)**

---

## Repository Structure

```
├── Original_Data/     # Policy datasets + data source documentation
├── Scripts/           # R analysis pipeline (preprocessing → results)
├── Persano_Policy_Responsiveness_Thesis.pdf
├── LICENSE
└── README.md
```

See the README in each folder for detailed documentation.

---

## Quick Start

**Requirements:** R ≥ 4.0, Census API key ([get one here](https://api.census.gov/data/key_signup.html))

```r
install.packages(c("tidyverse", "haven", "lme4", "tidycensus", "ggplot2", "ggthemes"))
```

Survey data must be downloaded separately (see [`Original_Data/README.md`](Original_Data/README.md) for links).

---

## Policy Areas

| Policy | Type | Salience |
|--------|------|----------|
| Abortion | Moral | High |
| Gun Control | Moral | High |
| Capital Punishment | Moral | Low |
| Drug Sentencing | Moral | Low |
| Minimum Wage | Technical | High |
| Renewable Energy | Technical | High |
| Medicaid Expansion | Technical | Low |
| Paid Family Leave | Technical | Low |

---

## Citation

```
Persano, Jessica. 2025. "The Determinants of Policy Representation: Evaluating 
the Role of Policy Type in the U.S. States." Honors Thesis, UCLA.
```

---

## Contact

**Jessica Persano**  
Predoctoral Research Fellow, Stanford GSB

[jessicapersano.github.io](https://jessicapersano.github.io) · [LinkedIn](https://www.linkedin.com/in/jessica-persano/) · jpersano@stanford.edu

---

## License

MIT License. See [LICENSE](LICENSE) for details.
