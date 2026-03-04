{{ config(materialized='table', schema='SILVER') }}

with e as (
  select *
  from {{ ref('stg_maintenance_events') }}
  where ticket_id is not null
),

agg as (
  select
    ticket_id,
    any_value(property_code) as property_code,
    any_value(asset_tag) as asset_tag,
    any_value(severity) as severity,

    min(case when status = 'OPEN' then event_time_ts end) as opened_time,
    min(case when status = 'IN_PROGRESS' then event_time_ts end) as in_progress_time,
    max(case when status = 'CLOSED' then event_time_ts end) as closed_time,

    max_by(status, coalesce(event_time_ts, load_ts)) as latest_status,

    count(*) as event_count,
    max(load_ts) as last_load_ts
  from e
  group by ticket_id
)

select
  *,
  datediff('minute', opened_time, closed_time) as resolution_minutes,
  case
    when closed_time is null then true
    else false
  end as is_open
from agg