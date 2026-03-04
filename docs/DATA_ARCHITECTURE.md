
# Soudah Peaks Data Platform
## Data Layer Documentation

This document explains the data architecture used in the **Soudah Peaks Data Platform**, implemented on **Snowflake using dbt**.

The platform follows a **Medallion Architecture** with three layers:

Raw Files → Bronze → Silver → Gold → Streamlit Dashboard

| Layer | Purpose |
|------|------|
| Bronze | Raw ingestion of source data |
| Silver | Cleaned and standardized data |
| Gold | Business-ready analytical models |

---

# 1. Bronze Layer (Raw Data)

The **Bronze layer** stores raw ingested data exactly as received from source systems.

### Key Characteristics
- No transformations
- Raw formats preserved
- Used for audit and traceability
- Ingested using Snowflake `COPY INTO`

All Bronze tables exist in:

SOUDAH_DB.BRONZE

---

## BOOKINGS_RAW

Raw booking data from reservation systems.

| Column | Description |
|------|------|
| BOOKING_ID | Unique booking identifier |
| GUEST_REF | Guest identifier from source system |
| PROPERTY_CODE | Resort or hotel code |
| ROOM_CODE | Raw room identifier |
| RATEPLAN_CODE | Pricing rate plan |
| CHANNEL | Booking channel (OTA, Direct, etc.) |
| BOOKING_STATUS | Booking status |
| CHECKIN_DATE_RAW | Raw check-in date |
| CHECKOUT_DATE_RAW | Raw check-out date |
| BOOKED_AT_RAW | Raw booking timestamp |
| CURRENCY | Booking currency |
| TOTAL_AMOUNT_RAW | Raw total booking amount |
| DISCOUNT_RAW | Discount value |
| TAX_RAW | Raw tax value |
| ADULTS_RAW | Number of adults |
| CHILDREN_RAW | Number of children |
| SPECIAL_REQUESTS | Guest special requests |
| CANCELLATION_REASON | Reason for cancellation |
| SOURCE_FILE | Source file name |
| INGESTED_AT | Raw ingestion timestamp |
| LOAD_TS | Snowflake load timestamp |

---

## PAYMENTS_RAW

Raw payment transactions.

| Column | Description |
|------|------|
| PAYMENT_ID | Payment identifier |
| BOOKING_ID | Related booking |
| PAID_AT_RAW | Raw payment timestamp |
| PAYMENT_METHOD | Payment method |
| PAYMENT_STATUS | Payment status |
| AMOUNT_RAW | Raw payment amount |
| FEE_RAW | Payment processing fee |
| REFUND_AMOUNT_RAW | Refund amount |
| GATEWAY_REF | Payment gateway reference |
| NOTES | Additional payment notes |
| SOURCE_FILE | Source file |
| INGESTED_AT | Raw ingestion timestamp |
| LOAD_TS | Load timestamp |

---

## POS_TXN_RAW

Point-of-sale transactions (restaurants, spa, retail).

| Column | Description |
|------|------|
| TXN_ID | POS transaction ID |
| TXN_TIME_RAW | Raw transaction timestamp |
| PROPERTY_CODE | Property code |
| OUTLET_NAME | Outlet name |
| GUEST_REF | Guest reference |
| NET_AMOUNT_RAW | Net transaction value |
| TAX_AMOUNT_RAW | Tax amount |
| TIP_AMOUNT_RAW | Tip value |
| PAYMENT_MODE | Payment method |
| ITEMS_COUNT_RAW | Number of items |
| LINE_ITEMS_RAW | Raw JSON line items |
| SOURCE_FILE | Source file |
| INGESTED_AT | Raw ingestion time |
| LOAD_TS | Load timestamp |

---
## HOUSEKEEPING_EVENTS_RAW

Housekeeping operational events.

| Column | Description |
|------|------|
| EVENT_ID | Event identifier |
| TASK_ID | Housekeeping task identifier |
| EVENT_TIME_RAW | Event timestamp |
| PROPERTY_CODE | Property code |
| ROOM_CODE | Room identifier |
| STATUS | Task status |
| STAFF_ID_RAW | Housekeeping staff ID |
| PRIORITY_RAW | Task priority |
| NOTES | Additional notes |
| PAYLOAD | JSON payload |
| SRC_FILENAME | Source filename |
| LOAD_TS | Load timestamp |

---

## MAINTENANCE_EVENTS_RAW

Maintenance operations events.

| Column | Description |
|------|------|
| EVENT_ID | Event identifier |
| TICKET_ID | Maintenance ticket |
| EVENT_TIME_RAW | Event timestamp |
| PROPERTY_CODE | Property code |
| ASSET_TAG | Asset identifier |
| SEVERITY_RAW | Severity level |
| STATUS_RAW | Ticket status |
| ISSUE_TEXT | Issue description |
| DOWNTIME_MINUTES_RAW | Raw downtime duration |
| PAYLOAD | JSON payload |
| SRC_FILENAME | Source filename |
| LOAD_TS | Load timestamp |
"""

# 2. Silver Layer (Cleaned Data)

The **Silver layer** standardizes and cleans raw data.

All transformations are implemented using **dbt models**.

Location:

SOUDAH_DB.SILVER

### Data Cleaning Transformations

| Transformation | Description |
|------|------|
| Trim strings | Remove leading/trailing spaces |
| Normalize nulls | Convert "NULL", "NA", "" → NULL |
| Standardize enums | Normalize status values |
| Parse dates | Convert raw date formats |
| Parse timestamps | Convert multiple timestamp formats |
| Parse amounts | Remove currency text and commas |
| Convert types | Convert strings → numeric/date types |

### Deduplication

Silver tables keep the latest record only.

Example:

ROW_NUMBER() OVER (
PARTITION BY booking_id
ORDER BY load_ts DESC
)

---

## Silver Staging Views

| Table | Description |
|------|------|
| STG_BOOKINGS | Cleaned booking data |
| STG_PAYMENTS | Cleaned payments |
| STG_POS_TXN | Cleaned POS transactions |
| STG_HOUSEKEEPING_EVENTS | Cleaned housekeeping events |
| STG_MAINTENANCE_EVENTS | Cleaned maintenance events |

---

## Intermediate Models

| Table | Description |
|------|------|
| INT_HOUSEKEEPING_TASK_ROLLUP | Aggregated housekeeping tasks |
| INT_MAINTENANCE_TICKET_ROLLUP | Aggregated maintenance tickets |

Example calculations:

**Housekeeping**
- Task duration
- SLA breach detection

**Maintenance**
- Ticket resolution time
- Mean time to repair (MTTR)

---

# 3. Gold Layer (Analytics Layer)

The **Gold layer** provides business-ready analytical tables.

Location:

SOUDAH_DB.GOLD

This layer follows a **star schema design**.

---

## Dimension Tables

### DIM_DATE

| Column |
|------|
| DATE_KEY |
| YEAR |
| MONTH |
| DAY |
| DAY_OF_WEEK |
| WEEK_OF_YEAR |
| QUARTER |
| IS_WEEKEND |

### DIM_PROPERTY

| Column |
|------|
| PROPERTY_KEY |
| PROPERTY_CODE |
| DESTINATION_NAME |

### DIM_ROOM

| Column |
|------|
| ROOM_KEY |
| ROOM_CODE |
| ROOM_TYPE |
| ROOM_NUMBER |

### DIM_CHANNEL

| Column |
|------|
| CHANNEL_KEY |
| CHANNEL_NAME |

### DIM_GUEST

| Column |
|------|
| GUEST_KEY |
| GUEST_REF |

---

## Fact Tables

### FACT_BOOKINGS
Grain: **1 row per booking**

Measures:
- total_amount
- tax_amount
- discount_amount
- nights
- adults
- children

### FACT_PAYMENTS
Grain: **1 row per payment**

Measures:
- amount
- fee_amount
- refund_amount

### FACT_POS_TXN
Grain: **1 row per POS transaction**

Measures:
- net_amount
- tax_amount
- tip_amount
- total_amount

### FACT_HOUSEKEEPING_TASKS
Grain: **1 row per housekeeping task**

Measures:
- duration_minutes
- SLA breach flag

### FACT_MAINTENANCE_TICKETS
Grain: **1 row per maintenance ticket**

Measures:
- resolution_minutes
- ticket status
- open ticket indicator

### FACT_OCCUPANCY_DAILY
Grain: **property + date**

Measures:
- rooms_occupied
- occupied_room_nights

---

# Key Business KPIs

**Occupancy**  
occupied_room_nights / rooms_available

**ADR (Average Daily Rate)**  
booking_revenue / rooms_sold

**RevPAR (Revenue per Available Room)**  
booking_revenue / rooms_available

**Housekeeping SLA**  
tasks_completed_within_SLA / total_tasks

**Maintenance MTTR**  
average(resolution_minutes)

---

# Final Architecture

SNOWFLAKE STAGE  
↓  
BRONZE (Raw ingestion)  
↓  
SILVER (Cleaning + standardization)  
↓  
INTERMEDIATE (Operational aggregation)  
↓  
GOLD (Star schema analytics)  
↓  
STREAMLIT DASHBOARD

---

# Technologies Used

| Component | Technology |
|------|------|
| Data Warehouse | Snowflake |
| Transformation | dbt |
| Orchestration | Snowflake Tasks / dbt |
| Analytics | Streamlit |
| Modeling | Star Schema |
