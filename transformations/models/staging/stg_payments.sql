{{ config(materialized='view', schema='SILVER') }}

with src as (
  select * from {{ source('bronze', 'PAYMENTS_RAW') }}
),

clean as (
  select
    nullif(trim(payment_id), '') as payment_id,
    nullif(trim(booking_id), '') as booking_id,

    {{ parse_ts('paid_at_raw') }} as paid_at_ts,

    upper(nullif(trim(payment_method), '')) as payment_method,
    {{ norm_payment_status('payment_status') }} as payment_status,

    {{ parse_amount('amount_raw') }} as amount,
    -- fee can be percent or amount
    case
      when fee_raw is null then null
      when regexp_like(trim(fee_raw), '^[0-9]+(\\.[0-9]+)?%$') then
        try_to_number(replace(trim(fee_raw), '%','')) / 100
      else null
    end as fee_pct,

    case
      when fee_raw is null then null
      when regexp_like(trim(fee_raw), '^[0-9]+(\\.[0-9]+)?%$') then null
      else {{ parse_amount('fee_raw') }}
    end as fee_amount,

    {{ parse_amount('refund_amount_raw') }} as refund_amount,

    nullif(trim(gateway_ref), '') as gateway_ref,
    nullif(trim(notes), '') as notes,

    nullif(trim(source_file), '') as source_file,
    {{ parse_ts('ingested_at') }} as ingested_at_ts,
    load_ts
  from src
  where upper(trim(payment_id)) not in ('', 'NULL', 'NA') and payment_id is not null
),

dedup as (
  select *
  from clean
  qualify row_number() over (partition by payment_id order by load_ts desc) = 1
)

select * from dedup