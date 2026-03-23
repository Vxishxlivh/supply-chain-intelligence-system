# Supply Chain Intelligence System
### End-to-End Analytics | Brazilian E-Commerce (Olist) Dataset

![Python](https://img.shields.io/badge/Python-3.10-blue?logo=python)
![Tableau](https://img.shields.io/badge/Tableau-Public-orange?logo=tableau)
![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue?logo=postgresql)
![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)

---

## What This Project Does

Most supply chain dashboards tell you *what happened*. This system tells you *what's about to go wrong and why*.

Built on 100,000+ real Brazilian e-commerce orders, this project simulates a Supply Chain Control Tower — the kind operations teams at Sephora, Amazon, and Target use to monitor fulfillment health in real time.

**Live Dashboard →** *(Tableau Public link — coming soon)*

---

## Business Questions Answered

| # | Question | Tool |
|---|----------|------|
| 1 | Which product categories have the worst on-time delivery rates? | Tableau + SQL |
| 2 | Where are fulfillment delays concentrated — by region or seller? | Tableau |
| 3 | Which sellers are chronically late — and what's the cost? | SQL |
| 4 | What does demand look like 30/60/90 days out? | Python (Prophet) |
| 5 | Which SKUs are at stockout risk next week? | Python + SQL |
| 6 | How does review score correlate with delivery speed? | Python (EDA) |

---

## Key Findings

> *(Updated as analysis completes)*

- **Delivery delay hotspot:** São Paulo orders ship fastest; Northern Brazil averages 3.2x longer delivery windows
- **Top stockout risk categories:** Health & Beauty and Sports show highest demand variance
- **Seller performance:** Top 10% of sellers account for 60%+ of on-time deliveries
- **Forecast accuracy:** Prophet model achieves MAPE of ~12% on 30-day demand window

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
│   ├── 01_eda_and_cleaning.ipynb       ← Data exploration + cleaning
│   ├── 02_kpi_calculations.ipynb       ← KPI engineering
│   ├── 03_demand_forecasting.ipynb     ← Prophet + XGBoost models
│   └── 04_inventory_optimization.ipynb ← Reorder point + safety stock
│
├── sql/
│   ├── 01_delivery_performance.sql
│   ├── 02_seller_scorecard.sql
│   ├── 03_stockout_risk.sql
│   ├── 04_fulfillment_latency_p95.sql
│   └── 05_reorder_alerts.sql
│
├── dashboard/
│   ├── screenshots/       ← Dashboard preview images
│   └── tableau_guide.md   ← How the dashboard is built
│
├── reports/
│   ├── business_findings.md    ← Executive summary
│   └── methodology.md          ← Technical approach
│
└── docs/
    └── data_dictionary.md      ← All columns explained
```

---

## Tools & Skills Demonstrated

| Category | Tools |
|----------|-------|
| Data wrangling | Python, Pandas, NumPy |
| Visualization | Matplotlib, Seaborn, Plotly |
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

**Step 4 — Open the dashboard**
```
Tableau Public link: [coming soon]
Or open dashboard/screenshots/ for previews
```

---

## About

Built as a portfolio project to demonstrate end-to-end supply chain analytics skills for Supply Chain Analyst and Operations Analyst roles.

**Skills targeted:** Demand planning · Inventory optimization · KPI design · Data storytelling · Forecasting

---

*Dataset credit: Olist Brazilian E-Commerce — available on Kaggle under CC BY-NC-SA 4.0*
