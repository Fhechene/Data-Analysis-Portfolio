CREATE VIEW #PerPopVacc AS

 SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated--important to order by, so it knows where to sum

FROM PortafolioAA..CovidDeaths dea
 JOIN PortafolioAA..CovidVaccinations vac
 ON dea.location=vac.location
  AND dea.date=vac.date
WHERE dea.continent is not null