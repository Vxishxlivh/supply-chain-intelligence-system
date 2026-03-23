-- ============================================================
-- Supply Chain Intelligence System — SQL Analytics Layer
-- Dataset: Olist Brazilian E-Commerce
-- These queries are written in standard SQL / PostgreSQL syntax
-- Run against the master_orders table or processed CSVs loaded into DB
-- ============================================================


-- ============================================================
-- QUERY 01: Delivery Performance by State
-- Business Question: Which customer states have the worst
--   on-time delivery rates and highest fulfillment latency?
-- Decision: Prioritize logistics investment in underperforming regions
-- ============================================================

WITH state_performance AS (
    SELECT
        customer_state,
        COUNT(DISTINCT order_id)                          AS total_orders,
        ROUND(AVG(fulfillment_days), 1)                   AS avg_latency_days,
        PERCENTILE_CONT(0.5)
            WITHIN GROUP (ORDER BY fulfillment_days)      AS p50_latency,
        PERCENTILE_CONT(0.95)
            WITHIN GROUP (ORDER BY fulfillment_days)      AS p95_latency,
        ROUND(AVG(on_time::FLOAT) * 100, 1)              AS on_time_pct,
        ROUND(AVG(review_score), 2)                       AS avg_review_score
    FROM master_orders
    WHERE fulfillment_days IS NOT NULL
    GROUP BY customer_state
)
SELECT
    customer_state,
    total_orders,
    avg_latency_days,
    p50_latency,
    p95_latency,
    on_time_pct,
    avg_review_score,
    CASE
        WHEN on_time_pct < 70 THEN 'CRITICAL'
        WHEN on_time_pct < 80 THEN 'AT RISK'
        WHEN on_time_pct < 90 THEN 'ACCEPTABLE'
        ELSE 'HEALTHY'
    END AS performance_tier
FROM state_performance
ORDER BY on_time_pct ASC;


-- ============================================================
-- QUERY 02: Seller Scorecard + Risk Ranking
-- Business Question: Which sellers are chronically late
--   and what is the revenue at risk?
-- Decision: Flag high-risk sellers for review or replacement
-- ============================================================

WITH seller_metrics AS (
    SELECT
        seller_id,
        seller_state,
        COUNT(DISTINCT order_id)                          AS total_orders,
        ROUND(AVG(on_time::FLOAT) * 100, 1)              AS on_time_pct,
        ROUND(AVG(fulfillment_days), 1)                   AS avg_latency_days,
        PERCENTILE_CONT(0.95)
            WITHIN GROUP (ORDER BY fulfillment_days)      AS p95_latency,
        ROUND(AVG(review_score), 2)                       AS avg_review_score,
        ROUND(SUM(payment_value), 0)                      AS total_revenue_brl
    FROM master_orders
    WHERE fulfillment_days IS NOT NULL
    GROUP BY seller_id, seller_state
    HAVING COUNT(DISTINCT order_id) >= 10  -- Minimum volume threshold
),
ranked AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY on_time_pct DESC)        AS performance_quartile,
        RANK() OVER (ORDER BY on_time_pct ASC)           AS risk_rank
    FROM seller_metrics
)
SELECT
    seller_id,
    seller_state,
    total_orders,
    on_time_pct,
    avg_latency_days,
    p95_latency,
    avg_review_score,
    total_revenue_brl,
    risk_rank,
    CASE performance_quartile
        WHEN 1 THEN 'Top Performer'
        WHEN 2 THEN 'Acceptable'
        WHEN 3 THEN 'At Risk'
        WHEN 4 THEN 'High Risk'
    END AS risk_tier
FROM ranked
ORDER BY on_time_pct ASC
LIMIT 50;


-- ============================================================
-- QUERY 03: Stockout Risk by Product Category
-- Business Question: Which categories are showing demand spikes
--   that could indicate inventory shortage?
-- Decision: Increase safety stock or trigger early reorder
-- ============================================================

WITH weekly_demand AS (
    SELECT
        category_en,
        DATE_TRUNC('week', order_purchase_timestamp)     AS week_start,
        COUNT(DISTINCT order_id)                          AS weekly_orders
    FROM master_orders
    GROUP BY category_en, DATE_TRUNC('week', order_purchase_timestamp)
),
demand_stats AS (
    SELECT
        category_en,
        AVG(weekly_orders)                               AS avg_weekly_demand,
        STDDEV(weekly_orders)                            AS std_weekly_demand,
        COUNT(*)                                         AS weeks_observed
    FROM weekly_demand
    GROUP BY category_en
    HAVING COUNT(*) >= 20
),
recent_demand AS (
    SELECT
        category_en,
        AVG(weekly_orders)                               AS recent_avg_demand
    FROM weekly_demand
    WHERE week_start >= CURRENT_DATE - INTERVAL '4 weeks'
    GROUP BY category_en
)
SELECT
    d.category_en,
    ROUND(d.avg_weekly_demand, 0)                        AS avg_weekly_demand,
    ROUND(d.std_weekly_demand, 0)                        AS std_weekly_demand,
    ROUND(r.recent_avg_demand, 0)                        AS recent_4wk_demand,
    ROUND(
        (r.recent_avg_demand - d.avg_weekly_demand)
        / NULLIF(d.avg_weekly_demand, 0) * 100, 1
    )                                                    AS demand_change_pct,
    CASE
        WHEN r.recent_avg_demand > d.avg_weekly_demand + (1.5 * d.std_weekly_demand)
            THEN 'HIGH RISK — Reorder Now'
        WHEN r.recent_avg_demand > d.avg_weekly_demand + d.std_weekly_demand
            THEN 'MONITOR — Demand Spiking'
        WHEN r.recent_avg_demand < d.avg_weekly_demand - d.std_weekly_demand
            THEN 'Slow Moving'
        ELSE 'Stable'
    END AS stockout_risk_flag
FROM demand_stats d
JOIN recent_demand r ON d.category_en = r.category_en
ORDER BY demand_change_pct DESC;


-- ============================================================
-- QUERY 04: Fulfillment Latency P95 — Monthly Trend
-- Business Question: Is our worst-case delivery experience
--   getting better or worse over time?
-- Decision: Track SLA improvement / degradation month over month
-- ============================================================

WITH monthly_latency AS (
    SELECT
        DATE_TRUNC('month', order_purchase_timestamp)   AS order_month,
        COUNT(DISTINCT order_id)                         AS total_orders,
        ROUND(AVG(fulfillment_days), 1)                  AS avg_latency,
        PERCENTILE_CONT(0.50)
            WITHIN GROUP (ORDER BY fulfillment_days)     AS p50_latency,
        PERCENTILE_CONT(0.95)
            WITHIN GROUP (ORDER BY fulfillment_days)     AS p95_latency,
        ROUND(AVG(on_time::FLOAT) * 100, 1)             AS on_time_pct,
        ROUND(AVG(review_score), 2)                      AS avg_review
    FROM master_orders
    WHERE fulfillment_days IS NOT NULL
    GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
)
SELECT
    TO_CHAR(order_month, 'YYYY-MM')                     AS month,
    total_orders,
    avg_latency,
    p50_latency,
    p95_latency,
    on_time_pct,
    avg_review,
    ROUND(p95_latency - LAG(p95_latency)
        OVER (ORDER BY order_month), 1)                  AS p95_change_vs_prior_month,
    ROUND(on_time_pct - LAG(on_time_pct)
        OVER (ORDER BY order_month), 1)                  AS otr_change_vs_prior_month
FROM monthly_latency
ORDER BY order_month;


-- ============================================================
-- QUERY 05: Automated Reorder Alerts
-- Business Question: Which product categories need to be
--   reordered based on current demand pace vs. reorder point?
-- Decision: Trigger procurement action for flagged categories
-- ============================================================

WITH demand_baseline AS (
    SELECT
        category_en,
        AVG(weekly_orders)                               AS avg_weekly_demand,
        STDDEV(weekly_orders)                            AS std_weekly_demand
    FROM (
        SELECT
            category_en,
            DATE_TRUNC('week', order_purchase_timestamp) AS week_start,
            COUNT(DISTINCT order_id)                      AS weekly_orders
        FROM master_orders
        GROUP BY category_en, DATE_TRUNC('week', order_purchase_timestamp)
    ) weekly
    GROUP BY category_en
),
reorder_calc AS (
    SELECT
        category_en,
        ROUND(avg_weekly_demand, 0)                      AS avg_weekly_demand,
        ROUND(avg_weekly_demand / 7.0, 1)                AS avg_daily_demand,
        -- Safety stock at 95% service level (Z=1.645), 7-day lead time, 3-day std
        ROUND(
            1.645 * SQRT(7 * POWER(std_weekly_demand/7, 2) +
                         POWER(avg_weekly_demand/7, 2) * POWER(3, 2))
        , 0)                                             AS safety_stock_units,
        -- Reorder point
        ROUND(
            (avg_weekly_demand / 7.0 * 7) +
            1.645 * SQRT(7 * POWER(std_weekly_demand/7, 2) +
                         POWER(avg_weekly_demand/7, 2) * POWER(3, 2))
        , 0)                                             AS reorder_point
    FROM demand_baseline
    WHERE avg_weekly_demand >= 5
),
recent_pace AS (
    SELECT
        category_en,
        ROUND(AVG(daily_orders), 1)                      AS current_daily_pace
    FROM (
        SELECT
            category_en,
            DATE(order_purchase_timestamp)               AS order_date,
            COUNT(DISTINCT order_id)                     AS daily_orders
        FROM master_orders
        WHERE order_purchase_timestamp >= CURRENT_DATE - INTERVAL '14 days'
        GROUP BY category_en, DATE(order_purchase_timestamp)
    ) daily
    GROUP BY category_en
)
SELECT
    r.category_en,
    r.avg_daily_demand,
    r.safety_stock_units,
    r.reorder_point,
    COALESCE(p.current_daily_pace, 0)                    AS current_daily_pace,
    ROUND(r.reorder_point / NULLIF(COALESCE(p.current_daily_pace, 0.1), 0), 0)
                                                         AS days_until_reorder,
    CASE
        WHEN COALESCE(p.current_daily_pace, 0) > r.avg_daily_demand * 1.3
            THEN 'REORDER NOW — Demand spike detected'
        WHEN COALESCE(p.current_daily_pace, 0) > r.avg_daily_demand * 1.1
            THEN 'REORDER SOON — Above trend'
        ELSE 'OK — Within normal range'
    END AS reorder_alert
FROM reorder_calc r
LEFT JOIN recent_pace p ON r.category_en = p.category_en
ORDER BY days_until_reorder ASC NULLS LAST;
