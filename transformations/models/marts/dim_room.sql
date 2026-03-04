{{ config(materialized='table', schema='GOLD') }}

with rooms as (
    select distinct
        room_code
    from {{ ref('stg_bookings') }}
    where room_code is not null
),

parsed as (
    select
        room_code,

        -- Room type guess: DLX/STE/VIL else UNKNOWN
        case
            when regexp_like(room_code, 'DLX') then 'DLX'
            when regexp_like(room_code, 'STE') then 'STE'
            when regexp_like(room_code, 'VIL') then 'VIL'
            else 'UNKNOWN'
        end as room_type,

        -- extract first number as room_number
        try_to_number(regexp_substr(room_code, '[0-9]+')) as room_number
    from rooms
)

select
    md5(room_code) as room_key,
    room_code,
    room_type,
    room_number
from parsed