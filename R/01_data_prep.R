# Data preparation
# Run from the repository root: source("R/01_data_prep.R")

library(haven)
library(dplyr)

# Read the original data
df <- read_dta("dat/NSS-2002-2004-using.dta")

# The Stata script creates centered/scaled variables (c_*) by dividing by 2*SD
c_vars <- grep("^c_", names(df), value = TRUE)
for (v in c_vars) {
  df[[v]] <- df[[v]] / (2 * sd(df[[v]], na.rm = TRUE))
}

# Convert labelled variables to factors/numeric to strip haven_labelled class
df <- df %>%
  mutate(across(where(is.labelled), haven::zap_labels)) %>%
  mutate(across(where(is.labelled), haven::zap_formats)) %>%
  mutate(across(where(is.labelled), haven::zap_widths))

# The global xvars are: c_educ_imp c_finc_imp c_age_imp c_gender c_city
# It recodes gender: 2 = 1, 1 = 0
df$gender <- ifelse(df$gender == 2, 1, ifelse(df$gender == 1, 0, NA))

dir.create("dat", showWarnings = FALSE)
saveRDS(df, "dat/small.rds")
