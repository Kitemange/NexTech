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
7. [Conclusion](#Conclusion)

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

##Conclusion

1. **Geographic Trends:**  
LLIN distribution varied significantly across regions. Northern Ghana received 1,093,700 LLINs in 2006, while Nord Ubangi and Kasaï Occidental in Congo saw over 1.3 million LLINs combined in the same year. Uganda had a major distribution in 2007, with over 12.7 million LLINs across its Western and Eastern regions. Zambia and Togo also had large distributions, with over 3 million and 2.4 million LLINs respectively. In contrast, some areas, like Namulonge, Uganda, received as few as 300 LLINs, highlighting disparities in distribution.

2. **Organizational Involvement:**  
Several organizations contributed to these LLIN efforts. National malaria control programs (NMCP) worked alongside groups like ERD, Rotary International, Concern Universal, and Red Cross chapters. For example, NMCP/ERD distributed 1,093,700 LLINs in Ghana’s Northern Region in 2006. IMA World Health and DFID supported efforts in Congo, while World Vision and other international NGOs played key roles in Zambia and Senegal. 

3. **Temporal Patterns:**  
There was a noticeable increase in LLIN distributions in 2007, especially in Uganda, which received over 12 million nets. Ghana, Malawi, and Congo also saw steady distributions in both 2006 and 2007, reflecting sustained efforts in malaria control. However, some regions still received lower amounts, indicating the need for further attention to close the gaps.
