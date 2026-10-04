{% macro cast_columns(columns) %}

    {% for column, data_type in columns.items() %}

        TRY_CAST({{ column }} AS {{ data_type }}) AS {{ column }}

        {% if not loop.last %},{% endif %}

    {% endfor %}

{% endmacro %}