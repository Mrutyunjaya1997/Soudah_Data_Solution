{{ config(materialized='view', schema='SILVER') }}

with src as (
  select * from {{ source('bronze', 'HOUSEKEEPING_EVENTS_RAW') }}
),

clean as (
  select
    nullif(trim(event_id), '') as event_id,
    nullif(trim(task_id), '') as task_id,

    {{ parse_ts('event_time_raw') }} as event_time_ts,

    upper(nullif(trim(property_code), '')) as property_code,
    upper(nullif(trim(room_code), '')) as room_code,

    {{ norm_housekeeping_status('status') }} as status,
    nullif(trim(staff_id_raw), '') as staff_id,
    {{ norm_priority('priority_raw') }} as priority,

    nullif(trim(notes), '') as notes,

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