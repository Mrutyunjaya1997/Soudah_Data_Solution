{{ config(materialized='table', schema='GOLD') }}

with ch as (
    select distinct channel
    from {{ ref('stg_bookings') }}
    where channel is not null
)

select
    md5(channel) as channel_key,
    channel      as channel_name
from ch