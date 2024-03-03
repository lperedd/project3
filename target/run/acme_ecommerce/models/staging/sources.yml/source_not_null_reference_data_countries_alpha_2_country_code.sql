select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select alpha_2_country_code
from acme_ecommerce.reference_data.countries
where alpha_2_country_code is null



      
    ) dbt_internal_test