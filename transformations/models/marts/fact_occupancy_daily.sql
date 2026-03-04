{{ config(materialized='table', schema='GOLD') }}

with bookings as (
    select
        booking_id,
        property_code,
        room_code,
        checkin_date,
        checkout_date,
        booking_status,
        total_amount,
        tax_amount,
        nights
    from {{ ref('stg_bookings') }}
    where checkin_date is not null
      and checkout_date is not null
      and nights is not null
      and nights >= 1
      and booking_status in ('CONFIRMED')   -- optional: exclude cancelled
),

stay_nights as (
    select
        b.booking_id,
        b.property_code,
        b.room_code,
        dateadd(day, seq4(), b.checkin_date) as stay_date
    from bookings b,
         table(generator(rowcount => 60))   -- constant; supports stays up to 60 nights
    where dateadd(day, seq4(), b.checkin_date) < b.checkout_date
),

daily as (
    select
        property_code,
        stay_date as date_key,
        count(distinct room_code) as rooms_occupied,
        count(*) as occupied_room_nights
    from stay_nights
    group by property_code, stay_date
)

select
    property_code as property_key,
    date_key,
    rooms_occupied,
    occupied_room_nights
from daily