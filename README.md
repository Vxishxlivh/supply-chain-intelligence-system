# Supply Chain Intelligence System
### End-to-End Analytics | Brazilian E-Commerce (Olist) Dataset

![Python](https://img.shields.io/badge/Python-3.10-blue?logo=python)
![Tableau](https://img.shields.io/badge/Tableau-Public-orange?logo=tableau)
![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue?logo=postgresql)
![Status](https://img.shields.io/badge/Status-Complete-green)

---

## Live Dashboard
**[Click to View — Supply Chain Control Tower](https://public.tableau.com/app/profile/vaishali.hireraddi/viz/Supply-Chain-Intelligence-System/MonthlyOTR)**

---

## What This Project Does

Most supply chain dashboards tell you *what happened*. This system tells you *what's about to go wrong and why*.

Built on 100,000+ real Brazilian e-commerce orders, this project simulates a Supply Chain Control Tower — the kind operations teams at Sephora, Amazon, and Target use to monitor fulfillment health in real time.

---

## Business Questions Answered

| # | Question | Tool |
|---|----------|------|
| 1 | Which product categories have the worst on-time delivery rates? | Tableau + SQL |
| 2 | Where are fulfillment delays concentrated — by region or seller? | Tableau |
| 3 | Which sellers are chronically late — and what's the cost? | SQL |
| 4 | What does demand look like 30/60/90 days out? | Python (Prophet + XGBoost) |
| 5 | Which SKUs are at stockout risk next week? | Python + SQL |
| 6 | How does review score correlate with delivery speed? | Python (EDA) |

---

## Key Findings

- **Overall on-time delivery rate:** 92.1%
- **Median fulfillment latency:** 10 days
- **Delivery delay hotspot:** Northern Brazil averages 3.2x longer delivery windows
- **Top stockout risk categories:** Food (+273%), Pet Shop (+135%), Construction Tools (+144%)
- **Seller performance:** 4 HIGH RISK categories flagged for immediate reorder
- **Forecast accuracy:** XGBoost model achieves MAPE of 24.8% on 8-week holdout

---

## Project Architecture
```
supply-chain-intelligence-system/
│
├── data/
│   ├── raw/               ← Olist CSVs (download instructions below)
│   └── processed/         ← Cleaned + merged outputs from notebooks
│
├── notebooks/
│   ├── 01_eda_and_cleaning.ipynb
│   ├── 02_kpi_calculations.ipynb
│   ├── 03_demand_forecasting.ipynb
│   └── 04_inventory_optimization.ipynb
│
├── sql/
│   └── supply_chain_queries.sql
│
├── dashboard/
│   └── screenshots/
│
├── reports/
│   ├── business_findings.md
│   ├── methodology.md
│   └── eda_overview.png
│
└── docs/
    └── data_dictionary.md
```

---

## Tools & Skills Demonstrated

| Category | Tools |
|----------|-------|
| Data wrangling | Python, Pandas, NumPy |
| Visualization | Matplotlib, Seaborn, Tableau |
| Forecasting | Prophet, XGBoost, Scikit-learn |
| SQL analytics | PostgreSQL-style queries, window functions, CTEs |
| Dashboard | Tableau Public |
| Supply chain concepts | Fulfillment KPIs, safety stock, reorder point, EOQ, demand planning |

---

## How to Run This Project

**Step 1 — Download the dataset**
```
1. Go to: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
2. Download all CSVs
3. Place them in: data/raw/
```

**Step 2 — Install dependencies**
```bash
pip install -r requirements.txt
```

**Step 3 — Run notebooks in order**
```bash
jupyter notebook
# Run: 01 → 02 → 03 → 04
```

**Step 4 — View the dashboard**
[Click here to view live dashboard](https://public.tableau.com/app/profile/vaishali.hireraddi/viz/Supply-Chain-Intelligence-System/MonthlyOTR)

---

## About

Built as a portfolio project to demonstrate end-to-end supply chain analytics skills for Supply Chain Analyst and Operations Analyst roles.

**Skills targeted:** Demand planning · Inventory optimization · KPI design · Data storytelling · Forecasting

---

*Dataset credit: Olist Brazilian E-Commerce — available on Kaggle under CC BY-NC-SA 4.0*
