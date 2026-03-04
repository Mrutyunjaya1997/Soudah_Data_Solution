{{ config(materialized='table', schema='GOLD') }}

with dates as (
    select checkin_date as d from {{ ref('stg_bookings') }} where checkin_date is not null
    union all
    select checkout_date as d from {{ ref('stg_bookings') }} where checkout_date is not null
    union all
    select cast(paid_at_ts as date) as d from {{ ref('stg_payments') }} where paid_at_ts is not null
    union all
    select cast(txn_time_ts as date) as d from {{ ref('stg_pos_txn') }} where txn_time_ts is not null
    union all
    select cast(event_time_ts as date) as d from {{ ref('stg_housekeeping_events') }} where event_time_ts is not null
    union all
    select cast(event_time_ts as date) as d from {{ ref('stg_maintenance_events') }} where event_time_ts is not null
),

rng as (
    select min(d) as min_d, max(d) as max_d
    from dates
),

spine as (
    select dateadd(day, seq4(), min_d) as date_day
    from rng, table(generator(rowcount => 4000))
    where dateadd(day, seq4(), min_d) <= max_d
)

select
    date_day                                         as date_key,
    year(date_day)                                   as year,
    month(date_day)                                  as month,
    day(date_day)                                    as day,
    dayofweekiso(date_day)                           as day_of_week_iso,
    dayname(date_day)                                as day_name,
    weekofyear(date_day)                             as week_of_year,
    quarter(date_day)                                as quarter,
    to_char(date_day, 'YYYY-MM')                     as year_month,
    iff(dayofweekiso(date_day) in (6,7), true, false) as is_weekend
from spine