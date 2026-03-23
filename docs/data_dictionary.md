# Data Dictionary — Olist Brazilian E-Commerce Dataset

Source: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
License: CC BY-NC-SA 4.0

---

## Files Overview

| File | Rows (approx) | Key Use |
|------|---------------|---------|
| olist_orders_dataset.csv | 99,441 | Core order lifecycle |
| olist_order_items_dataset.csv | 112,650 | SKU-level detail |
| olist_products_dataset.csv | 32,951 | Product catalog |
| olist_sellers_dataset.csv | 3,095 | Seller master data |
| olist_customers_dataset.csv | 99,441 | Customer geography |
| olist_order_reviews_dataset.csv | 99,224 | Review scores |
| olist_order_payments_dataset.csv | 103,886 | Payment types + values |
| olist_geolocation_dataset.csv | 1,000,163 | Lat/long for zip codes |
| product_category_name_translation.csv | 71 | Portuguese → English |

---

## olist_orders_dataset.csv

| Column | Type | Description |
|--------|------|-------------|
| order_id | string | Unique order identifier |
| customer_id | string | Links to customers table |
| order_status | string | delivered / shipped / canceled / etc. |
| order_purchase_timestamp | datetime | When customer placed order |
| order_approved_at | datetime | When payment was approved |
| order_delivered_carrier_date | datetime | When seller handed to carrier |
| order_delivered_customer_date | datetime | Actual delivery date |
| order_estimated_delivery_date | datetime | Promised delivery date |

**Derived KPIs from this table:**
- `fulfillment_latency` = order_delivered_customer_date − order_purchase_timestamp
- `carrier_delay` = order_delivered_carrier_date − order_approved_at
- `on_time_flag` = 1 if delivered ≤ estimated, else 0
- `delivery_gap` = order_delivered_customer_date − order_estimated_delivery_date

---

## olist_order_items_dataset.csv

| Column | Type | Description |
|--------|------|-------------|
| order_id | string | Links to orders table |
| order_item_id | int | Line item number within order |
| product_id | string | Links to products table |
| seller_id | string | Links to sellers table |
| shipping_limit_date | datetime | Seller must ship by this date |
| price | float | Item price in BRL |
| freight_value | float | Shipping cost in BRL |

**Derived KPIs:**
- `seller_ship_delay` = shipping_limit_date − order_approved_at (negative = late)
- `total_order_value` = price + freight_value

---

## olist_products_dataset.csv

| Column | Type | Description |
|--------|------|-------------|
| product_id | string | Unique product ID |
| product_category_name | string | Category (Portuguese) |
| product_name_lenght | int | Length of product name |
| product_description_lenght | int | Description length |
| product_photos_qty | int | Number of product photos |
| product_weight_g | float | Weight in grams |
| product_length_cm | float | Length |
| product_height_cm | float | Height |
| product_width_cm | float | Width |

---

## olist_sellers_dataset.csv

| Column | Type | Description |
|--------|------|-------------|
| seller_id | string | Unique seller ID |
| seller_zip_code_prefix | string | Seller location zip |
| seller_city | string | Seller city |
| seller_state | string | Seller state (2-letter BR code) |

---

## olist_customers_dataset.csv

| Column | Type | Description |
|--------|------|-------------|
| customer_id | string | Links to orders table |
| customer_unique_id | string | Deduplicated customer ID |
| customer_zip_code_prefix | string | Customer zip |
| customer_city | string | Customer city |
| customer_state | string | Customer state |

---

## olist_order_reviews_dataset.csv

| Column | Type | Description |
|--------|------|-------------|
| review_id | string | Unique review ID |
| order_id | string | Links to orders table |
| review_score | int | 1–5 star rating |
| review_comment_title | string | Review headline |
| review_comment_message | string | Full review text |
| review_creation_date | datetime | When review was created |
| review_answer_timestamp | datetime | When seller replied |

---

## Key Relationships (Star Schema)

```
orders ──────────── order_items ──── products
   │                     │
   │                     └────────── sellers
   │
   ├── customers
   ├── reviews
   └── payments
```

---

## Supply Chain KPIs — Calculation Reference

| KPI | Formula | Target |
|-----|---------|--------|
| On-time delivery rate | delivered ≤ estimated / total delivered | > 90% |
| Avg fulfillment latency | mean(delivered − purchase) in days | < 10 days |
| p95 fulfillment latency | 95th percentile of above | < 20 days |
| Seller on-time ship rate | shipped ≤ limit_date / total items | > 95% |
| Stockout proxy | zero orders in 14-day window for active SKU | flag |
| Demand variance | std(weekly orders) / mean(weekly orders) | < 0.3 stable |
