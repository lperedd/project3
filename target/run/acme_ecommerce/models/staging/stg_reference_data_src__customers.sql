
  create or replace   view acme_ecommerce.reference_data_staging.stg_reference_data_src__customers
  
   as (
    with
    source as (select * from acme_ecommerce.reference_data.customers),
    final as (
        select
            customer_code as customer_id ,
            first_name as customer_first_name  ,
            last_name as customer_last_name,
            concat(first_name, ' ', last_name) as customer_name,
            case
                when
                    regexp_like(
                        email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
                    )
                then email
                else 'NOT_A_VALID_EMAIL@example.com'  --all invalid email formats renamed to this one
            end as customer_email_address,
            country_id as country_code

        from source
    )

select *
from final
  );

