select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select customer_id
from acme_ecommerce.reference_data_marts.ecommerce__sales_by_customer
where customer_id is null



      
    ) dbt_internal_test