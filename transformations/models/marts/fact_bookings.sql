{{ config(materialized='table', schema='GOLD') }}

select
    b.booking_id                                         as booking_key,
    md5(b.guest_ref)                                     as guest_key,
    b.property_code                                      as property_key,
    md5(b.channel)                                       as channel_key,
    md5(b.room_code)                                     as room_key,

    b.checkin_date                                       as checkin_date,
    b.checkout_date                                      as checkout_date,
    b.booked_at_ts                                       as booked_at_ts,

    b.nights                                             as nights,
    b.adults                                             as adults,
    b.children                                           as children,

    b.currency                                           as currency,
    b.total_amount                                       as total_amount,
    b.tax_amount                                         as tax_amount,

    -- if discount_pct exists, compute approximate amount off base (total - tax)
    coalesce(
        b.discount_amount,
        (b.total_amount - b.tax_amount) * b.discount_pct
    )                                                    as discount_amount,

    b.booking_status                                     as booking_status,
    b.cancellation_reason                                as cancellation_reason,

    b.source_file                                        as source_file,
    b.ingested_at_ts                                     as ingested_at_ts,
    b.load_ts                                            as load_ts
from {{ ref('stg_bookings') }} b