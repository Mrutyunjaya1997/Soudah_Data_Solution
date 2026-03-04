# Soudah Peaks Synthetic Raw Data (Bronze)

This folder contains **messy, realistic raw data** for the Soudah Peaks Data Platform project.

## Contents
- `bookings/` : bookings batch feed (CSV)
- `payments/` : payments batch feed (CSV)
- `pos/` : POS transactions batch feed (CSV)
- `housekeeping/` : housekeeping event stream (JSON lines)
- `maintenance/` : maintenance ticket event stream (JSON lines)

## What is intentionally messy?
- Mixed date formats (ISO, dd/mm/yy, etc.)
- Amounts with currency text and commas (`SAR 3,450.00`)
- Duplicate records (2–5%)
- Inconsistent enums (`CONFIRMED`, `cnf`, etc.)
- Null markers as strings (`NULL`, `NA`, empty string)
- IDs with leading/trailing spaces and casing differences
- Some broken JSON in POS `line_items_raw`

## Files generated
- bookings_raw_20260301.csv
- payments_raw_20260301.csv
- pos_raw_20260301_10.csv
- housekeeping_events_20260301_*.json (JSONL)
- maintenance_events_20260301_*.json (JSONL)

Generated at: 2026-03-03 07:22:42

## Next step
Load into Snowflake Bronze tables via COPY INTO / Snowpipe, then transform to Silver.
