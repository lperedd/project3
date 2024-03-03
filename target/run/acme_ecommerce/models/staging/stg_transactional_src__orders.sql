
  create or replace   view analytics.ANALYTICS_USER_staging.stg_transactional_src__orders
  
   as (
    with
    source1 as (select * from acme_ecommerce.transactional.orders_2024_q3),
    source2 as (select * from acme_ecommerce.transactional.orders_2024_q3),
    merged as (select * from source1 union all select * from source2),
    final as (
        select
            transaction_date,
            DATE_TRUNC('MONTH', transaction_date)  as transaction_date_month,
            month(transaction_date) as transaction_month,
            quarter(transaction_date) as transaction_quarter,
            year(transaction_date) as transaction_year,
            shipping_date as shipped_date,
            month(shipping_date) as shipped_month,
            quarter(shipping_date) as shipped_quarter,
            year(shipping_date) as shipped_year,
            transaction_id,
            product_id,
            customer_id,
            quantity as order_quantity,
            transaction_price_usd
        from merged
    )

select *
from final
  );

