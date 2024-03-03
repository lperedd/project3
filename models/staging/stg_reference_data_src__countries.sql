with
    source as (select * from {{ source("reference_data", "countries") }}),
    final as (select ALPHA_2_COUNTRY_CODE as country_code, country, region from source where active_flag = true)

select *
from final
