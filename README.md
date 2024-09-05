---

# LLIN Distribution Analysis

This project performs an analysis of Long-Lasting Insecticidal Nets (LLIN) distribution across various locations and organizations. The aim is to provide insights into the distribution patterns, trends, and volume statistics.

## Table of Contents
1. [Project Setup](#project-setup)
2. [Database Schema](#database-schema)
3. [Descriptive Statistics](#descriptive-statistics)
4. [Trends and Patterns](#trends-and-patterns)
5. [Volume Insights](#volume-insights)
6. [Identifying Extremes](#identifying-extremes)

---

## Project Setup

1. Create a new database named `llin_analysis`:
   ```sql
   CREATE DATABASE llin_analysis;
   ```
   
2. Select the database:
   ```sql
   USE llin_analysis;
   ```

3. Create the `llin_distribution` table with the following schema:
   ```sql
   CREATE TABLE llin_distribution (
       ID INT AUTO_INCREMENT PRIMARY KEY,
       Number_distributed INT,
       Location VARCHAR(255),
       Country VARCHAR(255),
       Period VARCHAR(255),
       By_Whom VARCHAR(255),
       Country_code INT
   );
   ```

   ![Database schema visualization](https://via.placeholder.com/300)

---

## Descriptive Statistics

1. **Total LLINs Distributed by Country**:
   ```sql
   SELECT Country, SUM(Number_distributed) AS Total_LLINS
   FROM llin_distribution
   GROUP BY Country;
   ```

   This query calculates the total number of LLINs distributed in each country.

2. **Average Number of LLINs Distributed Per Event**:
   ```sql
   SELECT AVG(Number_distributed) AS Average_LLINS_Per_Event
   FROM llin_distribution;
   ```

   This query calculates the average number of LLINs distributed per event.

   ![Average LLINs chart](https://via.placeholder.com/300)

3. **Earliest and Latest Distribution Date**:
   ```sql
   WITH DateStats AS (
       SELECT MIN(STR_TO_DATE(Period, '%Y-%m-%d')) AS Earliest_Distribution_Date,
              MAX(STR_TO_DATE(Period, '%Y-%m-%d')) AS Latest_Distribution_Date
       FROM llin_distribution
   )
   SELECT Earliest_Distribution_Date, Latest_Distribution_Date
   FROM DateStats;
   ```

---

## Trends and Patterns

1. **Total LLINs Distributed by Each Organization**:
   ```sql
   SELECT By_Whom, SUM(Number_distributed) AS Total_LLINS_Distributed
   FROM llin_distribution
   GROUP BY By_Whom;
   ```

2. **Total LLINs Distributed per Year**:
   ```sql
   SELECT YEAR(STR_TO_DATE(Period, '%Y-%m-%d')) AS Year, SUM(Number_distributed) AS Total_LLINS_Distributed
   FROM llin_distribution
   GROUP BY Year;
   ```

   ![Yearly Distribution Trends](https://via.placeholder.com/300)

---

## Volume Insights

1. **Location with the Highest LLIN Distribution**:
   ```sql
   SELECT Location, SUM(Number_distributed) AS Total_LLINS_Distributed
   FROM llin_distribution
   GROUP BY Location
   ORDER BY Total_LLINS_Distributed DESC
   LIMIT 1;
   ```

2. **Location with the Lowest LLIN Distribution**:
   ```sql
   SELECT Location, SUM(Number_distributed) AS Total_LLINS_Distributed
   FROM llin_distribution
   GROUP BY Location
   ORDER BY Total_LLINS_Distributed ASC
   LIMIT 1;
   ```

---

## Identifying Extremes

1. **Summary Statistics by Location**:
   ```sql
   SELECT *,
       (Number_distributed - AVG(Number_distributed) OVER(PARTITION BY Location ORDER BY Period)) / STDDEV(Number_distributed) OVER(PARTITION BY Location ORDER BY Period) AS Z_Score
   FROM llin_distribution;
   ```

2. **Variance of LLIN Distribution by Location**:
   ```sql
   SELECT Location, VAR_SAMP(Number_distributed) AS Variance_LLINS_Distributed
   FROM llin_distribution
   GROUP BY Location
   ORDER BY Variance_LLINS_Distributed DESC;
   ```

---
