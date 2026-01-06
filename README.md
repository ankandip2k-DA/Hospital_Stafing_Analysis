# 🏥 Hospital Statistics Database Analysis  
### SQL-Based Productivity & Performance Insights

This project is a comprehensive **SQL analytics case study** focused on hospital productivity metrics.  
It demonstrates **data cleaning, aggregation, ranking, window functions, and advanced analytical queries** across multiple hospitals, counties, and years to support healthcare performance benchmarking and decision-making.
👤 Author

Ankandip Sen
TOOL- MySQL

---

## 📌 Project Overview

Healthcare administrators and policymakers require reliable data to evaluate hospital productivity and efficiency.  
This project analyzes **hospital productive hours** to uncover:

- Facility-level performance trends  
- County-wise productivity comparisons  
- Control-type based efficiency insights  
- Year-over-year growth patterns  

---

## 🎯 Project Objectives

- Build a structured hospital productivity database  
- Clean and validate raw hospital statistics data  
- Perform multi-level SQL analysis (facility, county, year)  
- Identify high-performing hospitals and growth trends  

---

## 🗄️ Database Schema

The analysis begins with creating a structured table to store hospital statistics:

```sql
CREATE TABLE Hospital_Stats (
    year INT,
    facility_number BIGINT,
    facility_name VARCHAR(100),
    begin_date VARCHAR(100),
    end_date VARCHAR(100),
    county_name VARCHAR(100),
    type_of_control VARCHAR(50),
    hours_type VARCHAR(100),
    productive_hours DECIMAL(12,2),
    productive_hours_per_adjusted_patient_day DECIMAL(6,2)
);
Key Metrics Captured

Hospital facility details

County and control type

Productive hours

Productivity per adjusted patient day

🧹 Data Cleaning Process

To ensure data accuracy and reliability, the following cleaning steps were applied:

DELETE FROM Hospital_Stats
WHERE year IS NULL
   OR facility_number IS NULL
   OR facility_name IS NULL
   OR begin_date IS NULL
   OR end_date IS NULL
   OR county_name IS NULL
   OR type_of_control IS NULL
   OR hours_type IS NULL
   OR productive_hours IS NULL
   OR productive_hours_per_adjusted_patient_day IS NULL
   OR TRIM(facility_name) = ''
   OR TRIM(county_name) = ''
   OR TRIM(type_of_control) = ''
   OR TRIM(hours_type) = '';


✔ Ensures all analytical queries operate on complete and valid records.

🔍 Basic Query Operations
Alameda County Hospitals
SELECT facility_name, county_name, type_of_control
FROM hospital_stats
WHERE county_name = 'Alameda';

2009 Productivity Totals
SELECT 
    facility_name,
    year,
    SUM(productive_hours) AS total_productive_hours
FROM hospital_stats
WHERE year = 2009
GROUP BY facility_name, year;

Control Types
SELECT DISTINCT type_of_control
FROM hospital_stats;

📊 Aggregation & Ranking Analysis
Average Productive Hours by Type
SELECT 
    hours_type,
    productive_hours_per_adjusted_patient_day,
    AVG(productive_hours) AS avg_productive_hours
FROM hospital_stats
GROUP BY hours_type, productive_hours_per_adjusted_patient_day;

Top 5 Hospitals by Productive Hours
SELECT facility_name, productive_hours
FROM hospital_stats
ORDER BY productive_hours DESC
LIMIT 5;

🌍 County-Level Analysis
Productive Hours by Control Type
SELECT 
    type_of_control,
    SUM(productive_hours) AS total_productive_hours
FROM hospital_stats
GROUP BY type_of_control;

Hospital Rankings
SELECT 
    facility_name,
    county_name,
    RANK() OVER (PARTITION BY productive_hours) AS rnk_productive_hours
FROM hospital_stats;

📈 Comparative Analysis
Difference from County Average
SELECT 
    facility_name,
    county_name,
    productive_hours -
    AVG(productive_hours) OVER (PARTITION BY facility_name, county_name)
    AS difference_productive_hours
FROM hospital_stats;

📅 Yearly Growth Analysis
Year-over-Year Growth in Productive Hours
WITH YearlyGrowth AS (
    SELECT 
        facility_name,
        year,
        SUM(productive_hours) AS total_productive_hours,
        LAG(SUM(productive_hours)) OVER (
            PARTITION BY facility_name ORDER BY year
        ) AS prev_year_hours
    FROM Hospital_Stats
    GROUP BY facility_name, year
)
SELECT 
    facility_name,
    year,
    total_productive_hours,
    prev_year_hours,
    (total_productive_hours - prev_year_hours) AS growth_in_hours
FROM YearlyGrowth
WHERE prev_year_hours IS NOT NULL
ORDER BY facility_name, year;

⭐ Advanced Subquery Analysis
Above-Average Performing Hospitals
SELECT 
    facility_name,
    county_name,
    SUM(productive_hours) AS total_productive_hours
FROM Hospital_Stats
GROUP BY facility_name, county_name
HAVING SUM(productive_hours) >
(
    SELECT AVG(total_productive_hours)
    FROM (
        SELECT facility_name,
               SUM(productive_hours) AS total_productive_hours
        FROM Hospital_Stats
        GROUP BY facility_name
    ) AS avg_calc
)
ORDER BY total_productive_hours DESC;

🔑 Key Insights

Robust Data Management: Strong data cleaning ensures analytical accuracy

Multi-Level Analysis: Facility, county, control type, and yearly comparisons

Healthcare Productivity Focus: Productive hours enable benchmarking

Comparative Intelligence: Rankings and growth metrics support management decisions

🛠️ Tools & Technologies

SQL

Window Functions

Common Table Expressions (CTEs)

Aggregations & Subqueries

🚀 Future Enhancements

Power BI dashboard integration

Predictive productivity modeling

Staffing optimization analysis

Cost vs productivity correlation



# Hospital_Stafing_Analysis
