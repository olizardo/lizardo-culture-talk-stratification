# AI Agent Assistance

This repository was modernized and ported from Stata to a reproducible R/Quarto pipeline with the assistance of an AI agent (Positron Assistant). 

## Contributions
- **Stata to R Translation**: Ported the original Stata `.do` scripts, including data preparation, ordered probit modeling, and factor analysis, to R (`qmd/01_data_prep.qmd` and `qmd/02_analysis.qmd`).
- **Reproducibility**: Set up the `renv` environment to lock down package dependencies.
- **Visualization**: Replicated the marginal effects figures reported in the paper using `ggplot2` and `marginaleffects`.
- **Formatting**: Structured the repository and wrote the `README.md` to conform to standard modern open-science formats.
