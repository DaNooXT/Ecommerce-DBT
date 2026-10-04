{% set columns = silver_column_types('date') %}

{{ quarantine_matches_failures('bronze_date', 'quarantine_date', columns) }}
