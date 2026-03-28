# Methodology — Supply Chain Intelligence System

## Data Source
Olist Brazilian E-Commerce dataset (Kaggle, CC BY-NC-SA 4.0)
110,141 order-item rows | 96,427 unique orders | Sept 2016 – Oct 2018

## Data Cleaning
- Filtered to delivered orders only (96,427 orders, 97.0%)
- Removed latency outliers: <0 days or >120 days (0.4% of data)
- Translated product categories Portuguese → English
- Parsed all datetime columns and derived fulfillment metrics
- Merged 7 source tables into one master table (110,141 rows × 28 columns)

## KPI Definitions
| KPI | Formula |
|-----|---------|
| Fulfillment latency | delivered_date − purchase_date (days) |
| On-time flag | 1 if delivered ≤ estimated, else 0 |
| Delivery gap | delivered_date − estimated_date (days) |
| p95 latency | 95th percentile of fulfillment latency |
| On-time rate | mean(on_time_flag) × 100 |

## Seller Scoring
- Only sellers with 10+ orders included (1,237 sellers scored)
- Risk tiers: High Risk (<65% on-time) | At Risk (<80%) | Acceptable (<92%) | Top Performer (92%+)

## Demand Forecasting
- Aggregated to weekly order counts across full platform
- Train/test split: last 8 weeks as holdout
- Prophet: yearly + weekly seasonality, changepoint_prior_scale=0.05
- XGBoost: lag features (1, 2, 4 weeks) + rolling 4-week average
- Evaluation metric: MAPE (Mean Absolute Percentage Error)
- Winner: XGBoost with MAPE of 24.8% on 8-week holdout

## Inventory Optimization
- Safety stock: Z × √(lead_time × σ²_demand + μ²_demand × σ²_lead)
- Service level: 95% (Z = 1.645)
- Assumed avg lead time: 7 days, std = 3 days
- Reorder point = (avg_daily_demand × lead_time) + safety_stock
- Stockout risk flagged when recent 4-week demand > historical mean + 1.5σ

## Key Findings
- Overall on-time delivery rate: 92.1%
- Median fulfillment latency: 10 days
- 4 HIGH RISK stockout categories: Food (+273%), Construction Tools (+144%),
  Pet Shop (+135%), Furniture Living Room (+105%)
- 30 categories on MONITOR status
- 1,237 sellers scored; risk distribution across 4 tiers
