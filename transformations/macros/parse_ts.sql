{% macro parse_ts(expr) %}
    COALESCE(
        TRY_TO_TIMESTAMP_NTZ(TRIM({{ expr }})),                         -- many formats
        TRY_TO_TIMESTAMP_NTZ(TRIM({{ expr }}), 'YYYY-MM-DD HH24:MI:SS'),
        TRY_TO_TIMESTAMP_NTZ(TRIM({{ expr }}), 'YYYY/MM/DD HH24:MI'),
        TRY_TO_TIMESTAMP_NTZ(TRIM({{ expr }}), 'DD-MM-YYYY HH12:MI AM'),
        TRY_TO_TIMESTAMP_NTZ(TRIM({{ expr }}), 'YYYY-MM-DD\"T\"HH24:MI:SS\"Z\"')
    )
{% endmacro %}