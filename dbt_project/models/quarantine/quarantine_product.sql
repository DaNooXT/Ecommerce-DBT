{% set columns = silver_column_types('product') %}

{{ quarantine_cast_failures('bronze_product', columns) }}
