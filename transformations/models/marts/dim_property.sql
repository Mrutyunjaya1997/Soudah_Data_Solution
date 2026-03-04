{{ config(materialized='table', schema='GOLD') }}

with props as (
    select distinct property_code
    from {{ ref('stg_bookings') }}
    where property_code is not null
    union
    select distinct property_code
    from {{ ref('stg_pos_txn') }}
    where property_code is not null
    union
    select distinct property_code
    from {{ ref('stg_housekeeping_events') }}
    where property_code is not null
    union
    select distinct property_code
    from {{ ref('stg_maintenance_events') }}
    where property_code is not null
)

select
    property_code as property_key,
    property_code as property_code,
    'Soudah Peaks' as destination_name
from props