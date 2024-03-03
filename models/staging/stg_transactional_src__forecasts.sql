with
    source as (select * from {{ source("reference_data", "forecasts") }}),
    final as (
        select
            date_part(month, to_date(month, 'MM-YY')) as forecast_month,
            date_part(year, to_date(month, 'MM-YY')) as forecast_year,
            cast(TO_CHAR(TO_DATE(month, 'MM-YY'), 'YYYY-MM-DD') as date) AS forecast_date_month,
            product as product_id,
            forecast_sales,
            forecast_profit
        from source
    )

select *
from final
