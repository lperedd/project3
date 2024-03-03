
    
    

select
    alpha_2_country_code as unique_field,
    count(*) as n_records

from acme_ecommerce.reference_data.countries
where alpha_2_country_code is not null
group by alpha_2_country_code
having count(*) > 1


