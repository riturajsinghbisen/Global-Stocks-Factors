
source("00_setup.R")
# ---- PLOT 1 : Average return over time (bar chart) ---------
avg_q <- df %>%
  group_by(date) %>%
  summarise(avg_ret  = mean(quarterly_return_pct),
            positive = mean(quarterly_return_pct) > 0)

p1 <- ggplot(avg_q, aes(x = date, y = avg_ret, fill = positive)) +
  geom_col(width = 70, alpha = 0.85) +
  annotate("rect",
           xmin = as.Date("2020-01-01"),
           xmax = as.Date("2020-07-01"),
           ymin = -Inf, ymax = Inf,
           alpha = 0.12, fill = "red") +
  annotate("text",
           x = as.Date("2020-04-01"), y = 7.5,
           label = "COVID Crash", color = "red",
           size = 3.5, fontface = "italic") +
  geom_hline(yintercept = 0, color = "black", linewidth = 0.6) +
  scale_fill_manual(values = c("TRUE"  = "#1f77b4",
                               "FALSE" = "#d62728"),
                    guide = "none") +
  labs(title    = "Average Quarterly Return Across All 100 Stocks (2019-2023)",
       subtitle = "Blue = positive quarters  |  Red = negative  |  Shaded = COVID crash",
       x = "Quarter", y = "Average Return (%)") +
  theme_minimal(base_size = 11) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(p1)

# ---- PLOT 2 : Return distribution histogram ----------------
mu_ret <- mean(df$quarterly_return_pct)
sd_ret <- sd(df$quarterly_return_pct)

p2 <- ggplot(df, aes(x = quarterly_return_pct)) +
  geom_histogram(aes(y = after_stat(density)),
                 bins = 50, fill = "#1f77b4",
                 alpha = 0.75, color = "white") +
  stat_function(fun  = dnorm,
                args = list(mean = mu_ret, sd = sd_ret),
                color = "red", linewidth = 1.3) +
  geom_vline(xintercept = mu_ret, color = "darkred",
             linetype = "dashed", linewidth = 1) +
  geom_vline(xintercept = 0, color = "black",
             linewidth = 0.5, alpha = 0.5) +
  annotate("text", x = mu_ret + 1.2, y = 0.068,
           label = paste0("Mean = ", round(mu_ret, 2), "%"),
           color = "darkred", size = 3.8) +
  labs(title    = "Distribution of All 2,000 Quarterly Returns",
       subtitle = paste0("Mean = ", round(mu_ret, 2),
                         "%  |  SD = ", round(sd_ret, 2),
                         "%  |  Slight negative skew"),
       x = "Quarterly Return (%)", y = "Density") +
  theme_minimal(base_size = 11)

print(p2)

# ---- PLOT 3 : Country box plots ----------------------------
p3 <- ggplot(df, aes(x    = reorder(country,
                                    quarterly_return_pct,
                                    FUN = median),
                     y    = quarterly_return_pct,
                     fill = country)) +
  geom_boxplot(alpha = 0.7, outlier.size = 0.9,
               outlier.alpha = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed",
             color = "gray40", linewidth = 0.8) +
  scale_fill_brewer(palette = "Set2", guide = "none") +
  labs(title    = "Return Distribution by Country",
       subtitle = "Sorted by median return  |  Dashed = zero",
       x = "Country", y = "Quarterly Return (%)") +
  theme_minimal(base_size = 11)

print(p3)

# ---- PLOT 4 : Country average returns (bar) ----------------
country_avg <- df %>%
  group_by(country) %>%
  summarise(mean_ret = mean(quarterly_return_pct),
            se       = sd(quarterly_return_pct) / sqrt(n()))

p4 <- ggplot(country_avg,
             aes(x    = reorder(country, mean_ret),
                 y    = mean_ret,
                 fill = mean_ret > overall_mean)) +
  geom_col(alpha = 0.85) +
  geom_errorbar(aes(ymin = mean_ret - se,
                    ymax = mean_ret + se), width = 0.3) +
  geom_hline(yintercept = overall_mean,
             linetype = "dashed", color = "red",
             linewidth = 1.2) +
  scale_fill_manual(values = c("TRUE"  = "#2ca02c",
                               "FALSE" = "#d62728"),
                    guide = "none") +
  labs(title    = "Average Quarterly Return by Country",
       subtitle = "Red dashed = overall mean (2.69%)",
       x = "Country", y = "Mean Return (%)") +
  theme_minimal(base_size = 11)

print(p4)

# ---- PLOT 5 : Sector returns (horizontal bar) --------------
sec_summary <- df %>%
  group_by(sector) %>%
  summarise(mean_ret = mean(quarterly_return_pct),
            se       = sd(quarterly_return_pct) / sqrt(n()))

p5 <- ggplot(sec_summary,
             aes(x    = reorder(sector, mean_ret),
                 y    = mean_ret,
                 fill = mean_ret > overall_mean)) +
  geom_col(alpha = 0.85) +
  geom_errorbar(aes(ymin = mean_ret - se,
                    ymax = mean_ret + se),
                width = 0.35, linewidth = 0.8) +
  geom_hline(yintercept = overall_mean,
             linetype = "dashed", color = "navy",
             linewidth = 1) +
  coord_flip() +
  scale_fill_manual(values = c("TRUE"  = "#2ca02c",
                               "FALSE" = "#d62728"),
                    guide = "none") +
  labs(title    = "Average Quarterly Return by Sector",
       subtitle = "Navy dashed = overall mean (2.69%)",
       x = NULL, y = "Mean Return (%)") +
  theme_minimal(base_size = 11)

print(p5)

cat("\nEDA plots done. 5 plots printed.\n")
