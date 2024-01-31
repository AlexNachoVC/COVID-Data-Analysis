SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddata.coviddeaths
ORDER BY 1, 2;

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in a certain country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage 
FROM coviddata.coviddeaths
WHERE location like '%Mexico%'
ORDER BY 1, 2;


-- Looking at Total Cases vs Population 
-- Shows what percentage of population got COVID

SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectionPercentage 
FROM coviddata.coviddeaths
-- WHERE location like '%Mexico%'
ORDER BY 1, 2;


-- Looking at Countries with Highest Infection Rate compared to Population

SELECT location, MAX(total_cases) AS HighestInfectionCount, population, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM coviddata.coviddeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected desc;


-- Showing Countries with Highest Death Count per Population

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM coviddata.coviddeaths
WHERE continent is not NULL
GROUP BY location
ORDER BY TotalDeathCount desc;


-- Showing Continents, and Income Sectors with Highest Death Count per Population

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM coviddata.coviddeaths
WHERE continent is NULL
GROUP BY location
ORDER BY TotalDeathCount desc;


-- Global Numbers

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM coviddata.coviddeaths
WHERE continent is not null
-- GROUP BY date
ORDER BY 1,2;


-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM coviddata.covidvaccinations vac
JOIN coviddata.coviddeaths dea
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3;


-- Use CTE

WITH POPvsVAC (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM coviddata.covidvaccinations vac
JOIN coviddata.coviddeaths dea
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null
-- ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS RollingPeopleVaccinatedPercentage FROM POPvsVAC;


-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM coviddata.covidvaccinations vac
JOIN coviddata.coviddeaths dea
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null;


SELECT * FROM PercentPopulationVaccinated