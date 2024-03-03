select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      





with validation_errors as (

    select
        product_id, transaction_date_month
    from analytics.ANALYTICS_USER_marts.ecommerce__actuals_vs_forecasts
    group by product_id, transaction_date_month
    having count(*) > 1

)

select *
from validation_errors



      
    ) dbt_internal_test