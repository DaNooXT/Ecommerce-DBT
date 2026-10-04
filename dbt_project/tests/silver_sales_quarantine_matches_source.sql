{% set columns = silver_column_types('sales') %}

{{ quarantine_matches_failures('bronze_sales', 'quarantine_sales', columns) }}
