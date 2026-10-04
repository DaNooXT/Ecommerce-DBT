{% set columns = silver_column_types('customer') %}

{{ quarantine_cast_failures('bronze_customer', columns) }}
