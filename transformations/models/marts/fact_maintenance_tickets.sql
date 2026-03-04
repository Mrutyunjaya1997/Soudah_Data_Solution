{{ config(materialized='table', schema='GOLD') }}

select
    ticket_id                                            as maintenance_ticket_key,
    property_code                                        as property_key,
    asset_tag                                            as asset_tag,

    severity                                             as severity,
    opened_time                                          as opened_time,
    in_progress_time                                     as in_progress_time,
    closed_time                                          as closed_time,

    resolution_minutes                                   as resolution_minutes,
    is_open                                              as is_open,

    latest_status                                        as latest_status,
    event_count                                          as event_count,
    last_load_ts                                         as load_ts
from {{ ref('int_maintenance_ticket_rollup') }}