{% set columns = silver_column_types('store') %}

{{ quarantine_matches_failures('bronze_store', 'quarantine_store', columns) }}
