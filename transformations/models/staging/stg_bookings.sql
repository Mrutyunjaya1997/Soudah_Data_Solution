{{ config(materialized='view', schema='SILVER') }}

with src as (
  select * from {{ source('bronze', 'BOOKINGS_RAW') }}
),

clean as (
  select
    -- IDs / codes (trim + standardize)
    nullif(trim(booking_id), '') as booking_id,
    nullif(trim(guest_ref), '') as guest_ref,
    upper(nullif(trim(property_code), '')) as property_code,
    upper(nullif(trim(room_code), '')) as room_code,
    upper(nullif(trim(rateplan_code), '')) as rateplan_code,
    upper(nullif(trim(channel), '')) as channel,

    {{ norm_booking_status('booking_status') }} as booking_status,

    -- dates (multiple formats)
    coalesce(
      try_to_date(trim(checkin_date_raw), 'YYYY-MM-DD'),
      try_to_date(trim(checkin_date_raw), 'DD/MM/YY'),
      try_to_date(trim(checkin_date_raw), 'DD-MM-YYYY'),
      try_to_date(trim(checkin_date_raw), 'MON DD YYYY'),
      try_to_date(trim(checkin_date_raw), 'MONTH DD, YYYY')
    ) as checkin_date,

    coalesce(
      try_to_date(trim(checkout_date_raw), 'YYYY-MM-DD'),
      try_to_date(trim(checkout_date_raw), 'DD/MM/YY'),
      try_to_date(trim(checkout_date_raw), 'DD-MM-YYYY'),
      try_to_date(trim(checkout_date_raw), 'MON DD YYYY'),
      try_to_date(trim(checkout_date_raw), 'MONTH DD, YYYY')
    ) as checkout_date,

    {{ parse_ts('booked_at_raw') }} as booked_at_ts,

    upper(nullif(trim(currency), '')) as currency,

    {{ parse_amount('total_amount_raw') }} as total_amount,
    {{ parse_amount('tax_raw') }} as tax_amount,

    -- discount can be "10%" or "150"
    case
      when discount_raw is null then null
      when regexp_like(trim(discount_raw), '^[0-9]+%$') then
        -- percent of (total - tax) approx; in Silver we keep both percent and computed amount
        try_to_number(replace(trim(discount_raw), '%','')) / 100
      else null
    end as discount_pct,

    case
      when discount_raw is null then null
      when regexp_like(trim(discount_raw), '^[0-9]+%$') then null
      else {{ parse_amount('discount_raw') }}
    end as discount_amount,

    try_to_number(nullif(trim(adults_raw), ''), 38, 0) as adults,
    try_to_number(nullif(trim(children_raw), ''), 38, 0) as children,

    nullif(trim(special_requests), '') as special_requests,
    nullif(trim(cancellation_reason), '') as cancellation_reason,

    nullif(trim(source_file), '') as source_file,
    {{ parse_ts('ingested_at') }} as ingested_at_ts,
    load_ts

  from src
  where upper(trim(booking_id)) not in ('', 'NULL', 'NA') and booking_id is not null
),

dedup as (
  select *
  from clean
  qualify row_number() over (partition by booking_id order by load_ts desc) = 1
)

select
  *,
  datediff('day', checkin_date, checkout_date) as nights
from dedup