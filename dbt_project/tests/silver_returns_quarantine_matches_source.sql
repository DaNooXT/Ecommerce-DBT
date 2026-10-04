{% set columns = silver_column_types('returns') %}

{{ quarantine_matches_failures('bronze_returns', 'quarantine_returns', columns) }}
