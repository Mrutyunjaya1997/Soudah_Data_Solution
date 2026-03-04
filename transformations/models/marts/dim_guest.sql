{{ config(materialized='table', schema='GOLD') }}

with g as (
    select distinct guest_ref
    from {{ ref('stg_bookings') }}
    where guest_ref is not null
    union
    select distinct guest_ref
    from {{ ref('stg_pos_txn') }}
    where guest_ref is not null
)

select
    md5(guest_ref) as guest_key,
    guest_ref      as guest_ref
from g