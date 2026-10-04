{% set columns = silver_column_types('sales') %}

{{ quarantine_cast_failures('bronze_sales', columns) }}
