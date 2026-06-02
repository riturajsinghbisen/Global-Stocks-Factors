
source("00_setup.R")
cat("=== FACTOR 1: MARKET (BETA) ===\n\n")

# ---- Group stocks into 5 beta ranges -----------------------
df$beta_grp <- cut(df$beta,
                   breaks = c(0, 0.8, 1.0, 1.2, 1.4, Inf),
                   labels = c("<0.8", "0.8-1.0", "1.0-1.2",
                              "1.2-1.4", ">1.4"),
                   right  = FALSE)

# ---- Summary by beta group ---------------------------------
beta_sum <- df %>%
  group_by(beta_grp) %>%
  summarise(
    mean_ret = mean(quarterly_return_pct),
    sd_ret   = sd(quarterly_return_pct),
    se       = sd(quarterly_return_pct) / sqrt(n()),
    n_obs    = n()
  )

cat("Return by beta group:\n")
print(beta_sum)

# ---- Market premium calculation ----------------------------
annual_mean    <- mean(df$quarterly_return_pct) * 4
riskfree_rate  <- 1.8   # approx annual risk-free rate (%)
market_premium <- annual_mean - riskfree_rate

cat(sprintf("\nAnnualised equity return : %.2f %%\n", annual_mean))
cat(sprintf("Approx risk-free rate   : %.2f %%\n", riskfree_rate))
cat(sprintf("Market premium          : %.2f %% per year\n", market_premium))

# ---- Simple regression: return ~ beta ----------------------
cat("\nSimple regression: return ~ beta\n")
beta_lm <- lm(quarterly_return_pct ~ beta, data = df)
print(summary(beta_lm)$coefficients)
cat("R-squared:", round(summary(beta_lm)$r.squared, 4), "\n")

# ---- Plot: beta group vs average return --------------------
p_beta <- ggplot(beta_sum,
                 aes(x = beta_grp, y = mean_ret, group = 1)) +
  geom_ribbon(aes(ymin = mean_ret - se,
                  ymax = mean_ret + se),
              fill = "#1f77b4", alpha = 0.2) +
  geom_line(color = "#1f77b4", linewidth = 2) +
  geom_point(size = 5, color = "#1f77b4") +
  labs(title    = "Market Factor: Beta Group vs. Average Quarterly Return",
       subtitle = paste0("Higher beta = higher return  |  Market premium = ",
                         round(market_premium, 1), "%/yr"),
       x = "Beta Group (Market Sensitivity)",
       y = "Mean Quarterly Return (%)") +
  theme_minimal(base_size = 11)

print(p_beta)

cat("\nMarket factor analysis done.\n")
