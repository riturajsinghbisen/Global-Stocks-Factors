
library(ggplot2)  
library(dplyr)    
df <- read.csv("C:/4thsemester/dav/endsemproject/GlobalStockFactors.csv",
               stringsAsFactors = FALSE)
df$date <- as.Date(df$date)

#Derived columns
df$year     <- as.integer(format(df$date, "%Y"))
df$quarter <- as.integer(as.numeric(format(df$date, "%m")) %/% 3 + 1)
df$positive <- df$quarterly_return_pct > 0

# Overall mean (used as reference line in many plots)
overall_mean <- mean(df$quarterly_return_pct)

#checks
cat("=== DATASET LOADED ===\n")
cat("Rows         :", nrow(df), "\n")
cat("Columns      :", ncol(df), "\n")
cat("Companies    :", length(unique(df$stock_ticker)), "\n")
cat("Countries    :", length(unique(df$country)), "\n")
cat("Quarters     :", length(unique(df$date)), "\n")
cat("Missing vals :", sum(is.na(df)), "\n")
cat("Overall mean return:", round(overall_mean, 3), "%/quarter\n")
cat("Annualised mean    :", round(overall_mean * 4, 2), "%/year\n\n")
