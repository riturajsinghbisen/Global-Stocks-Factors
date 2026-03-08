# ============================================================
#  01_load_data.R
#  Load the dataset and get a basic overview of what's in it
# ============================================================

library(dplyr)

# --- Load data -----------------------------------------------
data <- read.csv("C:/4thsemester/dav/global-stock-factors-r/repo/data/GlobalStockFactors.csv")

# --- Basic info ----------------------------------------------
cat("Total rows:", nrow(data), "\n")
cat("Total columns:", ncol(data), "\n")
cat("Unique stocks:", n_distinct(data$stock_ticker), "\n")
cat("Unique countries:", n_distinct(data$country), "\n")
cat("Date range:", min(data$date), "to", max(data$date), "\n\n")

# --- Column names --------------------------------------------
cat("Columns:\n")
print(names(data))

# --- Quick peek at first few rows ----------------------------
cat("\nFirst 3 rows:\n")
print(head(data, 3))

# --- Summary of returns --------------------------------------
cat("\nReturn summary (quarterly_return_pct):\n")
print(summary(data$quarterly_return_pct))

# --- Average return by year ----------------------------------
data$year <- substr(data$date, 1, 4)

cat("\nAverage quarterly return by year:\n")
data %>%
  group_by(year) %>%
  summarise(
    mean_return = round(mean(quarterly_return_pct), 2),
    sd_return   = round(sd(quarterly_return_pct), 2),
    n           = n()
  ) %>%
  print()
