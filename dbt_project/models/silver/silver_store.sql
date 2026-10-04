WITH 
cleaned AS
(   
    {% set columns = silver_column_types('store') %}

    SELECT
        {{ cast_columns (columns) }}
    FROM 
        {{ ref("bronze_store") }} AS source
    WHERE
        {{ cast_valid_predicate(columns) }}
)

SELECT * FROM cleaned
