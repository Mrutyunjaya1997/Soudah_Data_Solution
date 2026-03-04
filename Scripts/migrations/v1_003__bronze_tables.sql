-- V1_003__bronze_tables.sql
-- Bronze tables to store messy raw data

USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;

USE DATABASE SOUDAH_DB;
USE SCHEMA BRONZE;

CREATE OR REPLACE TABLE BOOKINGS_RAW (
  booking_id           STRING,
  guest_ref            STRING,
  property_code        STRING,
  room_code            STRING,
  rateplan_code        STRING,
  channel              STRING,
  booking_status       STRING,
  checkin_date_raw     STRING,
  checkout_date_raw    STRING,
  booked_at_raw        STRING,
  currency             STRING,
  total_amount_raw     STRING,
  discount_raw         STRING,
  tax_raw              STRING,
  adults_raw           STRING,
  children_raw         STRING,
  special_requests     STRING,
  cancellation_reason  STRING,
  source_file          STRING,
  ingested_at          STRING,
  load_ts              TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE PAYMENTS_RAW (
  payment_id         STRING,
  booking_id         STRING,
  paid_at_raw        STRING,
  payment_method     STRING,
  payment_status     STRING,
  amount_raw         STRING,
  fee_raw            STRING,
  refund_amount_raw  STRING,
  gateway_ref        STRING,
  notes              STRING,
  source_file        STRING,
  ingested_at        STRING,
  load_ts            TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE POS_TXN_RAW (
  txn_id          STRING,
  txn_time_raw    STRING,
  property_code   STRING,
  outlet_name     STRING,
  guest_ref       STRING,
  net_amount_raw  STRING,
  tax_amount_raw  STRING,
  tip_amount_raw  STRING,
  payment_mode    STRING,
  items_count_raw STRING,
  line_items_raw  STRING,
  source_file     STRING,
  ingested_at     STRING,
  load_ts         TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE HOUSEKEEPING_EVENTS_RAW (
  event_id        STRING,
  task_id         STRING,
  event_time_raw  STRING,
  property_code   STRING,
  room_code       STRING,
  status          STRING,
  staff_id_raw    STRING,
  priority_raw    STRING,
  notes           STRING,
  payload         VARIANT,
  src_filename    STRING,
  load_ts         TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE MAINTENANCE_EVENTS_RAW (
  event_id             STRING,
  ticket_id            STRING,
  event_time_raw       STRING,
  property_code        STRING,
  asset_tag            STRING,
  severity_raw         STRING,
  status_raw           STRING,
  issue_text           STRING,
  downtime_minutes_raw STRING,
  payload              VARIANT,
  src_filename         STRING,
  load_ts              TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);