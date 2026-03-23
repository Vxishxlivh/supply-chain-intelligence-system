# Tableau Dashboard Build Guide
## Supply Chain Control Tower — Step-by-Step

---

## Data Sources to Connect

After running all 4 notebooks, connect these CSVs in Tableau:

| File | Used For |
|------|----------|
| `data/processed/master_orders.csv` | Main source |
| `data/processed/kpi_monthly_trends.csv` | Time series sheets |
| `data/processed/kpi_latency_by_state.csv` | Map views |
| `data/processed/kpi_seller_scorecard.csv` | Seller risk sheet |
| `data/processed/kpi_latency_by_category.csv` | Category breakdown |
| `data/processed/demand_forecast_90day.csv` | Forecast sheet |
| `data/processed/inventory_optimization.csv` | Reorder alerts |

**How to connect:** Tableau Desktop → Connect → Text File → select each CSV.
Use "Relationships" (not joins) to link by shared keys where needed.

---

## Dashboard Structure — 3 Tabs

### Tab 1: Executive Overview (the "homepage")
*What a VP sees first*

**Sheet 1 — KPI Summary Bar (top of dashboard)**
- 4 BANs (Big Ass Numbers) side by side:
  - Overall On-Time Rate: `AVG(on_time_pct)` → format as %
  - Median Fulfillment: `MEDIAN(fulfillment_days)` → format as "X days"
  - p95 Latency: `PERCENTILE(fulfillment_days, 0.95)` → format as "X days"
  - Avg Review Score: `AVG(review_score)` → format as X.X / 5.0
- Color code each: green if healthy, red if below threshold

**Sheet 2 — Monthly On-Time Rate Trend (line chart)**
- Data: `kpi_monthly_trends.csv`
- X-axis: `month` | Y-axis: `on_time_pct`
- Add reference line at 90% (target)
- Color: teal line, red dashed reference

**Sheet 3 — Monthly Order Volume (bar chart)**
- Data: `kpi_monthly_trends.csv`
- X-axis: `month` | Y-axis: `total_orders`
- Color bars by `on_time_pct` (diverging: red → green)

**Sheet 4 — Fulfillment Latency Over Time (dual-axis)**
- Data: `kpi_monthly_trends.csv`
- Bar chart: `avg_latency_days`
- Line overlay: `p95_latency`
- This shows "typical vs worst case" in one view

---

### Tab 2: Operational Deep-Dive
*Where analysts live*

**Sheet 5 — Geographic Map: On-Time Rate by State**
- Data: `kpi_ontime_by_state.csv`
- Drag `customer_state` to Detail → Tableau auto-geocodes Brazil states
- Color: `on_time_pct` using diverging palette (red = low, green = high)
- Tooltip: show state, on_time_pct, avg_latency, total_orders
- Add filter: State selector

**Sheet 6 — Category Performance Heatmap**
- Data: `kpi_latency_by_category.csv`
- Rows: `category_en` | Columns: (single column)
- Color: `p50_latency` (darker = worse)
- Size: `order_count`
- Sort by p50 descending

**Sheet 7 — Seller Risk Scatter Plot**
- Data: `kpi_seller_scorecard.csv`
- X: `on_time_rate` | Y: `avg_latency_days`
- Color: `risk_tier` (red = High Risk, green = Top Performer)
- Size: `total_revenue_brl`
- Add reference lines: x=0.90, y=10 (creating 4 quadrants)
- Tooltip: seller_id, state, total_orders, revenue

**Sheet 8 — Seller Risk Table**
- Data: `kpi_seller_scorecard.csv`
- Text table showing: seller_id, seller_state, total_orders, on_time_rate, avg_latency, risk_tier
- Conditional formatting: color `risk_tier` column
- Filter: by risk_tier (show only High Risk / At Risk by default)

---

### Tab 3: Forecasting & Inventory
*Forward-looking view*

**Sheet 9 — 90-Day Demand Forecast**
- Data: `demand_forecast_90day.csv` joined with historical from `kpi_monthly_trends`
- Line chart: historical orders (solid) + forecast (dashed)
- Add confidence band: shade between `forecast_lower` and `forecast_upper`
- Color: historical = steelblue, forecast = orange dashed

**Sheet 10 — Stockout Risk Alerts**
- Data: `inventory_optimization.csv`
- Filter to show `stockout_risk IN ('HIGH RISK', 'MONITOR')`
- Bar chart: `demand_change_pct` by `category_en`
- Color: HIGH RISK = red, MONITOR = orange, Stable = green
- Sort by `demand_change_pct` descending

**Sheet 11 — Reorder Point Reference Table**
- Data: `inventory_optimization.csv`
- Text table: category, avg_weekly_demand, safety_stock, reorder_point, stockout_risk
- Sort by stockout_risk (HIGH RISK first)

---

## Calculated Fields to Create in Tableau

```
// On-Time Rate %
[On-Time Rate] = AVG([on_time]) * 100

// Latency Health Flag
[Latency Flag] =
  IF [avg_latency_days] <= 8 THEN "Healthy"
  ELSEIF [avg_latency_days] <= 14 THEN "Caution"
  ELSE "Critical"
  END

// Revenue at Risk (for seller scorecard)
[Revenue at Risk] =
  IF [risk_tier] = "High Risk" THEN [total_revenue_brl]
  ELSE 0
  END

// Delivery Gap Label
[Delivery Timing] =
  IF [delivery_gap_days] <= -7 THEN "Early (7+ days)"
  ELSEIF [delivery_gap_days] <= 0 THEN "On Time"
  ELSEIF [delivery_gap_days] <= 7 THEN "1 Week Late"
  ELSE "2+ Weeks Late"
  END
```

---

## Dashboard Layout Tips (for Tableau Public)

1. Set dashboard size to **Fixed — 1200 x 800px** (works on most screens)
2. Use a **dark navy header** (#1a2744) with white text for the title bar
3. Use **floating containers** for the KPI BAN row at top
4. Add a **filter panel** on the right: State, Category, Date range, Risk tier
5. Add **tooltips** to every chart — make them informative, not just raw numbers

---

## Publishing to Tableau Public

1. Complete all sheets and dashboard layout
2. File → Save to Tableau Public
3. Sign in / create free account at public.tableau.com
4. Copy the public URL
5. Add to:
   - Your project `README.md` (replace "coming soon" placeholder)
   - Your LinkedIn profile (Featured section)
   - Your resume (under the project entry)

---

## Screenshot Guide (for GitHub)

Take these 4 screenshots for `dashboard/screenshots/`:
1. `overview_tab.png` — Tab 1 full view
2. `geographic_map.png` — Sheet 5 close-up
3. `seller_scatter.png` — Sheet 7 close-up
4. `forecast_view.png` — Tab 3 full view

These images will auto-display in your GitHub README if you add:
```markdown
![Dashboard Overview](dashboard/screenshots/overview_tab.png)
```
