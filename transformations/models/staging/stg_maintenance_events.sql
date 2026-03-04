{{ config(materialized='view', schema='SILVER') }}

with src as (
  select * from {{ source('bronze', 'MAINTENANCE_EVENTS_RAW') }}
),

clean as (
  select
    nullif(trim(event_id), '') as event_id,
    nullif(trim(ticket_id), '') as ticket_id,

    {{ parse_ts('event_time_raw') }} as event_time_ts,

    upper(nullif(trim(property_code), '')) as property_code,
    upper(nullif(trim(asset_tag), '')) as asset_tag,

    {{ norm_severity('severity_raw') }} as severity,
    {{ norm_ticket_status('status_raw') }} as status,

    nullif(trim(issue_text), '') as issue_text,

    -- downtime can be "unknown"/NULL -> TRY_TO_NUMBER handles it as NULL
    try_to_number(nullif(trim(downtime_minutes_raw), ''), 38, 0) as downtime_minutes,

    payload,
    nullif(trim(src_filename), '') as src_filename,
    load_ts
  from src
  where upper(trim(event_id)) not in ('', 'NULL', 'NA') and event_id is not null
),

dedup as (
  select *
  from clean
  qualify row_number() over (partition by event_id order by load_ts desc) = 1
)

select * from dedup