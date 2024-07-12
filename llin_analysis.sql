-- Create a new database named 'llin_analysis'
CREATE DATABASE llin_analysis; 

-- Select the 'llin_analysis' database for use
USE llin_analysis;

-- Create a table named 'llin_distribution' with appropriate columns and data types
CREATE TABLE llin_distribution (
    ID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each record
    Number_distributed INT,             -- The number of LLINs distributed
    Location VARCHAR(255),              -- The specific location where the LLINs were distributed
    Country VARCHAR(255),               -- The country where the distribution took place
    Period VARCHAR(255),                -- The period during which the distribution occurred (stored as a string)
    By_Whom VARCHAR(255),               -- The organization responsible for the distribution
    Country_code INT                    -- The ISO code of the country
);

-- Select all records from the 'llin_distribution' table to verify data
SELECT * FROM llin_analysis.llin_distribution;

# Descriptive Statistics Section
-- Calculate the total number of LLINs distributed in each country
SELECT Country, SUM(Number_distributed) AS Total_LLINS
FROM llin_distribution
GROUP BY Country;

-- Calculate the average number of LLINs distributed per distribution event
SELECT AVG(Number_distributed) AS Average_LLINS_Per_Event
FROM llin_distribution;

-- Find the earliest and latest distribution date by converting the 'Period' string to a date and getting the minimum value
WITH DateStats AS (
    SELECT
        MIN(STR_TO_DATE(Period, '%Y-%m-%d')) AS Earliest_Distribution_Date,
        MAX(STR_TO_DATE(Period, '%Y-%m-%d')) AS Latest_Distribution_Date
    FROM llin_distribution
)
SELECT Earliest_Distribution_Date, Latest_Distribution_Date
FROM DateStats;


#Trends and Patterns Section
-- Calculate the total number of LLINs distributed by each organization
SELECT By_Whom, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY By_Whom;

-- Calculate the total number of LLINs distributed in each year
-- Convert the 'Period' string to a date and extract the year
SELECT YEAR(STR_TO_DATE(Period, '%Y-%m-%d')) AS Year, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Year;

# Volume Insights Section
-- Find the location with the highest number of LLINs distributed
SELECT Location, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Location
ORDER BY Total_LLINS_Distributed DESC
LIMIT 1;

-- Find the location with the lowest number of LLINs distributed
SELECT Location, SUM(Number_distributed) AS Total_LLINS_Distributed
FROM llin_distribution
GROUP BY Location
ORDER BY Total_LLINS_Distributed ASC
LIMIT 1;

-- Calculate variance and standard deviation of LLINs distributed by each organization
SELECT By_Whom,
       AVG(Number_distributed) AS Avg_LLINS_Distributed,  -- Calculate the average number of LLINs distributed
       VARIANCE(Number_distributed) AS Var_LLINS_Distributed,  -- Calculate the variance of LLINs distributed
       STDDEV(Number_distributed) AS StdDev_LLINS_Distributed  -- Calculate the standard deviation of LLINs distributed
FROM llin_distribution
GROUP BY By_Whom;

# Identifying Extremes Section
-- Calculate summary statistics (mean and standard deviation) by location
SELECT *,
       (Number_distributed - AVG(Number_distributed) OVER(PARTITION BY Location ORDER BY Period)) / STDDEV(Number_distributed) OVER(PARTITION BY Location ORDER BY Period) AS Z_Score
FROM llin_distribution;

SELECT Location, VAR_SAMP(Number_distributed) AS Variance_LLINS_Distributed
FROM llin_distribution
GROUP BY Location
ORDER BY Variance_LLINS_Distributed DESC;

-- Extract data for visual inspection
SELECT Location, Period, Number_distributed
FROM llin_distribution
ORDER BY Location, Period;
