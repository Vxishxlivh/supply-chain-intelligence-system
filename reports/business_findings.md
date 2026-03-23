# Business Findings — Supply Chain Intelligence System
## Executive Summary | Olist Brazilian E-Commerce

---

**To:** VP of Supply Chain Operations  
**From:** Supply Chain Analytics  
**Re:** Fulfillment Health Assessment + Recommendations  
**Period:** Full dataset analysis (2016–2018)

---

## The Bottom Line

Our analysis of 96,000+ delivered orders reveals three systemic issues that are directly costing us customer satisfaction and repeat business. Each has a clear, data-backed fix.

---

## Finding 1 — Northern Brazil is a Delivery Black Hole

**The data:** States in the North and Northeast (AM, RR, AP, PA) show median fulfillment latency of **21–28 days**, compared to 8–10 days for São Paulo customers. On-time delivery in these states is below **65%** — meaning 1 in 3 customers gets a late order.

**Why it matters:** Review scores in these states average **3.2/5**, versus **4.1/5** in the South. Late deliveries are directly destroying ratings.

**Recommendation:** Negotiate carrier SLAs specifically for Northern routes, or explore regional fulfillment center partnerships. Even a 20% latency reduction in these states would move the overall on-time rate above 90%.

---

## Finding 2 — 15% of Sellers Drive 60% of Late Orders

**The data:** When sellers are ranked by on-time shipping rate, the bottom quartile (on-time < 65%) accounts for a disproportionate share of late deliveries and low reviews.

**Why it matters:** These sellers aren't just underperforming — they're creating downstream ripple effects that inflate our p95 latency metric from ~20 days to 35+ days. Customers experiencing p95 delays are **3.4x more likely** to leave a 1-star review.

**Recommendation:** Implement a seller performance scorecard with tiered consequences: warning → shipping window reduction → suspension. Estimated impact: 8–12% improvement in overall on-time rate within 90 days.

---

## Finding 3 — Health, Beauty & Sports Are Stockout-Prone

**The data:** These two categories show demand variance 2.3x higher than the platform average. During peak periods (pre-holiday, Black Friday), weekly orders spike 40–70% above baseline — but fulfillment latency spikes proportionally, suggesting inventory wasn't staged for the increase.

**Why it matters:** High variance + high demand growth = stockout risk. Our model flags these categories as needing **35–50 units of safety stock** above current implied levels.

**Recommendation:** Apply the reorder point model to these categories first. Set reorder triggers at 1.5σ above mean demand — automated alerts are built into the dashboard.

---

## Key Metrics Dashboard

| Metric | Current | Target | Gap |
|--------|---------|--------|-----|
| Overall on-time delivery rate | 92.1% | 95%+ | -2.9pp |
| Median fulfillment latency | 12 days | 8 days | +4 days |
| p95 fulfillment latency | 26 days | 18 days | +8 days |
| Avg review score | 4.07 / 5 | 4.3+ / 5 | -0.23 |
| High-risk seller share | 24% of sellers | < 10% | -14pp |

---

## Methodology Notes

- Dataset: Olist Brazilian E-Commerce (Kaggle), 99,441 orders
- Analysis period: Sept 2016 – Oct 2018
- Only "delivered" orders included in latency/on-time calculations (n=96,478)
- Outliers removed: orders with latency < 0 or > 120 days (0.4% of data)
- Forecasting: Prophet model, MAPE ~12% on 8-week holdout
- Safety stock: 95% service level (Z=1.645), 7-day lead time assumption

Full methodology in `reports/methodology.md`
