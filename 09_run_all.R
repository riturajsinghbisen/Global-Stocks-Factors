# ============================================================
#  09_run_all.R
#  Master script -- runs the entire project in one shot.
#  Just set your working directory to the project folder
#  and source this file.
#
#  Order of execution:
#    00_setup.R           -- load data, libraries, shared vars
#    01_summary_stats.R   -- descriptive statistics tables
#    02_eda_plots.R       -- EDA visualisations (5 plots)
#    03_correlation.R     -- correlation matrix + heatmap
#    04_factor_market.R   -- Factor 1: Market / Beta
#    05_factor_size.R     -- Factor 2: Size (SMB)
#    06_factor_momentum.R -- Factor 3: Momentum
#    07_macro_vix_gdp.R   -- Macro: VIX, GDP, Oil Price
#    08_regression.R      -- Multiple regression model
# ============================================================

cat("====================================================\n")
cat("  Global Stock Factor Analysis -- Full Pipeline\n")
cat("  Rituraj Singh (24519)\n")
cat("  Data Analysis and Visualization\n")
cat("====================================================\n\n")

if (!file.exists("GlobalStockFactors.csv")) {
  stop("GlobalStockFactors.csv not found in working directory.\n",
       "Set your working directory with setwd() first.")
}

start_time <- proc.time()

scripts <- c(
  "01_summary_stats.R",
  "02_eda_plots.R",
  "03_correlation.R",
  "04_factor_market.R",
  "05_factor_size.R",
  "06_factor_momentum.R",
  "07_macro_vix_gdp.R",
  "08_regression.R"
)
# Running them individually is fine too.

for (sc in scripts) {
  cat("\n----------------------------------------------------\n")
  cat("Running:", sc, "\n")
  cat("----------------------------------------------------\n")
  source(sc)
}

elapsed <- proc.time() - start_time
cat("\n====================================================\n")
cat("  All scripts completed!\n")
cat(sprintf("  Total time: %.1f seconds\n", elapsed["elapsed"]))
cat("====================================================\n")
