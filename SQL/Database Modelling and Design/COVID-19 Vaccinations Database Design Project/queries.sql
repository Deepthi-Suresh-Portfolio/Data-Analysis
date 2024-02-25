--Task D1
SELECT l.location AS "Country Name (CN)",total_vaccinations AS "Total Vaccinations (administered to date)", 
         daily_vaccinations AS "Daily Vaccinations",date AS Date
FROM vaccination v1
JOIN locations l
    ON v1.iso_code = l.iso_code
        JOIN
            (SELECT avg(daily_vaccinations) as average,date
            FROM vaccination 
            GROUP BY date)v2
                ON v1.date = v2.date
WHERE v1.daily_vaccinations > average;

--Task D2  
SELECT location AS Country, sum(daily_vaccinations)AS "Cumulative Doses"
FROM vaccination
JOIN Locations 
    ON Locations.iso_code=vaccination.iso_code
WHERE location IS NOT NULL
GROUP BY vaccination.iso_code
HAVING sum(daily_vaccinations) > (
    SELECT avg(sum_daily_vaccinations) 
    FROM(
        SELECT sum(daily_vaccinations) AS sum_daily_vaccinations
        FROM vaccination
        JOIN Locations 
            ON Locations.iso_code=vaccination.iso_code
        WHERE location IS NOT NULL
        GROUP BY Locations.iso_code));


--Task D3 
SELECT location AS Country, vaccines AS "Vaccine Type"
FROM Vaccinebyloc v
JOIN locations l
    ON v.iso_code = l.iso_code;

--task D4
SELECT location AS Country,source_website AS "Source Name (URL)",max(total_vaccinations) AS "Biggest total Administered Vaccines"
FROM Vaccinebyloc vl
JOIN vaccination v1
    ON vl.iso_code = v1.iso_code
        JOIN locations l
            ON l.iso_code = v1.iso_code
GROUP BY v1.iso_code, source_website
ORDER BY source_website;

--task D5
SELECT
    strftime('%Y', Date) || '-' ||
    substr('0' || (strftime('%W', Date) + 1), -2) AS "Date Range (Weeks)",
    SUM(CASE WHEN iso_code = 'AUS' THEN people_fully_vaccinated ELSE 0 END) AS Australia,
    SUM(CASE WHEN iso_code = 'DEU' THEN people_fully_vaccinated ELSE 0 END) AS Germany,
    SUM(CASE WHEN iso_code = 'GBR' THEN people_fully_vaccinated ELSE 0 END) AS England,
    SUM(CASE WHEN iso_code = 'FRA' THEN people_fully_vaccinated ELSE 0 END) AS France
FROM Vaccination
WHERE Date >= '2021-01-01' AND Date <= '2022-12-31'
GROUP BY "Date Range (Weeks)"
ORDER BY "Date Range (Weeks)";
