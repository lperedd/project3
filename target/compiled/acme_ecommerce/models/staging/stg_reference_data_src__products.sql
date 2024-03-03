with
    source as (select * from acme_ecommerce.reference_data.products),
    final as (
        select prod_id as product_id, prod_name as product_name, prod_cat as product_category from source
    )

select *
from final