{% set columns = silver_column_types('store') %}

{{ quarantine_cast_failures('bronze_store', columns) }}
