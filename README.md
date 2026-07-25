# Culture Talk Stratification

This repository contains the complete replication materials—data, code, manuscripts, and presentation slides—for the paper **"Culture Talk Stratification"** (based on the original Stata analyses port to R) published in *Poetics*. 

The paper examines the stratification of cultural talk across various domains (movies, music, books, visual arts, dramatic performances), looking at how engagement and demographic factors (education, income, age, gender, city) intersect to shape cultural conversation.

[Link to the paper](poetics-paper.pdf)

---

## 📂 Repository Structure

The project directory is structured as follows:

```text
├── qmd/                            # Quarto notebooks with the computational pipeline
│   ├── 01_data_prep.qmd            # Data wrangling and variable preparation
│   └── 02_analysis.qmd             # Main ordered probit models and factor analyses
├── dat/                            # Processed data, including pre-computed RDS
├── Tabs/                           # Auto-generated regression tables (HTML)
├── Plots/                          # Auto-generated plots (to be populated)
├── NSS-2002-2004-using.dta         # Original Stata dataset
├── analysis-R2-v3.do               # Original Stata analysis script
├── poetics-paper.pdf               # Published version of the paper
├── renv.lock                       # renv lockfile for exact package versions
└── renv/                           # Project-local R library configuration
```

---

## 🛠️ Prerequisites & Installation

To run the reproducibility workflow, you will need **R** and the **Quarto** CLI (pre-installed in Positron and RStudio).

### 1. Required R Packages
Ensure you have the required R packages installed. You can install them by running the following command in your R console:

```R
renv::restore()
```

This project uses `renv` to lock down dependencies. Running `renv::restore()` will automatically install all CRAN dependencies necessary to replicate the results.

---

## 🚀 How to Reproduce the Findings

1. **Clone the Repository**: Clone this repository to your local machine using git or download it as a ZIP file.
2. **Open the Project**: Open the `.Rproj` file in your editor (e.g., RStudio or Positron). This ensures paths are resolved correctly relative to the project root.
3. **Install Dependencies**: Run `renv::restore()` to install the locked package versions.
4. **Run the Computational Pipeline**:
   The replication pipeline is divided into Quarto notebooks in the `qmd/` folder:
   
   * **Using the Command Line (Quarto CLI)**:
     ```bash
     quarto render qmd/01_data_prep.qmd
     quarto render qmd/02_analysis.qmd
     ```
   * **Using R**:
     ```R
     quarto::quarto_render("qmd/01_data_prep.qmd")
     quarto::quarto_render("qmd/02_analysis.qmd")
     ```

All auto-generated tables and figures are stored in the `Tabs/` and `Plots/` directories, respectively.

---

## 📝 License & Citation

If you use the materials or code in this repository, please cite the paper:

```bibtex
@article{lizardo20xx,
  title={Culture Talk Stratification},
  author={Lizardo, Omar},
  journal={Poetics},
  year={20xx}
}
```
