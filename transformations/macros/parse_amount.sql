{% macro parse_amount(expr) %}
    TRY_TO_NUMBER(
        NULLIF(
            REGEXP_REPLACE(
                UPPER(TRIM({{ expr }})),
                '(VAT:|SAR|SR|S\\.A\\.R|S A R|,|\\s)',
                ''
            ),
            ''
        ),
        38, 2
    )
{% endmacro %}