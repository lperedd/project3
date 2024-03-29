
  
    

        create or replace transient table analytics.ANALYTICS_USER_marts.s
         as
        (with orders as (
    select
        transaction_date,
        transaction_month,
        transaction_quarter,
        transaction_year,
        shipped_date,
        shipped_month,
        shipped_quarter,
        shipped_year,
        customer_id,
        product_id,
        sum(order_quantity) as order_quantity,
        sum(transaction_price_usd) as transaction_price_usd
    from analytics.ANALYTICS_USER_staging.stg_transactional_src__orders
    group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
),
products as (
    select
        product_id,
        product_name,
        product_category
    from analytics.ANALYTICS_USER_staging.stg_reference_data_src__products
),
customers as (
    select distinct
        customer_id,
        customer_name,
        country_code,
        customer_email_address
    from analytics.ANALYTICS_USER_staging.stg_reference_data_src__customers
   where customer_email_address <> 'NOT_A_VALID_EMAIL@example.com'
   
),
countries as (
    select distinct
        country_code, country, region 
    from analytics.ANALYTICS_USER_staging.stg_reference_data_src__countries
   
),
merged as (
    select customers.*,
    orders.* exclude(customer_id),
    products.* exclude(product_id),
    countries.* exclude (country_code)
    from customers left join orders using (customer_id)
    left join products using (product_id) left join countries using (country_code)
),
final as(
    select * from merged
    where product_id IS NOT NULL
)
select * from final
        );
      
  