-- safe mode maha
SET SQL_SAFE_UPDATES = 0;


-- airports tabeli korda tegemine
-- nime vahetus airport name
SELECT * 
FROM test_proj.airport;

ALTER TABLE test_proj.airport
RENAME COLUMN name to airport_name;

-- nime vahetus City
SELECT * 
FROM test_proj.navaids;

ALTER TABLE test_proj.navaids
RENAME COLUMN name to City;

-- riigi nime columni vahetus
SELECT * 
FROM test_proj.countries;

ALTER TABLE test_proj.countries
RENAME COLUMN name to country;

-- nime vahetus name-region name column
SELECT * 
FROM test_proj.regions;

ALTER TABLE test_proj.regions
RENAME COLUMN name to region_name;


SELECT * 
FROM test_proj.runways;




-- uus tabel, joinid eelmiste vahel, insert uude tabelisse
DROP TABLE joined_cleaned;

CREATE TABLE joined_cleaned (
	id INT AUTO_INCREMENT PRIMARY KEY,
    airport_name VARCHAR(255),
    type VARCHAR(255),
    elevation_ft VARCHAR(255),
    continent VARCHAR(255),
    iso_country VARCHAR(255),
    iso_region VARCHAR(255),
    municipality VARCHAR(255),
    passengers_2021 INT,
    passengers_2022 INT,
    region_name VARCHAR(255),
    surface VARCHAR(255),
    country VARCHAR(255)
);

INSERT INTO joined_cleaned
SELECT  NULL, air.airport_name, air.type, air.elevation_ft, air.continent,
air.iso_country, air.iso_region, air.municipality, 
CASE WHEN air.passengers_2021 = '#N/A' THEN NULL ELSE CAST(air.passengers_2021 AS SIGNED) END,
CASE WHEN air.passengers_2022 = '#N/A' THEN NULL ELSE CAST(air.passengers_2022 AS SIGNED) END,
reg.region_name, run.surface , cnt.country
FROM test_proj.airport as air
LEFT JOIN test_proj.regions AS reg
ON air.iso_region = reg.code
LEFT JOIN test_proj.runways AS run
ON run.airport_ref=air.id
LEFT JOIN test_proj.countries AS cnt
ON reg.iso_country = cnt.code;


-- continent tulba nime muutus
SELECT *
FROM joined_cleaned;

SELECT DISTINCT continent 
FROM joined_cleaned;

UPDATE joined_cleaned
SET continent = CASE
    WHEN continent = 'NA' THEN 'North America'
    WHEN continent = 'SA' THEN 'South America'
    WHEN continent = 'OC' THEN 'Oceania'
    WHEN continent = 'AF' THEN 'Africa'
    WHEN continent = 'AN' THEN 'Antarctica'
    WHEN continent = 'EU' THEN 'Europe'
    WHEN continent = 'AS' THEN 'Asia'
    ELSE continent
END;

-- uus tulp
ALTER TABLE joined_cleaned
ADD COLUMN difference INT;

-- arvutuse tulemus uude tulpa
UPDATE joined_cleaned
SET difference = passengers_2021 - passengers_2022;

-- vaatame top 10 lennujaama reisijate arvu poolest mõlemal aastal
SELECT 
    airport_name, passengers_2021
FROM
    joined_cleaned
ORDER BY passengers_2021 DESC
LIMIT 10;

SELECT
    airport_name,
    passengers_2022
FROM
    joined_cleaned
ORDER BY
    passengers_2022 DESC
LIMIT
    10;
    














