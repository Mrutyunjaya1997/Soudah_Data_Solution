# Soudah Peaks Data Platform

## Business Requirements Document (BRD)

---

## 1. Project Overview

**Project Name:** Soudah Peaks Data Platform
**Client:** Soudah Development (Public Investment Fund, Saudi Arabia)

Soudah Peaks is a luxury mountain tourism destination focused on delivering premium hospitality, unique guest experiences, and sustainable development. This project aims to design and build a **modern data platform on Snowflake** to enable data-driven decision-making across revenue, operations, guest experience, and sustainability.

The platform will integrate multiple data sources, process them in real-time and batch modes, and provide insights through an interactive Streamlit dashboard.

---

## 2. Business Objectives

### 2.1 Revenue Growth

* Increase occupancy rates and revenue per available room (RevPAR)
* Optimize pricing strategies based on demand patterns
* Improve booking conversion rates

### 2.2 Guest Experience Enhancement

* Improve customer satisfaction (NPS)
* Reduce complaints and improve response times
* Personalize guest experiences

### 2.3 Operational Efficiency

* Improve housekeeping and maintenance turnaround times
* Optimize staff allocation
* Reduce operational downtime


---

## 3. Key Stakeholders

| Stakeholder             | Responsibility                      |
| ----------------------- | ----------------------------------- |
| Executive Team          | Strategic decisions and KPIs        |
| Revenue Management Team | Pricing and demand optimization     |
| Operations Team         | Housekeeping, maintenance, staffing |
| Guest Experience Team   | Customer satisfaction and service   |   |
| Data Engineering Team   | Data pipelines and infrastructure   |
| Analytics Team          | Reporting and insights              |

---

## 4. Key Business Questions

### Revenue & Demand

* Which booking channels generate the highest revenue?
* What factors influence cancellations?
* How does seasonality and weather impact demand?

### Guest Experience

* What are the most common complaints?
* What drives high NPS scores?
* Which services improve customer satisfaction?

### Operations

* What is the average housekeeping turnaround time?
* Which assets have frequent maintenance issues?
* How can staff allocation be optimized?

## 5. Data Requirements

### 5.1 Internal Data Sources

#### Booking & Revenue Data

* Booking details (booking_id, guest_id, dates, price)
* Cancellation details
* Payment transactions
* Room inventory and pricing

#### Guest Data

* Guest profiles
* Preferences
* Loyalty information

#### Operations Data

* Housekeeping tasks
* Maintenance tickets
* Staff schedules

#### Experience Data

* Activity bookings
* POS transactions (restaurants, spa, retail)


---

## 6. Data Ingestion Requirements

### Batch Processing

* Daily ingestion of bookings, payments, POS data
* Scheduled loads for master data (guests, properties)

### Streaming / Near Real-Time Processing

* Clickstream data from website/app
* Check-in and check-out events
* Housekeeping and maintenance updates

---

## 7. Data Processing Requirements

### Data Quality

* Deduplication of records
* Validation of relationships (foreign keys)
* Handling missing values

### Data Transformation

* Standardization of formats
* Enrichment with external data
* Aggregation for reporting

### Incremental Processing

* Use change data capture (CDC)
* Process only new/updated records

---

## 8. Data Modeling Requirements

### Data Warehouse Design

* Star schema for analytics
* Separate layers: Bronze, Silver, Gold

### Fact Tables

* Bookings
* Stays
* Payments
* POS transactions
* Maintenance events
* Housekeeping tasks
* Meter readings

### Dimension Tables

* Date
* Guest
* Property
* Room
* Channel
* Activity

### Historical Tracking

* Implement Slowly Changing Dimensions (SCD Type 2)

---

## 9. Analytics & Reporting Requirements

### KPIs

* Occupancy Rate
* ADR (Average Daily Rate)
* RevPAR (Revenue Per Available Room)
* Cancellation Rate
* NPS Score (Net Promoter Score)

### Dashboard Features

* Real-time and historical insights
* Filtering by property, date, channel
* Drill-down capabilities

---

## 10. Technology Requirements

### Core Platform

* Snowflake (Data Warehouse)

### Data Processing

* Snowflake Streams & Tasks
* Snowpipe for ingestion
* dbt for data modeling and transformations

### Visualization

* Streamlit Dashboard

### Optional Advanced Features

* Snowflake Cortex for AI insights
* Machine learning for forecasting and anomaly detection

---

## 11. Security & Governance

* Role-based access control (RBAC)
* Data masking for sensitive information
* Audit logging
* Compliance with data privacy regulations

---

## 12. Performance & Scalability

* Scalable compute using Snowflake warehouses
* Auto-scaling and auto-suspend
* Query optimization using clustering and partitioning

---

## 13. Data Refresh Requirements

| Data Type       | Frequency      |
| --------------- | -------------- |
| Booking Data    | Daily          |
| POS Data        | Hourly         |
| Operations Data | Near real-time |

---

## 14. Success Criteria

* Increase revenue by data-driven pricing
* Improve guest satisfaction scores
* Reduce operational inefficiencies
---

## 15. Future Enhancements

* Predictive analytics for demand forecasting
* Recommendation system for guests
* Anomaly detection for operations
* Real-time alerting system

---

## 16. Deliverables

* Snowflake Data Warehouse (Bronze, Silver, Gold layers)
* Data pipelines (batch and streaming)
* Streamlit dashboard
* Documentation and architecture diagrams

---

## 17. Project Timeline (High-Level)

| Phase                  | Duration |
| ---------------------- | -------- |
| Requirement Gathering  | 1 week   |
| Data Modeling          | 1 week   |
| Data Ingestion Setup   | 2 weeks  |
| Transformation Layer   | 2 weeks  |
| Dashboard Development  | 2 weeks  |
| Testing & Optimization | 1 week   |

---

## 18. Conclusion

This project will establish a scalable and intelligent data platform for Soudah Peaks, enabling data-driven decisions across business functions. By leveraging Snowflake and modern data engineering practices, the platform will support real-time analytics, operational efficiency, and enhanced guest experiences.


erDiagram
  GUEST ||--o{ BOOKING : makes
  BOOKING ||--o{ PAYMENT : has
  BOOKING }o--|| CHANNEL : sourced_from
  BOOKING }o--|| RATE_PLAN : priced_by
  BOOKING ||--o{ STAY : materializes_as

  PROPERTY ||--o{ ROOM : contains
  ROOM ||--o{ STAY : assigned_to

  STAY ||--o{ HOUSEKEEPING_TASK : generates
  PROPERTY ||--o{ MAINTENANCE_TICKET : receives

  GUEST ||--o{ POS_TXN : spends
  PROPERTY ||--o{ POS_TXN : occurs_at

  ACTIVITY ||--o{ ACTIVITY_BOOKING : booked_as
  GUEST ||--o{ ACTIVITY_BOOKING : participates
  STAY ||--o{ ACTIVITY_BOOKING : during

---
