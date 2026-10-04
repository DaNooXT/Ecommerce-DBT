WITH 
cleaned AS
(   
    {% set columns = silver_column_types('sales') %}

    SELECT
        {{ cast_columns (columns) }}
    FROM 
        {{ ref("bronze_sales") }} AS source
    WHERE
        {{ cast_valid_predicate(columns) }}
)

SELECT * FROM cleaned