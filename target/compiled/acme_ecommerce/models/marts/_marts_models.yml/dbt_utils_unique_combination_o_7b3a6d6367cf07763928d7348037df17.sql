





with validation_errors as (

    select
        product_id, transaction_date_month
    from acme_ecommerce.reference_data_marts.ecommerce__actuals_vs_forecasts
    group by product_id, transaction_date_month
    having count(*) > 1

)

select *
from validation_errors


