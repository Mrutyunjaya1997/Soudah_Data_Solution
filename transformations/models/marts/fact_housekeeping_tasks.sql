{{ config(materialized='table', schema='GOLD') }}

select
    task_id                                              as housekeeping_task_key,
    property_code                                        as property_key,
    md5(room_code)                                       as room_key,

    assigned_time                                        as assigned_time,
    start_time                                           as start_time,
    done_time                                            as done_time,

    duration_minutes                                     as duration_minutes,
    sla_breached_60m                                     as sla_breached_60m,

    latest_status                                        as latest_status,
    event_count                                          as event_count,
    last_load_ts                                         as load_ts
from {{ ref('int_housekeeping_task_rollup') }}