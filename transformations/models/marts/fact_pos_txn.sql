{{ config(materialized='table', schema='GOLD') }}

select
    x.txn_id                                             as pos_txn_key,
    cast(x.txn_time_ts as date)                          as txn_date_key,
    x.txn_time_ts                                        as txn_time_ts,

    md5(x.guest_ref)                                     as guest_key,
    x.property_code                                      as property_key,

    x.outlet_name                                        as outlet_name,
    x.payment_mode                                       as payment_mode,
    x.items_count                                        as items_count,

    x.net_amount                                         as net_amount,
    x.tax_amount                                         as tax_amount,
    x.tip_amount                                         as tip_amount,
    (coalesce(x.net_amount,0) + coalesce(x.tax_amount,0) + coalesce(x.tip_amount,0)) as total_amount,

    x.line_items_json                                    as line_items_json,

    x.source_file                                        as source_file,
    x.ingested_at_ts                                     as ingested_at_ts,
    x.load_ts                                            as load_ts
from {{ ref('stg_pos_txn') }} x