#  Summary statistics and basic data inspection
#1. Structure of the dataset
cat("=== DATASET STRUCTURE ===\n")
str(df)

#2. Target variable summary
cat("\n=== quarterly_return_pct ===\n")
print(summary(df$quarterly_return_pct))

# Distributionmetrics
mu  <- mean(df$quarterly_return_pct)
s   <- sd(df$quarterly_return_pct)
skw <- mean(((df$quarterly_return_pct - mu) / s)^3)
krt <- mean(((df$quarterly_return_pct - mu) / s)^4) - 3

cat(sprintf("Mean      : %6.3f %%\n", mu))
cat(sprintf("Std Dev   : %6.3f %%\n", s))
cat(sprintf("Skewness  : %6.3f   (negative = left tail heavier)\n", skw))
cat(sprintf("Kurtosis  : %6.3f   (positive = fatter tails than normal)\n", krt))

#3. Key variable summary table
cat("\n=== SUMMARY TABLE FOR KEY VARIABLES ===\n")
key_vars <- c("quarterly_return_pct", "beta", "market_cap_bn",
              "vix", "world_gdp_growth", "oil_price_usd",
              "us_fed_rate", "gold_price_usd")

for (v in key_vars) {
  x <- df[[v]]
  cat(sprintf("%-25s  Min=%8.2f  Q1=%8.2f  Med=%8.2f  Mean=%8.2f  Q3=%8.2f  Max=%8.2f\n",
              v, min(x), quantile(x, 0.25), median(x),
              mean(x), quantile(x, 0.75), max(x)))
}

#4. Year-by-year returns
cat("\n=== YEAR-BY-YEAR RETURN SUMMARY ===\n")
yearly <- df %>%
  group_by(year) %>%
  summarise(
    mean_ret = round(mean(quarterly_return_pct), 2),
    sd_ret   = round(sd(quarterly_return_pct), 2),
    min_ret  = round(min(quarterly_return_pct), 2),
    max_ret  = round(max(quarterly_return_pct), 2)
  )
print(yearly)

#5. Country-level table
cat("\n=== COUNTRY-LEVEL AVERAGES ===\n")
country_tbl <- df %>%
  group_by(country) %>%
  summarise(
    companies = n_distinct(stock_ticker),
    mean_ret  = round(mean(quarterly_return_pct), 3),
    sd_ret    = round(sd(quarterly_return_pct), 3)
  ) %>%
  arrange(desc(mean_ret))
print(country_tbl)

#6. Sector-level table
cat("\n=== SECTOR-LEVEL AVERAGES ===\n")
sector_tbl <- df %>%
  group_by(sector) %>%
  summarise(
    n_obs    = n(),
    mean_ret = round(mean(quarterly_return_pct), 3),
    sd_ret   = round(sd(quarterly_return_pct), 3),
    sharpe   = round(mean(quarterly_return_pct) /
                     sd(quarterly_return_pct), 3)
  ) %>%
  arrange(desc(mean_ret))
print(sector_tbl)
