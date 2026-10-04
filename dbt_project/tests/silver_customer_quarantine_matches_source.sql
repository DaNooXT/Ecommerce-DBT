{% set columns = silver_column_types('customer') %}

{{ quarantine_matches_failures('bronze_customer', 'quarantine_customer', columns) }}
