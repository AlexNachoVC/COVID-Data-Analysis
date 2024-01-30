-- Check if there are some NULL values.
SELECT COUNT(*)
FROM `coviddata`.`coviddeaths`
WHERE `weekly_hosp_admissions_per_million` IS NULL;

-- Check if there are empty values.
SELECT COUNT(*)
FROM `coviddata`.`coviddeaths`
WHERE `weekly_hosp_admissions_per_million` = '';

-- Update the empty values to NULL values, to be able to change the data type.
UPDATE `coviddata`.`coviddeaths`
SET `weekly_hosp_admissions_per_million` = NULL
WHERE `weekly_hosp_admissions_per_million` = '';

-- Confirm that there are no more empty values.
SELECT COUNT(*)
FROM `coviddata`.`coviddeaths`
WHERE `weekly_hosp_admissions_per_million` = '';

-- After changing the empty values to NULL, and confirming there are no more empty values; proceed to change the data type of the column from TEXT, to the needed type.
ALTER TABLE `coviddata`.`coviddeaths` 
MODIFY COLUMN `weekly_hosp_admissions_per_million` FLOAT NULL;



-- Do the next line first, if needed.
SET SQL_SAFE_UPDATES = 0;
