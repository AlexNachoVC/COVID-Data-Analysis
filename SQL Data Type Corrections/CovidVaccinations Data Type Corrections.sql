-- Check if there are some NULL values.
SELECT COUNT(*)
FROM `coviddata`.`covidvaccinations`
WHERE `excess_mortality_cumulative_per_million` IS NULL;

-- Check if there are empty values.
SELECT COUNT(*)
FROM `coviddata`.`covidvaccinations`
WHERE `excess_mortality_cumulative_per_million` = '';

-- Update the empty values to NULL values, to be able to change the data type.
UPDATE `coviddata`.`covidvaccinations`
SET `excess_mortality_cumulative_per_million` = NULL
WHERE `excess_mortality_cumulative_per_million` = '';

-- Confirm that there are no more empty values.
SELECT COUNT(*)
FROM `coviddata`.`covidvaccinations`
WHERE `excess_mortality_cumulative_per_million` = '';

-- After changing the empty values to NULL, and confirming there are no more empty values; proceed to change the data type of the column from TEXT, to the needed type.
ALTER TABLE `coviddata`.`covidvaccinations` 
MODIFY COLUMN `excess_mortality_cumulative_per_million` FLOAT NULL;


