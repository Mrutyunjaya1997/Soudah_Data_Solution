{{ config(materialized='table', schema='SILVER') }}

with e as (
  select *
  from {{ ref('stg_housekeeping_events') }}
  where task_id is not null
),

agg as (
  select
    task_id,
    any_value(property_code) as property_code,
    any_value(room_code) as room_code,
    any_value(priority) as priority,

    min(case when status = 'ASSIGNED' then event_time_ts end) as assigned_time,
    min(case when status = 'START' then event_time_ts end) as start_time,
    max(case when status = 'DONE' then event_time_ts end) as done_time,

    -- latest status by event_time_ts (fallback load_ts)
    max_by(status, coalesce(event_time_ts, load_ts)) as latest_status,

    count(*) as event_count,
    max(load_ts) as last_load_ts
  from e
  group by task_id
)

select
  *,
  datediff('minute', start_time, done_time) as duration_minutes,
  case
    when done_time is null or start_time is null then null
    when datediff('minute', start_time, done_time) > 60 then true
    else false
  end as sla_breached_60m
from agg