source("00_setup.R")

cat("=== FACTOR 2: SIZE (SMB) ===\n\n")

# ---- Divide into 4 market cap quartiles --------------------
df$size_q <- ntile(df$market_cap_bn, 4)

df$size_lbl <- factor(
  ifelse(df$size_q == 1, "Small",
  ifelse(df$size_q == 2, "Mid-Small",
  ifelse(df$size_q == 3, "Mid-Large", "Large"))),
  levels = c("Small", "Mid-Small", "Mid-Large", "Large")
)

# ---- Summary by size group ---------------------------------
size_sum <- df %>%
  group_by(size_lbl) %>%
  summarise(
    avg_mktcap = round(mean(market_cap_bn), 1),
    mean_ret   = mean(quarterly_return_pct),
    sd_ret     = sd(quarterly_return_pct),
    se         = sd(quarterly_return_pct) / sqrt(n()),
    n_obs      = n()
  )

cat("Return by size group:\n")
print(size_sum)

# ---- SMB premium -------------------------------------------
small_ret <- size_sum$mean_ret[size_sum$size_lbl == "Small"]
large_ret <- size_sum$mean_ret[size_sum$size_lbl == "Large"]
smb_q     <- small_ret - large_ret

cat(sprintf("\nSmall mean return : %.3f %%/quarter\n", small_ret))
cat(sprintf("Large mean return : %.3f %%/quarter\n", large_ret))
cat(sprintf("SMB (quarterly)   : %.3f %%  --> %s\n",
            smb_q,
            ifelse(smb_q > 0,
                   "Small wins (classic Fama-French result)",
                   "Large wins (REVERSED -- unexpected)")))
cat(sprintf("SMB (annualised)  : %.2f %% per year\n", smb_q * 4))

# ---- Plot --------------------------------------------------
p_size <- ggplot(size_sum,
                 aes(x = size_lbl, y = mean_ret, fill = size_lbl)) +
  geom_col(alpha = 0.85) +
  geom_errorbar(aes(ymin = mean_ret - se,
                    ymax = mean_ret + se),
                width = 0.3) +
  geom_hline(yintercept = overall_mean,
             linetype = "dashed", color = "red",
             linewidth = 1.2) +
  annotate("text", x = 0.7, y = overall_mean + 0.15,
           label = "Overall mean", color = "red",
           size = 3.5, hjust = 0) +
  scale_fill_brewer(palette = "Blues", guide = "none") +
  labs(title    = "Size Factor (SMB): Market Cap Quartile vs. Return",
       subtitle = paste0("SMB = ", round(smb_q * 4, 2),
                         "%/yr  |  ",
                         ifelse(smb_q > 0,
                                "Classic: small beats large",
                                "Reversed: large beats small in this sample")),
       x = "Market Cap Group",
       y = "Mean Quarterly Return (%)") +
  theme_minimal(base_size = 11)

print(p_size)

cat("\nSize factor analysis done.\n")
