WITH 
cleaned AS
(   
    {% set columns = silver_column_types('customer') %}

    SELECT
        {{ cast_columns (columns) }}
    FROM 
        {{ ref("bronze_customer") }} AS source
    WHERE
        {{ cast_valid_predicate(columns) }}
)

SELECT * FROM cleaned
