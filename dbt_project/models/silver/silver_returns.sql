WITH 
cleaned AS
(   
    {% set columns = silver_column_types('returns') %}

    SELECT
        {{ cast_columns (columns) }}
    FROM 
        {{ ref("bronze_returns") }} AS source
    WHERE
        {{ cast_valid_predicate(columns) }}
)

SELECT * FROM cleaned
