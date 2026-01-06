use project;
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

-- Data Cleaning
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
   
   select* from hospital_stats;
   
   -- 1. List all hospitals located in Alameda county along with their type of control.
   select facility_name,county_name,type_of_control
   from hospital_stats
   where county_name='Alameda';
   
   -- 2. Find the total productive hours recorded by each hospital in 2009.
   select sum(productive_hours) as total_productive_hours, facility_name,year
   from hospital_stats
   where year = 2009
   group by facility_name,year;
   
   -- 3. Display distinct types of control present in the dataset.
   select distinct(type_of_control)
   from hospital_stats;
   
   -- 4. Calculate the average productive hours per adjusted patient day for each hours_type.
   select  productive_hours_per_adjusted_patient_day,hours_type, avg(productive_hours) as avg_productive_hours
   from hospital_stats
   group by productive_hours_per_adjusted_patient_day,hours_type;
   
   -- 5. Find the top 5 hospitals with the highest total productive hours across all years.
   select facility_name, productive_hours
   from hospital_stats
   order  by productive_hours desc
   limit 5;
   
   -- 6. For each county, find the total productive hours grouped by type_of_control.
   select  type_of_control, sum(productive_hours) as total_productive_hours
   from hospital_stats
   group by type_of_control;
   
   -- 7. Rank hospitals within each county based on total productive hours (highest to lowest).
   select facility_name, county_name,
   rank()over( partition by productive_hours) as rnk_productive_hours
   from hospital_stats;
   
   -- 8. Find the difference in productive hours between each hospital and the county average.
   select facility_name,county_name, 
   productive_hours- avg(productive_hours)over(partition by facility_name,county_name) as diffrence_productive_hours
   from hospital_stats;
   
   -- 9. Calculate the yearly growth in productive hours for each hospital (compare with previous year).
   WITH YearlyGrowth AS (
    SELECT 
        facility_name,
        year,
        SUM(productive_hours) AS total_productive_hours,
        LAG(SUM(productive_hours)) OVER (PARTITION BY facility_name ORDER BY year) AS prev_year_hours
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

-- 10. Use a subquery to find hospitals whose productive hours are above the overall average of all hospitals.
SELECT 
    facility_name,
    county_name,
    SUM(productive_hours) AS total_productive_hours
FROM Hospital_Stats
GROUP BY facility_name, county_name
HAVING SUM(productive_hours) > (
    SELECT AVG(total_productive_hours)
    FROM (
        SELECT 
            facility_name,
            SUM(productive_hours) AS total_productive_hours
        FROM Hospital_Stats
        GROUP BY facility_name
    ) AS avg_calc
)
ORDER BY total_productive_hours DESC;


   



    




   

