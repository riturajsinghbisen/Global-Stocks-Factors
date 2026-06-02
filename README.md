# Do Some Stocks Always Beat Others?
### Exploring Global Stock Factors with R

A data analysis project 

> 🏆 **Accepted at useR! 2026 Conference — Warsaw, Poland | 6–9 July 2026**

---

## Overview

This project explores whether simple, measurable patterns in stock data can predict
returns. Using a dataset of 100 global companies across 9 countries and 20 quarters
(2019–2023), it tests three classic factor investing strategies — market sensitivity,
size, and momentum — and layers in macroeconomic variables to understand what
drives global stock returns.

---

## Conference

| | |
|---|---|
| **Conference** | useR! 2026 |
| **Location** | Warsaw, Poland |
| **Dates** | 6–9 July 2026 |
| **Website** | https://user2026.r-project.org/ |

---

## Dataset

| Property | Value |
|---|---|
| File | `GlobalStockFactors.csv` |
| Rows | 2,000 |
| Companies | 100 |
| Quarters | 20 (Q1 2019 – Q4 2023) |
| Countries | Australia, Canada, China, France, Hong Kong, India, Japan, UK, USA |
| Sectors | 8 |
| Missing Values | None |

---

## Key Findings

| Factor | Theory Predicts | What Data Shows | Confirmed? | Premium |
|---|---|---|---|---|
| Market (Beta) | Higher β → higher return | Clear upward trend | ✅ Yes | ~8.9%/yr |
| Size (SMB) | Small beats Large | Reversed: Large wins | ❌ No | –0.54%/yr |
| Momentum | Winners keep winning | Strongly confirmed (r = 0.32) | ✅ Yes | ~9.3%/yr |

### Other highlights
- VIX (fear index) had the strongest single correlation with returns (r = –0.53)
- GDP growth was the strongest positive predictor (r = +0.662)
- Full regression model explained **50.9% of return variance** (R² = 0.509)
- 5 significant predictors: Beta, GDP Growth, VIX, US CPI, US Fed Rate

---

## Project Structure
├── GlobalStockFactors.csv      # Dataset
├── 00_setup.R                  # Load libraries and data
├── 01_summary_stats.R          # Summary statistics
├── 02_eda_plots.R              # Exploratory data analysis plots
├── 03_correlation.R            # Correlation analysis
├── 04_factor_market.R          # Market factor (Beta / CAPM)
├── 05_factor_size.R            # Size factor (SMB)
├── 06_factor_momentum.R        # Momentum factor
├── 07_macro_vix_gdp.R          # Macroeconomic drivers (VIX, GDP, Oil)
├── 08_regression.R             # Multiple regression model
└── 09_run_all.R                # Run all scripts in order

---

## How to Run

```r
# Install required packages
install.packages(c("ggplot2", "dplyr"))

# Option 1 — Run everything at once
source("09_run_all.R")

# Option 2 — Run scripts individually in order
source("00_setup.R")
source("01_summary_stats.R")
source("02_eda_plots.R")
source("03_correlation.R")
source("04_factor_market.R")
source("05_factor_size.R")
source("06_factor_momentum.R")
source("07_macro_vix_gdp.R")
source("08_regression.R")
```

---

## Tools Used

- **R** — data analysis and statistical modelling
- **ggplot2** — all visualisations
- **dplyr** — data manipulation
- **Base R** — OLS regression, correlation tests, diagnostics

---

## Report Structure

1. Abstract
2. Introduction — What is Factor Investing?
3. Dataset Description
4. Exploratory Data Analysis
5. Factor Analysis I — Market Factor (Beta) and Size (SMB)
6. Factor Analysis II — Momentum
7. Macroeconomic Drivers (VIX, GDP, Oil)
8. Multiple Regression Model
9. Summary of Findings
10. Conclusion and Limitations

---

> *"The stock market is a device for transferring money from the impatient to the patient."*
> — Warren Buffett

---

*Data sourced from GlobalStockFactors.csv (simulated panel dataset)*
