# ============================================================
#  02_market_factor.R
#  Calculate the Market Factor (MKT)
#
#  Idea: Stocks should earn more than a savings account.
#        MKT = average stock return - risk-free rate (Fed rate)
# ============================================================

library(dplyr)

data <- read.csv("C:/4thsemester/dav/global-stock-factors-r/repo/data/GlobalStockFactors.csv")


# --- Step 1: Compute excess return for each stock ------------
# Fed rate is annual, divide by 4 to make it quarterly
data <- data %>%
  mutate(excess_return = quarterly_return_pct - (us_fed_rate / 4))

# --- Step 2: Average excess return per quarter ---------------
mkt_factor <- data %>%
  group_by(date) %>%
  summarise(MKT = mean(excess_return))

# --- Step 3: Summary stats -----------------------------------
mkt_quarterly <- mean(mkt_factor$MKT)
mkt_annual    <- mkt_quarterly * 4
mkt_sd_annual <- sd(mkt_factor$MKT) * sqrt(4)
mkt_sharpe    <- mkt_annual / mkt_sd_annual

cat("=== Market Factor (MKT) ===\n")
cat("Average quarterly excess return:", round(mkt_quarterly, 2), "%\n")
cat("Annualised return:              ", round(mkt_annual, 2), "%\n")
cat("Annualised std deviation:       ", round(mkt_sd_annual, 2), "%\n")
cat("Sharpe ratio:                   ", round(mkt_sharpe, 2), "\n")

