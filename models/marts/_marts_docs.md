<!-- README.md -->

# E-commerce Analytics dbt Project

## Overview

This dbt project focuses on transforming and modeling e-commerce data to provide valuable insights into user behavior and order patterns. It includes two primary models, `my_first_model` and `my_second_model`, along with comprehensive tests and documentation.

## Models

### 1. `my_first_model`

This model aggregates order counts per user from the raw `orders` table, providing a foundational dataset for further analysis.

```sql
-- models/my_first_model.sql

SELECT
    user_id,
    COUNT(DISTINCT order_id) AS order_count
FROM
    raw.orders
GROUP BY
    user_id;
