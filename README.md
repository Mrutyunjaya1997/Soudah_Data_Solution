🏔️ Soudah Peaks Data Platform
End-to-End Snowflake Data Engineering Project

A modern data platform built on Snowflake for a luxury tourism destination Soudah Peaks, designed to enable real-time operational analytics, revenue insights, and executive dashboards.

This project demonstrates industry-grade data engineering architecture, including:

Snowflake data warehouse

Medallion architecture (Bronze → Silver → Gold)

dbt transformation framework

schemachange migration management

Snowflake Streamlit dashboards

Synthetic data generation

Operational and revenue analytics

📌 Business Context

Soudah Peaks is a luxury mountain tourism destination developed by Soudah Development, a subsidiary of the Public Investment Fund (PIF) of Saudi Arabia.

The destination includes:

Luxury resorts

Hospitality services

Retail and dining outlets

Outdoor adventure activities

This platform enables data-driven decision making for:

Revenue optimization

Guest experience monitoring

Operational efficiency

Maintenance management

🏗️ System Architecture
            +-----------------------+
            |   Synthetic Data      |
            | (Bookings / POS etc)  |
            +-----------+-----------+
                        |
                        ▼
               +----------------+
               |   MinIO        |
               | Object Storage |
               +-------+--------+
                       |
                       ▼
               +----------------+
               | Snowflake      |
               | External Stage |
               +-------+--------+
                       |
                       ▼
               +----------------+
               | Bronze Layer   |
               | Raw ingestion  |
               +-------+--------+
                       |
                       ▼
               +----------------+
               | Silver Layer   |
               | Data cleaning  |
               | Standardization|
               +-------+--------+
                       |
                       ▼
               +----------------+
               | Gold Layer     |
               | Star Schema    |
               | Business KPIs  |
               +-------+--------+
                       |
                       ▼
               +----------------+
               | Streamlit App  |
               | Executive Dash |
               +----------------+
🧱 Data Architecture

The project follows the Medallion Architecture pattern.

Layer	Purpose
Bronze	Raw ingestion of source data
Silver	Cleaned and standardized data
Gold	Analytical models and KPIs
🥉 Bronze Layer (Raw Data)

The Bronze layer stores raw ingested data exactly as received from source systems.

Database:

SOUDAH_DB.BRONZE

Tables:

Table	Description
BOOKINGS_RAW	Raw booking data
PAYMENTS_RAW	Payment transactions
POS_TXN_RAW	Restaurant / retail transactions
HOUSEKEEPING_EVENTS_RAW	Housekeeping task events
MAINTENANCE_EVENTS_RAW	Maintenance ticket events

Key characteristics:

No transformations

Raw data preserved

Auditability

Source file metadata stored

Example ingestion:

COPY INTO BOOKINGS_RAW
FROM @STG_BOOKINGS
FILE_FORMAT = FF_CSV_RAW;
🥈 Silver Layer (Cleaned Data)

The Silver layer applies data quality and transformation logic.

Database:

SOUDAH_DB.SILVER

Transformations implemented using dbt models.

Data Cleaning

Trim whitespace

Normalize NULL values

Parse timestamps

Parse currency values

Convert data types

Data Standardization

Normalize booking status

Standardize payment methods

Standardize room codes

Deduplication

Latest record retained using:

ROW_NUMBER() OVER (
PARTITION BY booking_id
ORDER BY load_ts DESC
)
🥇 Gold Layer (Analytics)

The Gold layer provides business-ready analytical tables.

Database:

SOUDAH_DB.GOLD

The schema follows a star schema design.

⭐ Dimension Tables
Table	Description
DIM_DATE	Date dimension
DIM_PROPERTY	Resort properties
DIM_ROOM	Room information
DIM_CHANNEL	Booking channels
DIM_GUEST	Guest identifiers
📊 Fact Tables
Table	Description
FACT_BOOKINGS	Booking revenue
FACT_PAYMENTS	Payment transactions
FACT_POS_TXN	Restaurant / retail revenue
FACT_OCCUPANCY_DAILY	Daily occupancy metrics
FACT_HOUSEKEEPING_TASKS	Housekeeping operations
FACT_MAINTENANCE_TICKETS	Maintenance operations
📈 Key Business Metrics
Occupancy
Occupied Room Nights / Available Rooms
ADR (Average Daily Rate)
Total Booking Revenue / Rooms Sold
RevPAR (Revenue per Available Room)
Total Revenue / Available Rooms
Housekeeping SLA
Tasks Completed Within SLA / Total Tasks
Maintenance MTTR
Average Ticket Resolution Time
📊 Streamlit Dashboard

A Snowflake Native Streamlit app provides an executive dashboard.

Metrics displayed:

Occupancy trends

ADR

RevPAR

POS revenue

Housekeeping SLA

Maintenance downtime

Dashboard components include:

Widget	Description
KPI Cards	Revenue and operational metrics
Time Series	Occupancy trends
Revenue Charts	POS performance
Operational Tables	Maintenance and housekeeping
🧰 Tech Stack
Category	Technology
Data Warehouse	Snowflake
Transformation	dbt
Migration Management	schemachange
Object Storage	MinIO
Data Processing	Snowflake SQL
Analytics	Streamlit
Version Control	Git / GitHub
📂 Project Structure
soudah_data_solution
│
├── migrations
│   ├── V001_create_database.sql
│   ├── V002_create_schemas.sql
│   ├── V003_bronze_tables.sql
│
├── load_sql
│   ├── copy_into_bronze.sql
│
├── dbt_project
│   ├── models
│   │   ├── staging
│   │   ├── intermediate
│   │   ├── marts
│
├── synthetic_data_generator
│
├── streamlit_app
│
└── docs
🚀 Running the Project
Install dependencies
pip install dbt-snowflake
pip install schemachange
Run database migrations
schemachange --config-file schemachange-config.yml deploy
Load Bronze data

Upload files to Snowflake stage then run:

COPY INTO BOOKINGS_RAW
FROM @STG_BOOKINGS;
Run dbt transformations
dbt run
Launch Streamlit dashboard

The Streamlit app runs inside Snowflake:

SOUDAH_DB.UTIL.SOUDAH_EXEC_DASH
🎯 Key Data Engineering Concepts Demonstrated

This project demonstrates:

Medallion architecture

Star schema modeling

Incremental ingestion

Data quality transformations

Operational analytics

Cloud data warehouse design

Database migration management

📚 Future Enhancements

Possible improvements:

Demand forecasting using Snowflake ML

Dynamic pricing models

Real-time ingestion with Snowpipe

Anomaly detection pipelines

Customer segmentation