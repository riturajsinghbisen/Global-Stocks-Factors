source("00_setup.R")

# ============================================================
# PART A: VIX (Fear Index)
# ============================================================

cat("=== VIX ANALYSIS ===\n\n")

r_vix  <- cor(df$vix, df$quarterly_return_pct)
r2_vix <- r_vix^2

cat(sprintf("VIX correlation r     : %.4f\n", r_vix))
cat(sprintf("R-squared             : %.4f\n", r2_vix))
cat(sprintf("VIX alone explains    : %.1f %% of return variance\n",
            r2_vix * 100))

# Simple regression
vix_lm <- lm(quarterly_return_pct ~ vix, data = df)
cat("\nVIX simple regression:\n")
print(summary(vix_lm)$coefficients)

# What does a VIX of 40 mean for expected return?
vix40_pred <- coef(vix_lm)[1] + coef(vix_lm)[2] * 40
cat(sprintf("\nPredicted return when VIX = 40 : %.2f %%\n", vix40_pred))

# VIX scatter plot
p_vix <- ggplot(df, aes(x = vix, y = quarterly_return_pct)) +
  geom_point(aes(color = quarterly_return_pct),
             alpha = 0.4, size = 1.5) +
  geom_smooth(method = "lm", color = "navy",
              linewidth = 2, se = TRUE,
              fill = "navy", alpha = 0.1) +
  geom_vline(xintercept = 40, linetype = "dotted",
             color = "red", linewidth = 1.2) +
  scale_color_gradient2(low      = "#d62728",
                        mid      = "gray85",
                        high     = "#2ca02c",
                        midpoint = 0,
                        guide    = "none") +
  annotate("text", x = 41.5, y = 19,
           label = "VIX = 40\nExtreme Fear",
           color = "red", size = 3.5, hjust = 0) +
  labs(title    = "VIX (Fear Index) vs. Quarterly Return",
       subtitle = paste0("r = ", round(r_vix, 3),
                         "  |  VIX alone explains ",
                         round(r2_vix * 100, 1),
                         "% of variance"),
       x = "VIX",
       y = "Quarterly Return (%)") +
  theme_minimal(base_size = 11)

print(p_vix)

# ============================================================
# PART B: GDP Growth
# ============================================================

cat("\n=== GDP GROWTH ANALYSIS ===\n\n")

r_gdp <- cor(df$world_gdp_growth, df$quarterly_return_pct)
cat(sprintf("GDP growth correlation : %.4f\n", r_gdp))
cat(sprintf("Variance explained     : %.1f %%\n", r_gdp^2 * 100))

# Year-by-year summary
yearly <- df %>%
  group_by(year) %>%
  summarise(avg_ret = mean(quarterly_return_pct),
            avg_gdp = mean(world_gdp_growth))

cat("\nYear-by-year returns and GDP:\n")
print(yearly)

# Scale factor for dual axis (no tidyr needed)
s <- max(abs(yearly$avg_ret)) / max(abs(yearly$avg_gdp))

p_gdp <- ggplot(yearly, aes(x = year)) +
  geom_line(aes(y = avg_ret, color = "Stock Return"),
            linewidth = 2.2) +
  geom_point(aes(y = avg_ret, color = "Stock Return"), size = 4) +
  geom_line(aes(y = avg_gdp * s, color = "GDP Growth"),
            linewidth = 2.2, linetype = "dashed") +
  geom_point(aes(y = avg_gdp * s, color = "GDP Growth"), size = 4) +
  scale_color_manual(
    values = c("Stock Return" = "#1f77b4",
               "GDP Growth"   = "#d62728")) +
  scale_y_continuous(
    name     = "Avg Quarterly Return (%)",
    sec.axis = sec_axis(~./s, name = "World GDP Growth (%)")) +
  scale_x_continuous(breaks = 2019:2023) +
  labs(title = "Stock Returns vs. World GDP Growth by Year",
       subtitle = paste0("GDP correlation r = ", round(r_gdp, 3)),
       color = "", x = "Year") +
  theme_minimal(base_size = 11) +
  theme(legend.position = "top")

print(p_gdp)

# ============================================================
# PART C: Oil Price
# ============================================================

cat("\n=== OIL PRICE ANALYSIS ===\n\n")

r_oil <- cor(df$oil_price_usd, df$quarterly_return_pct)
cat(sprintf("Oil price correlation : %.4f\n", r_oil))

df$oil_bin <- cut(
  df$oil_price_usd,
  breaks         = quantile(df$oil_price_usd, probs = seq(0, 1, 0.2)),
  include.lowest = TRUE,
  labels         = c("Very Low\n(<$40)", "Low\n($40-56)",
                     "Mid\n($56-70)", "High\n($70-85)",
                     "Very High\n(>$85)")
)

oil_sum <- df %>%
  group_by(oil_bin) %>%
  summarise(mean_ret = mean(quarterly_return_pct),
            se       = sd(quarterly_return_pct) / sqrt(n()))

cat("\nReturn by oil price bin:\n")
print(oil_sum)

p_oil <- ggplot(oil_sum,
                aes(x = oil_bin, y = mean_ret,
                    fill = mean_ret > overall_mean)) +
  geom_col(alpha = 0.85) +
  geom_errorbar(aes(ymin = mean_ret - se,
                    ymax = mean_ret + se),
                width = 0.3) +
  geom_hline(yintercept = overall_mean,
             linetype = "dashed", color = "navy",
             linewidth = 1) +
  scale_fill_manual(values = c("TRUE"  = "#2ca02c",
                               "FALSE" = "#d62728"),
                    guide = "none") +
  labs(title    = "Oil Price Quintile vs. Average Stock Return",
       subtitle  = paste0("Oil correlation r = ", round(r_oil, 3),
                          "  |  Low oil = COVID collapse"),
       x = "Oil Price Range (USD/barrel)",
       y = "Mean Quarterly Return (%)") +
  theme_minimal(base_size = 11)

print(p_oil)

cat("\nMacro analysis (VIX, GDP, Oil) done.\n")
