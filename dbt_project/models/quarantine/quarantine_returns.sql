{% set columns = silver_column_types('returns') %}

{{ quarantine_cast_failures('bronze_returns', columns) }}
