source("00_setup.R")

# ---- Numerical variables to include ------------------------
num_vars <- c("quarterly_return_pct", "beta", "market_cap_bn",
              "vix", "us_fed_rate", "us_cpi",
              "world_gdp_growth", "oil_price_usd",
              "gold_price_usd", "global_trade_vol",
              "geopolitical_risk", "em_currency_idx")

# ---- Compute full correlation matrix -----------------------
corr_mat <- cor(df[, num_vars])

# ---- Print correlations with quarterly return (sorted) -----
ret_cors <- sort(corr_mat["quarterly_return_pct", ])
cat("=== CORRELATIONS WITH QUARTERLY RETURN (sorted low to high) ===\n")
print(round(ret_cors, 3))

# R-squared for top two predictors
cat("\nVIX alone explains        :", 
    round(ret_cors["vix"]^2 * 100, 1), "% of return variance\n")
cat("GDP growth alone explains :", 
    round(ret_cors["world_gdp_growth"]^2 * 100, 1), "% of return variance\n")

# as.table() -> as.data.frame() converts the matrix to long format
corr_long       <- as.data.frame(as.table(corr_mat))
names(corr_long) <- c("Var1", "Var2", "Correlation")

# Short axis labels
short_labels <- c(
  quarterly_return_pct = "Return",
  beta                 = "Beta",
  market_cap_bn        = "Mkt Cap",
  vix                  = "VIX",
  us_fed_rate          = "Fed Rate",
  us_cpi               = "CPI",
  world_gdp_growth     = "GDP Growth",
  oil_price_usd        = "Oil Price",
  gold_price_usd       = "Gold Price",
  global_trade_vol     = "Trade Vol",
  geopolitical_risk    = "Geo Risk",
  em_currency_idx      = "EM FX"
)

corr_long$Var1 <- short_labels[as.character(corr_long$Var1)]
corr_long$Var2 <- short_labels[as.character(corr_long$Var2)]

# Keep consistent factor ordering
label_order           <- unname(short_labels)
corr_long$Var1        <- factor(corr_long$Var1, levels = label_order)
corr_long$Var2        <- factor(corr_long$Var2, levels = label_order)

# ---- Correlation heatmap -----------------------------------
p_corr <- ggplot(corr_long,
                 aes(x = Var1, y = Var2, fill = Correlation)) +
  geom_tile(color = "white", linewidth = 0.4) +
  geom_text(aes(label = round(Correlation, 2)),
            size = 2.7, color = "black") +
  scale_fill_gradient2(low     = "#d62728",
                       mid     = "white",
                       high    = "#1f77b4",
                       midpoint = 0,
                       limits  = c(-1, 1),
                       name    = "r") +
  labs(title    = "Correlation Matrix of All Numerical Variables",
       subtitle  = "Blue = positive  |  Red = negative  |  Darker = stronger",
       x = NULL, y = NULL) +
  theme_minimal(base_size = 9) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(p_corr)

cat("\nCorrelation analysis done.\n")
