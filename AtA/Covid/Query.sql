/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [PortafolioAA]..[CovidVaccinations]
  ORDER BY  'date','location'
 
 SELECT location, date, total_cases,new_cases,total_deaths,population
  FROM [PortafolioAA]..[CovidDeaths]
    ORDER BY  'location','date'

--total cases vs deaths, where country rhymes with Chile
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as 'death_rate%'
  FROM [PortafolioAA]..[CovidDeaths]
  WHERE location like '%hile'
    ORDER BY  'location','date'

--% of infected pop,in SouthAm
SELECT location, date, total_cases,population, (total_cases/population)*100 as 'contagion_rate%'
  FROM [PortafolioAA]..[CovidDeaths]
  WHERE continent like 'South America'
    ORDER BY  'location','date'


-- highest infection rate countries, per population
SELECT location,population,CASE WHEN  max(total_cases) IS NOT NULL THEN max(total_cases) ELSE 0 END as HighestInfectionCount, CASE WHEN  max((total_cases/population)) IS NOT NULL THEN max((total_cases/population))*100 ELSE 0 END as 'PercentPopulationInfected'
  FROM [PortafolioAA]..[CovidDeaths]
  --WHERE continent like 'South America'
GROUP BY location, population
    ORDER BY 'PercentPopulationInfected' desc


-- highest infection rate countries, per population, by date
SELECT location,population,date,CASE WHEN  max(total_cases) IS NOT NULL THEN max(total_cases) ELSE 0 END as HighestInfectionCount, CASE WHEN  max((total_cases/population)) IS NOT NULL THEN max((total_cases/population))*100 ELSE 0 END as 'PercentPopulationInfected'
  FROM [PortafolioAA]..[CovidDeaths]
  --WHERE continent like 'South America'
GROUP BY location, population,date
    ORDER BY 'PercentPopulationInfected' desc

--highest death count :(
SELECT location, max(total_deaths) as TotalDeathCount--no need to MAX(cast(total_deaths as int)) because I already did it
  FROM [PortafolioAA]..[CovidDeaths]
  WHERE continent is NOT NULL
GROUP BY location, population
    ORDER BY  'TotalDeathCount' desc

	--highest death count :(
	--we can't group by by continent, otherwise it will also take the max of the continent and take only one country
SELECT continent, max(total_deaths) as TotalDeathCount--no need to MAX(cast(total_deaths as int)) because I already did it
  FROM [PortafolioAA]..[CovidDeaths]
  WHERE continent is not NULL
GROUP BY continent
    ORDER BY  'TotalDeathCount' desc

	--check the difference
SELECT location, max(total_deaths) as TotalDeathCount--no need to MAX(cast(total_deaths as int)) because I already did it
  FROM [PortafolioAA]..[CovidDeaths]
  WHERE continent is NULL
GROUP BY location
    ORDER BY  'TotalDeathCount' desc

--world deaths by date
--SELECT date, total_cases,total_deaths,(total_deaths/total_cases)*100 as 'death_rate%' --will give error, because total_cases is not aggregated. We can SUM the new_cases. Alex tried to make SUM(MAX(total_cases)), which would give the sum of the latest account of total_cases per country
SELECT date, sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,CASE WHEN sum(new_cases)!=0 THEN 100*sum(new_deaths)/sum(new_cases)  ELSE 0 END as 'death_rate%'--,(total_deaths/total_cases)*100 as 'death_rate%'
  FROM [PortafolioAA]..[CovidDeaths]
  WHERE continent is NULL
  GROUP BY date
ORDER BY date--,total_cases

--deaths till downloading the data
SELECT sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,CASE WHEN sum(new_cases)!=0 THEN 100*sum(new_deaths)/sum(new_cases)  ELSE 0 END as 'DeathPercentage'--,(total_deaths/total_cases)*100 as 'death_rate%'
  FROM [PortafolioAA]..[CovidDeaths]
  WHERE continent is NOT NULL


--this is also a correct answer
SELECT top(1) location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as 'death_rate%'
  FROM [PortafolioAA]..[CovidDeaths]
  WHERE location like 'World' and total_cases is not NULL
    ORDER BY  'date' desc

 
 --this one is correct, too
 select location, MAX(total_deaths) as TotalDeathCount
 FROM [PortafolioAA]..[CovidDeaths]
 where continent is null 
 group by location

 --death count by continent
  select continent, MAX(total_deaths) as TotalDeathCount
 FROM [PortafolioAA]..[CovidDeaths]
 where continent is not null
 group by continent

 --another take
  SELECT location, MAX(total_deaths) AS TotalDeathCount
 FROM [PortafolioAA]..[CovidDeaths]
WHERE continent is null AND location not in ('World', 'International','European Union') and location not like '%income'
 GROUP BY location
ORDER BY TotalDeathCount DESC


  --death count world
  SELECT CASE WHEN continent is not NULL then continent ELSE 'World' END AS 'location', MAX(total_deaths) as TotalDeathCount
 FROM [PortafolioAA]..[CovidDeaths]
where location like 'World'
 group by continent


UPDATE [PortafolioAA]..[CovidVaccinations] SET date = CONVERT(Date, date, 21);
alter table [PortafolioAA]..[CovidVaccinations] alter column date datetime2
 --SELECT CAST(date as datetime2) FROM PortafolioAA..CovidVaccinations
 select date from PortafolioAA..CovidVaccinations
 SELECT CONVERT(nvarchar(50),date,21) FROM PortafolioAA..CovidVaccinations
 SELECT date FROM PortafolioAA..CovidDeaths

 --NOW, VACCINATIONS
 SELECT dea.date,dea.continent, dea.location, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated--important to order by, so it knows where to sum
 FROM PortafolioAA..CovidDeaths dea
 JOIN PortafolioAA..CovidVaccinations vac
 ON dea.location=vac.location
  AND dea.date=vac.date
WHERE dea.continent is not null-- and dea.location like 'Albania'



 --CTE: temporal expression
 WITH PopvsVacc (Continent, Location, Population, Vaccinations, RollingPeopleVaccinated)
 as
 (
 SELECT dea.continent, dea.location, dea.population, vac.new_vaccinations
,SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) --as RollingPeopleVaccinated--important to order by, so it knows where to sum

FROM PortafolioAA..CovidDeaths dea
 JOIN PortafolioAA..CovidVaccinations vac
 ON dea.location=vac.location
  AND dea.date=vac.date
WHERE dea.continent is not null-- and dea.location like 'Albania'

)
SELECT *,100*RollingPeopleVaccinated/Population as 'Rate of Vaccination'
FROM PopvsVacc



--TEMPorary table
DROP TABLE IF EXISTS #PopVaccinated
CREATE TABLE #PopVaccinated
(
Continent nvarchar(50),Location nvarchar(max),date datetime,
Population numeric, New_vaccinations numeric, RollingPeopleVaccinated numeric
)

INSERT INTO #PopVaccinated

 SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) --as RollingPeopleVaccinated--important to order by, so it knows where to sum

FROM PortafolioAA..CovidDeaths dea
 JOIN PortafolioAA..CovidVaccinations vac
 ON dea.location=vac.location
  AND dea.date=vac.date
WHERE dea.continent is not null-- and dea.location like 'Albania'

SELECT *,100*RollingPeopleVaccinated/Population as 'Rate of Vaccination'
FROM #PopVaccinated
--WHERE location like '%Congo'



--VIEW, but no temp views allowed :(
CREATE VIEW PerPopVacc AS

 SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated--important to order by, so it knows where to sum

FROM PortafolioAA..CovidDeaths dea
 JOIN PortafolioAA..CovidVaccinations vac
 ON dea.location=vac.location
  AND dea.date=vac.date
WHERE dea.continent is not null