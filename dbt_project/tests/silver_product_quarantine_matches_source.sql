{% set columns = silver_column_types('product') %}

{{ quarantine_matches_failures('bronze_product', 'quarantine_product', columns) }}
