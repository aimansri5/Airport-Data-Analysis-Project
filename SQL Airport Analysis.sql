--Check total number of airports

SELECT COUNT(*) AS total_airports 
FROM airports_dataset


--Find the Top 5 Countries with the Most Major Airports
SELECT TOP 5 country, COUNT(*) AS major_airports
FROM airports_dataset
WHERE has_scheduled_service = 'YES' AND iata IS NOT NULL
GROUP BY country
ORDER BY major_airports DESC;

--Find the Highest Airport in Each Country
WITH RankedAirports AS (
    SELECT country, airport_name, elevation_ft,
           RANK() OVER (PARTITION BY country ORDER BY elevation_ft DESC) AS rank
    FROM airports_dataset
)
SELECT country, airport_name, elevation_ft
FROM RankedAirports
WHERE rank = 1;


--Proximity Analysis: Identifying the Closest Airport to Large Airports
SELECT a.airport_name AS regional_airport, 
       b.airport_name AS nearest_airport,
       (6371 * ACOS(LEAST(1, GREATEST(-1, 
             COS(RADIANS(a.latitude)) * COS(RADIANS(b.latitude)) 
             * COS(RADIANS(b.longitude) - RADIANS(a.longitude)) 
             + SIN(RADIANS(a.latitude)) * SIN(RADIANS(b.latitude))
       )))) AS distance_km
FROM airports_dataset a
CROSS APPLY (
    SELECT TOP 1 b.airport_name, b.latitude, b.longitude
    FROM airports_dataset b
    WHERE a.airport_id <> b.airport_id
    ORDER BY (6371 * ACOS(LEAST(1, GREATEST(-1, 
              COS(RADIANS(a.latitude)) * COS(RADIANS(b.latitude)) 
              * COS(RADIANS(b.longitude) - RADIANS(a.longitude)) 
              + SIN(RADIANS(a.latitude)) * SIN(RADIANS(b.latitude))
    ))))
) b
WHERE a.airport_type = 'Large_Airport';


--Identify Airports Near Country Borders (for International Expansion)
WITH BorderAirports AS (
    SELECT a.airport_name, a.country, a.latitude, a.longitude,
           b.country AS neighbor_country,
           (6371 * ACOS(COS(RADIANS(a.latitude)) * COS(RADIANS(b.latitude)) 
                        * COS(RADIANS(b.longitude) - RADIANS(a.longitude)) 
                        + SIN(RADIANS(a.latitude)) * SIN(RADIANS(b.latitude)))) AS distance_km
    FROM airports_dataset a
    JOIN airports_dataset b ON a.country <> b.country
    WHERE (6371 * ACOS(COS(RADIANS(a.latitude)) * COS(RADIANS(b.latitude)) 
                        * COS(RADIANS(b.longitude) - RADIANS(a.longitude)) 
                        + SIN(RADIANS(a.latitude)) * SIN(RADIANS(b.latitude)))) < 80 -- Within 80 km of border
)
SELECT airport_name, country, neighbor_country, distance_km
FROM BorderAirports;

--Find airports that have no scheduled passenger service
SELECT airport_name, country, iata,
       CASE WHEN has_scheduled_service = 'NO' 
	   THEN 'Ghost Airport' 
	   ELSE 'Active' 
	   END AS status
FROM airports_dataset
WHERE has_scheduled_service = 'NO';


--Airports with the Most Flight Connections (Nearby Airports Count)
WITH Connectivity AS (
    SELECT TOP 10 a.airport_name, a.country,
           COUNT(b.airport_name) AS nearby_airports
    FROM airports_dataset a
    JOIN airports_dataset b ON 
        (3959 * ACOS(COS(RADIANS(a.latitude)) * COS(RADIANS(b.latitude)) 
                     * COS(RADIANS(b.longitude) - RADIANS(a.longitude)) 
                     + SIN(RADIANS(a.latitude)) * SIN(RADIANS(b.latitude)))) < 200
    GROUP BY a.airport_name, a.country
)
SELECT airport_name, country, nearby_airports
FROM Connectivity
ORDER BY nearby_airports DESC

--Rank countries based on total airport count
SELECT country, COUNT(*) AS total_airports
FROM airports_dataset
GROUP BY country
ORDER BY total_airports DESC;


-- Flight Route Possibilities (Direct Route Feasibility)
SELECT a.airport_name AS source_airport, 
       a.country AS country, 
       b.airport_name AS destination_airport, 
       b.country AS country,
       (6371 * ACOS(COS(RADIANS(a.latitude)) * COS(RADIANS(b.latitude)) 
                    * COS(RADIANS(b.longitude) - RADIANS(a.longitude)) 
                    + SIN(RADIANS(a.latitude)) * SIN(RADIANS(b.latitude)))) AS distance_km
FROM airports_dataset a
JOIN airports_dataset b ON a.airport_id <> b.airport_id
WHERE a.airport_type = 'large_airport' 
AND b.airport_type = 'large_airport'
AND (6371 * ACOS(COS(RADIANS(a.latitude)) * COS(RADIANS(b.latitude)) 
                 * COS(RADIANS(b.longitude) - RADIANS(a.longitude)) 
                 + SIN(RADIANS(a.latitude)) * SIN(RADIANS(b.latitude)))) 
    BETWEEN 500 AND 1000
ORDER BY 1;





