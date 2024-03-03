with
    orders as (
        select

            transaction_date_month,
            transaction_month,
            transaction_quarter,
            transaction_year,
            product_id,
            sum(order_quantity) as order_quantity,
            sum(transaction_price_usd) as actual_sales,
            sum(transaction_price_usd) / sum(order_quantity) as sell_price_per_unit
        from  acme_ecommerce.reference_data_staging.stg_transactional_src__orders
        group by 1, 2, 3, 4, 5
    ),
    products as (
        select product_id, product_name, product_category
        from acme_ecommerce.reference_data_staging.stg_reference_data_src__products
    ),
    inventory as (
        select distinct product_id, avg(purchase_price) as net_cost_per_unit
        from
           acme_ecommerce.reference_data_staging.stg_product_inventory_src__product_inventories
        group by 1

    ),
    forecasts as (
        select forecast_date_month, product_id, forecast_sales, forecast_profit
        from  acme_ecommerce.reference_data_staging.stg_transactional_src__forecasts

    ),
    merged as (
        select
            orders.*,
            products.* exclude(product_id),
            inventory.* exclude(product_id),
            forecasts.* exclude(forecast_date_month, product_id)

        from orders
        left join products using (product_id)
        left join inventory using (product_id)
        left join
            forecasts
            on orders.transaction_date_month = forecasts.forecast_date_month

            and orders.product_id = forecasts.product_id

    ),
    actual_profit as (
        select
            *,
            (actual_sales) - ((net_cost_per_unit) * (order_quantity)) as actual_profit

        from merged
    ),
    final as (
        select
            *,
            lag(actual_profit) over (
                partition by transaction_date_month, product_id
                order by transaction_date_month asc
            ) as actual_profit_last_month,
            lag(forecast_profit) over (
                partition by transaction_date_month, product_id
                order by transaction_date_month asc
            ) as forecast_profit_last_month,
            lag(actual_sales) over (
                partition by transaction_date_month, product_id
                order by transaction_date_month asc
            ) as actual_sales_last_month,

            lag(forecast_sales) over (
                partition by transaction_date_month, product_id
                order by transaction_date_month asc
            ) as forecast_sales_last_month

        from actual_profit

    )
select *
from final