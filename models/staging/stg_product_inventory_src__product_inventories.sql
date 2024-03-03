with
    source as (select * from {{ source("product_inventory", "inventory") }}),
    final as (
        select
            prod_id as product_id,
            to_variant(to_date(stock_arrival_date, 'MM/DD/YY'))::date
            as stock_arrival_date,
            to_variant(to_date(stock_depleted_date, 'MM/DD/YY'))::date
            as stock_depleted_date,
            purchase_price

        from source
    )

select *
from final
