{{ config(materialized='view', schema='SILVER') }}

with src as (
  select * from {{ source('bronze', 'POS_TXN_RAW') }}
),

clean as (
  select
    nullif(trim(txn_id), '') as txn_id,
    {{ parse_ts('txn_time_raw') }} as txn_time_ts,

    upper(nullif(trim(property_code), '')) as property_code,
    nullif(trim(outlet_name), '') as outlet_name,
    nullif(trim(guest_ref), '') as guest_ref,

    {{ parse_amount('net_amount_raw') }} as net_amount,
    {{ parse_amount('tax_amount_raw') }} as tax_amount,
    {{ parse_amount('tip_amount_raw') }} as tip_amount,

    upper(nullif(trim(payment_mode), '')) as payment_mode,

    try_to_number(nullif(trim(items_count_raw), ''), 38, 0) as items_count,

    -- try parse JSON line items if valid; else NULL
    try_parse_json(nullif(trim(line_items_raw), '')) as line_items_json,
    nullif(trim(line_items_raw), '') as line_items_raw,

    nullif(trim(source_file), '') as source_file,
    {{ parse_ts('ingested_at') }} as ingested_at_ts,
    load_ts
  from src
  where upper(trim(txn_id)) not in ('', 'NULL', 'NA') and txn_id is not null
),

dedup as (
  select *
  from clean
  qualify row_number() over (partition by txn_id order by load_ts desc) = 1
)

select * from dedup