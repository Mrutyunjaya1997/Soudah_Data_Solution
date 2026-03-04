{% macro norm_booking_status(expr) %}
    CASE
      WHEN {{ expr }} IS NULL THEN NULL
      WHEN UPPER(TRIM({{ expr }})) IN ('CONFIRMED','CNF','CONFIRM') THEN 'CONFIRMED'
      WHEN UPPER(TRIM({{ expr }})) IN ('CANCEL','CANCELLED','CANCELED') THEN 'CANCELLED'
      WHEN UPPER(TRIM({{ expr }})) IN ('HOLD','ONHOLD','ON HOLD') THEN 'HOLD'
      ELSE UPPER(TRIM({{ expr }}))
    END
{% endmacro %}

{% macro norm_payment_status(expr) %}
    CASE
      WHEN {{ expr }} IS NULL THEN NULL
      WHEN UPPER(TRIM({{ expr }})) IN ('SUCCESS','S','SUCCEEDED') THEN 'SUCCESS'
      WHEN UPPER(TRIM({{ expr }})) IN ('FAILED','FAIL','F') THEN 'FAILED'
      WHEN UPPER(TRIM({{ expr }})) IN ('PENDING','P') THEN 'PENDING'
      ELSE UPPER(TRIM({{ expr }}))
    END
{% endmacro %}

{% macro norm_housekeeping_status(expr) %}
    CASE
      WHEN {{ expr }} IS NULL THEN NULL
      WHEN UPPER(TRIM({{ expr }})) IN ('DONE','COMPLETE','COMPLETED') THEN 'DONE'
      WHEN UPPER(TRIM({{ expr }})) IN ('START','STARTED') THEN 'START'
      WHEN UPPER(TRIM({{ expr }})) IN ('ASSIGNED','ASSIGN') THEN 'ASSIGNED'
      WHEN UPPER(TRIM({{ expr }})) IN ('PAUSED','PAUSE') THEN 'PAUSED'
      ELSE UPPER(TRIM({{ expr }}))
    END
{% endmacro %}

{% macro norm_priority(expr) %}
    CASE
      WHEN {{ expr }} IS NULL THEN NULL
      WHEN UPPER(TRIM({{ expr }})) IN ('H','HIGH','P1','P0') THEN 'HIGH'
      WHEN UPPER(TRIM({{ expr }})) IN ('M','MEDIUM','P2') THEN 'MEDIUM'
      WHEN UPPER(TRIM({{ expr }})) IN ('L','LOW','P3') THEN 'LOW'
      ELSE UPPER(TRIM({{ expr }}))
    END
{% endmacro %}

{% macro norm_severity(expr) %}
    CASE
      WHEN {{ expr }} IS NULL THEN NULL
      WHEN UPPER(TRIM({{ expr }})) IN ('CRITICAL','CRIT','P0') THEN 'CRITICAL'
      WHEN UPPER(TRIM({{ expr }})) IN ('HIGH','P1') THEN 'HIGH'
      WHEN UPPER(TRIM({{ expr }})) IN ('MEDIUM','P2') THEN 'MEDIUM'
      WHEN UPPER(TRIM({{ expr }})) IN ('LOW','P3') THEN 'LOW'
      ELSE UPPER(TRIM({{ expr }}))
    END
{% endmacro %}

{% macro norm_ticket_status(expr) %}
    CASE
      WHEN {{ expr }} IS NULL THEN NULL
      WHEN UPPER(TRIM({{ expr }})) IN ('OPEN') THEN 'OPEN'
      WHEN UPPER(TRIM({{ expr }})) IN ('IN_PROGRESS','IN PROGRESS','INPROGRESS') THEN 'IN_PROGRESS'
      WHEN UPPER(TRIM({{ expr }})) IN ('CLOSED','CLOSE') THEN 'CLOSED'
      ELSE UPPER(TRIM({{ expr }}))
    END
{% endmacro %}