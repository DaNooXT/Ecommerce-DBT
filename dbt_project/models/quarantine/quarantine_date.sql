{% set columns = silver_column_types('date') %}

{{ quarantine_cast_failures('bronze_date', columns) }}
