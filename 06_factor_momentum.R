
source("00_setup.R")

cat("=== FACTOR 3: MOMENTUM ===\n\n")

# ---- Create 1-quarter lagged return using base R ave() -----
# Sort by company, then date -- essential for correct lagging
df_s <- df[order(df$stock_ticker, df$date), ]

df_s$lag_ret <- ave(
  df_s$quarterly_return_pct,
  df_s$stock_ticker,
  FUN = function(x) c(NA, head(x, -1))
)

# Drop the first quarter of each company (no lag available)
df_mom <- df_s[!is.na(df_s$lag_ret), ]
cat("Observations after creating 1-quarter lag:",
    nrow(df_mom), "\n")
cat("  (100 stocks x 20 quarters - 100 first quarters = 1900)\n\n")

# ---- Correlation test --------------------------------------
r_mom   <- cor(df_mom$quarterly_return_pct, df_mom$lag_ret)
t_test  <- cor.test(df_mom$quarterly_return_pct,
                    df_mom$lag_ret)

cat(sprintf("Momentum correlation : r = %.4f\n", r_mom))
cat(sprintf("t-statistic          : %.3f\n", t_test$statistic))
cat(sprintf("p-value              : %s\n",
            format(t_test$p.value, scientific = TRUE)))
cat(sprintf("95%% CI              : [%.4f, %.4f]\n",
            t_test$conf.int[1], t_test$conf.int[2]))

# ---- Linear regression -------------------------------------
cat("\nMomentum linear regression: current_return ~ lag_return\n")
mom_lm <- lm(quarterly_return_pct ~ lag_ret, data = df_mom)
print(summary(mom_lm)$coefficients)
cat("R-squared:", round(summary(mom_lm)$r.squared, 4), "\n")

# ---- Annualised premium estimate ---------------------------
iqr_ret       <- IQR(df$quarterly_return_pct)
mom_coef      <- coef(mom_lm)["lag_ret"]
mom_prem_q    <- mom_coef * iqr_ret
mom_prem_yr   <- mom_prem_q * 4

cat(sprintf("\nIQR of quarterly return    : %.3f %%\n", iqr_ret))
cat(sprintf("Momentum coefficient       : %.4f\n", mom_coef))
cat(sprintf("Premium per quarter        : %.3f %%\n", mom_prem_q))
cat(sprintf("Estimated annual premium   : %.2f %%\n", mom_prem_yr))

# ---- Plot --------------------------------------------------
p_mom <- ggplot(df_mom,
                aes(x = lag_ret, y = quarterly_return_pct)) +
  geom_point(alpha = 0.25, size = 1.3, color = "#9467bd") +
  geom_smooth(method = "lm", color = "darkorange",
              linewidth = 2, se = FALSE) +
  geom_hline(yintercept = 0, linetype = "dashed",
             color = "gray50", linewidth = 0.7) +
  geom_vline(xintercept = 0, linetype = "dashed",
             color = "gray50", linewidth = 0.7) +
  annotate("text", x = 15, y = -20,
           label = paste0("r = ", round(r_mom, 3),
                          "\np < 0.001\nn = ", nrow(df_mom)),
           size = 3.8, hjust = 0,
           color = "gray20") +
  labs(title    = "Momentum Factor: Prior Quarter Return vs. Current Return",
       subtitle = paste0("Positive slope confirms momentum  |  ",
                         "Annual premium ~ ", round(mom_prem_yr, 1), "%"),
       x = "Previous Quarter Return (%)",
       y = "Current Quarter Return (%)") +
  theme_minimal(base_size = 11)

print(p_mom)

cat("\nMomentum factor analysis done.\n")
