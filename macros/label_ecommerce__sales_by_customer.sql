{% macro label_ecommerce__sales_by_customer(column_name) %}
    CASE
  WHEN {{column_name}} BETWEEN 0 AND 1000 THEN '$0-1000'
  WHEN {{column_name}} BETWEEN 1001 AND 5000 THEN '$1001-5000'
  WHEN {{column_name}} > 5000 THEN '$5000+'
  ELSE 'NOT LABELED'
END

{% endmacro %}