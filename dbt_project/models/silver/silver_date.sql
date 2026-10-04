WITH 
cleaned AS
(   
    {% set columns = silver_column_types('date') %}

    SELECT
        {{ cast_columns (columns) }}
    FROM 
        {{ ref("bronze_date") }} AS source
    WHERE
        {{ cast_valid_predicate(columns) }}
)

SELECT * FROM cleaned
