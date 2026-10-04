WITH 
cleaned AS
(   
    {% set columns = silver_column_types('product') %}

    SELECT
        {{ cast_columns (columns) }}
    FROM 
        {{ ref("bronze_product") }} AS source
    WHERE
        {{ cast_valid_predicate(columns) }}
)

SELECT * FROM cleaned
