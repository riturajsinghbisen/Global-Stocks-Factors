# Why Do Some Stocks Do Better Than Others?
### A Beginner's Look at Global Stock Factors Using R

> Second-year project by **Rituraj Singh**  
> B.Tech CSE (Data Science), IIIT Una,Himachal Pradesh, India  
> Contact: 24519@iiitu.ac.in

---

## What This Project Is About

This project tries to answer a simple question: **why do some stocks earn more money than others, even when they seem equally risky?**

Researchers have found that a few simple patterns — called **"factors"** — can explain a lot of the difference. I tested five of these on a real dataset of 100 companies across 9 countries (Australia, Canada, China, France, Hong Kong, India, Japan, UK, USA), covering 20 quarters from 2019 to 2023.

---
## Key Findings

| Factor | What It Measures | Annual Return |
|--------|-----------------|---------------|
| MKT | Stocks vs savings account | +8.92% |
| WML (Momentum) | Recent winners vs losers | +2.64% ✅ Best |
| RMW (Profitability) | Profitable vs weak firms | +3.29%* |
| SMB (Size) | Small vs large companies | -1.14% ❌ |
| HML (Value) | Cheap vs expensive stocks | -6.51%* |

- 📈 **Momentum** had the best reward-to-risk ratio (Sharpe: 0.95)
- 😱 **VIX (fear index)** had the strongest negative link with returns (r = −0.53)
- 🌍 **World GDP growth** had the strongest positive link (r = +0.66)
- 💥 COVID Q2 2020: average return hit **−11%** in a single quarter
---
## How to Run

### 1. Clone the repository
```bash
git clone https://github.com/riturajsinghbisen/Global-Stocks-Factors-r.git
cd Global-Stocks-Factors-r
```

### 2. Install required R packages
Open R or RStudio and run:
```r
install.packages(c("dplyr", "tidyr", "ggplot2", "knitr"))
```
### 3. Run the full analysis
```r
run individual scripts (e.g. `01_load_data.R`) .
```
---
## Dataset Description

**File:** `https://github.com/riturajsinghbisen/Global-Stocks-Factors/blob/main/GlobalStockFactors.csv`  
**Rows:** 2,000 (100 stocks × 20 quarters)  
**Period:** Q1 2019 – Q4 2023

| Column | Description |
|--------|-------------|
| `date` | Quarter start date |
| `stock_ticker` | Stock identifier |
| `company_name` | Company name |
| `country` | Country of listing |
| `region` | Asia / Americas / Europe / Oceania |
| `sector` | Industry sector |
| `beta` | Market sensitivity (from CAPM) |
| `market_cap_bn` | Market value in USD billions |
| `quarterly_return_pct` | % return for the quarter |
| `vix` | Global fear index |
| `us_fed_rate` | US interest rate (annual %) |
| `world_gdp_growth` | World economic growth rate |
| `oil_price_usd` | Oil price per barrel |
| `gold_price_usd` | Gold price per ounce |

---
*This project was submitted to useR! 2026 as a student abstract.*
