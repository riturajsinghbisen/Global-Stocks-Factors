source("00_setup.R")

cat("=== MULTIPLE REGRESSION MODEL ===\n\n")

# ---- Fit the model -----------------------------------------
model <- lm(quarterly_return_pct ~
              beta              +   # market factor
              log(market_cap_bn) +  # size factor (log scale)
              vix               +   # fear index
              world_gdp_growth  +   # global growth
              us_fed_rate       +   # central bank policy
              us_cpi            +   # inflation
              oil_price_usd     +   # commodity/activity proxy
              log(gold_price_usd) + # fear asset
              global_trade_vol  +   # trade activity
              geopolitical_risk,    # political uncertainty
            data = df)

# ---- Model fit summary -------------------------------------
cat("=== MODEL FIT ===\n")
cat(sprintf("R-squared          : %.4f  (explains %.1f%% of variance)\n",
            summary(model)$r.squared,
            summary(model)$r.squared * 100))
cat(sprintf("Adjusted R-squared : %.4f\n",
            summary(model)$adj.r.squared))
cat(sprintf("Residual Std Error : %.4f\n",
            summary(model)$sigma))
cat(sprintf("F-statistic        : %.2f  (p < 0.001)\n",
            summary(model)$fstatistic[1]))
cat(sprintf("Observations used  : %d\n\n", nrow(df)))

# ---- Full coefficient table --------------------------------
cat("=== ALL COEFFICIENTS ===\n")
coef_tbl <- as.data.frame(summary(model)$coefficients)
names(coef_tbl) <- c("Estimate", "Std_Error", "t_value", "p_value")
coef_tbl$significant <- ifelse(coef_tbl$p_value < 0.001, "***",
                        ifelse(coef_tbl$p_value < 0.01,  "** ",
                        ifelse(coef_tbl$p_value < 0.05,  "*  ", "   ")))
print(round(coef_tbl[, 1:4], 4))
cat("\nSignificance: *** p<0.001  ** p<0.01  * p<0.05\n")

# ---- Significant predictors only ---------------------------
cat("\n=== SIGNIFICANT PREDICTORS (p < 0.05) ===\n")
sig <- coef_tbl[coef_tbl$p_value < 0.05, ]
sig <- sig[order(abs(sig$t_value), decreasing = TRUE), ]
print(round(sig[, 1:4], 4))

# ---- Interpretation of top coefficients --------------------
cat("\n=== COEFFICIENT INTERPRETATION ===\n")
cat("VIX coefficient     :", round(coef(model)["vix"], 4),
    "--> 1-pt VIX rise =",
    round(coef(model)["vix"], 2), "% change in return\n")
cat("GDP coeff           :", round(coef(model)["world_gdp_growth"], 4),
    "--> 1% more GDP growth =",
    round(coef(model)["world_gdp_growth"], 2), "% higher return\n")
cat("Beta coeff          :", round(coef(model)["beta"], 4),
    "--> 1-unit beta rise =",
    round(coef(model)["beta"], 2), "% higher return\n")

# ---- Residual diagnostics (base R plots) -------------------
cat("\nBasic residual diagnostics (4-panel plot):\n")
par(mfrow = c(2, 2))
plot(model)
par(mfrow = c(1, 1))   # reset layout

# ---- Simple bar chart: coefficient sizes -------------------
coef_plot_df <- coef_tbl[-1, ]   # drop intercept
coef_plot_df$variable <- rownames(coef_plot_df)
coef_plot_df$significant_flag <- coef_plot_df$p_value < 0.05

# Clean variable names for plot

coef_plot_df$variable <- gsub("log\\(market_cap_bn\\)", "Log(Mkt Cap)",
                         gsub("log\\(gold_price_usd\\)", "Log(Gold)",
                         coef_plot_df$variable))

p_coef <- ggplot(coef_plot_df,
                 aes(x    = reorder(variable, Estimate),
                     y    = Estimate,
                     fill = Estimate > 0)) +
  geom_col(aes(alpha = significant_flag)) +
  geom_errorbar(aes(ymin = Estimate - 1.96 * Std_Error,
                    ymax = Estimate + 1.96 * Std_Error),
                width = 0.3) +
  geom_hline(yintercept = 0, color = "black", linewidth = 0.6) +
  coord_flip() +
  scale_fill_manual(values = c("TRUE"  = "#2ca02c",
                               "FALSE" = "#d62728"),
                    guide = "none") +
  scale_alpha_manual(values = c("TRUE" = 0.9, "FALSE" = 0.35),
                     guide = "none") +
  labs(title    = "Regression Coefficients with 95% Confidence Intervals",
       subtitle  = paste0("R\u00b2 = ", round(summary(model)$r.squared, 3),
                          "  |  Faded bars = not significant (p > 0.05)"),
       x = NULL,
       y = "Coefficient (effect on quarterly return %)") +
  theme_minimal(base_size = 11)

print(p_coef)
cat("\nRegression analysis done.\n")
