{{ config(materialized='table', schema='GOLD') }}

with p as (
    select * from {{ ref('stg_payments') }}
),
b as (
    select booking_id, property_code, channel, guest_ref
    from {{ ref('stg_bookings') }}
)

select
    p.payment_id                                         as payment_key,
    p.booking_id                                         as booking_key,

    md5(b.guest_ref)                                     as guest_key,
    b.property_code                                      as property_key,
    md5(b.channel)                                       as channel_key,

    p.paid_at_ts                                         as paid_at_ts,
    cast(p.paid_at_ts as date)                           as paid_date_key,

    p.payment_method                                     as payment_method,
    p.payment_status                                     as payment_status,

    p.amount                                             as amount,
    coalesce(p.fee_amount, p.amount * p.fee_pct)          as fee_amount,
    p.refund_amount                                      as refund_amount,

    p.gateway_ref                                        as gateway_ref,
    p.source_file                                        as source_file,
    p.ingested_at_ts                                     as ingested_at_ts,
    p.load_ts                                            as load_ts
from p
left join b on p.booking_id = b.booking_id