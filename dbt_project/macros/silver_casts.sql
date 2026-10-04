{% macro silver_column_types(entity) %}
    {% if entity == 'sales' %}
        {% do return({
            'sales_id': 'BIGINT',
            'date_sk': 'BIGINT',
            'store_sk': 'BIGINT',
            'product_sk': 'BIGINT',
            'customer_sk': 'BIGINT',
            'promotion_sk': 'BIGINT',
            'quantity': 'BIGINT',
            'unit_price': 'DECIMAL (10,2)',
            'gross_amount': 'DECIMAL (10,2)',
            'discount_amount': 'DECIMAL (10,2)',
            'net_amount': 'DECIMAL (10,2)',
            'payment_method': 'STRING'
        }) %}
    {% elif entity == 'returns' %}
        {% do return({
            'sales_id': 'BIGINT',
            'date_sk': 'BIGINT',
            'store_sk': 'BIGINT',
            'product_sk': 'BIGINT',
            'returned_qty': 'BIGINT',
            'return_reason': 'STRING',
            'refund_amount': 'DECIMAL (10,2)'
        }) %}
    {% elif entity == 'product' %}
        {% do return({
            'product_sk': 'BIGINT',
            'product_code': 'STRING',
            'product_name': 'STRING',
            'department': 'STRING',
            'category': 'STRING',
            'supplier_sk': 'BIGINT',
            'list_price': 'DECIMAL (10,2)',
            'uom': 'STRING'
        }) %}
    {% elif entity == 'date' %}
        {% do return({
            'date_sk': 'BIGINT',
            'date': 'DATE',
            'day': 'BIGINT',
            'month': 'BIGINT',
            'month_name': 'STRING',
            'quarter': 'BIGINT',
            'year': 'BIGINT',
            'day_of_week': 'BIGINT',
            'day_name': 'STRING',
            'is_weekend': 'BOOLEAN',
            'is_month_end': 'BOOLEAN',
            'is_month_start': 'BOOLEAN',
            'is_quarter_end': 'BOOLEAN',
            'is_quarter_start': 'BOOLEAN'
        }) %}
    {% elif entity == 'customer' %}
        {% do return({
            'customer_sk': 'BIGINT',
            'customer_code': 'STRING',
            'first_name': 'STRING',
            'last_name': 'STRING',
            'gender': 'STRING',
            'email': 'STRING',
            'phone': 'STRING',
            'loyalty_tier': 'STRING',
            'signup_date': 'DATE'
        }) %}
    {% elif entity == 'store' %}
        {% do return({
            'store_sk': 'BIGINT',
            'store_code': 'STRING',
            'store_name': 'STRING',
            'city': 'STRING',
            'state_province': 'STRING',
            'region': 'STRING',
            'country': 'STRING',
            'open_date': 'DATE',
            'sq_ft': 'BIGINT'
        }) %}
    {% else %}
        {% do exceptions.raise_compiler_error("Unknown silver entity: " ~ entity) %}
    {% endif %}
{% endmacro %}

{% macro cast_valid_predicate(columns, source_alias='source') %}
    {% for column, data_type in columns.items() %}
        (
            {{ source_alias }}.{{ column }} IS NULL
            OR TRY_CAST({{ source_alias }}.{{ column }} AS {{ data_type }}) IS NOT NULL
        )
        {% if not loop.last %}AND{% endif %}
    {% endfor %}
{% endmacro %}

{% macro quarantine_cast_failures(source_model, columns) %}
    {% for column, data_type in columns.items() %}
        SELECT
            source.*,
            '{{ column }}' AS _quarantine_column,
            CAST(source.{{ column }} AS STRING) AS _source_value
        FROM {{ ref(source_model) }} AS source
        WHERE source.{{ column }} IS NOT NULL
          AND TRY_CAST(source.{{ column }} AS {{ data_type }}) IS NULL
        {% if not loop.last %}UNION ALL{% endif %}
    {% endfor %}
{% endmacro %}

{% macro quarantine_matches_failures(source_model, quarantine_model, columns) %}
    WITH expected AS (
        {{ quarantine_cast_failures(source_model, columns) }}
    ),
    actual AS (
        SELECT * FROM {{ ref(quarantine_model) }}
    )
    SELECT * FROM (
        SELECT * FROM expected
        EXCEPT
        SELECT * FROM actual
    ) AS missing_quarantine_rows
    UNION ALL
    SELECT * FROM (
        SELECT * FROM actual
        EXCEPT
        SELECT * FROM expected
    ) AS unexpected_quarantine_rows
{% endmacro %}