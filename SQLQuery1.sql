SELECT *
From PortfolioProject..CovidDeaths
where continent is not null
ORDER BY 3,4;



SELECT *
FROM PortfolioProject..CovidVaccination
ORDER BY 3,4;

-- Select Data that I am going to use
Select Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths  Order by 1,2;


--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths  
Order by 1,2
--WHERE location like '%india%' ORDER BY total_cases DESC;



--Looking at Total Cases vs Population
--Shows what percentage of population got Covid
Select Location, date, total_cases, new_cases, population, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths  
--WHERE location like '%Germany%' ORDER BY total_cases DESC;


--Looking at Countries with Highest Infection rate compare to Population
Select Location, max(total_cases) as HigestInfectionCount, population, Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
Group by location, population
Order by PercentPopulationInfected desc;  




--Showing Countries with  Higest Death Count per Population
SELECT Location, Max(cast(Total_deaths as bigint)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by Location 
Order by TotalDeathCount desc;

--For contineent
SELECT continent, Max(cast(Total_deaths as bigint)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by continent
Order by TotalDeathCount desc;



--Global Numbers
Select date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as bigint))as total_deaths, SUM(cast(new_deaths as bigint)) 
/ sum(new_cases)* 100 as deathpercentage 
FROM PortfolioProject..CovidDeaths  
where continent is not null
Group by date
Order by 1,2

--Looking at Total Population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations , SUM(convert(bigint,vac.new_vaccinations)) 
Over (partition by dea.Location Order by dea.location, dea.date) as rollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location = vac. location
and dea.date= vac.date
where dea.continent is not null
Order by 2,3


-- using CTE
with popvsvac (continent, Location, Data, Population, New_vaccination, rollingPeopleVaccinated)as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations , SUM(convert(bigint,vac.new_vaccinations)) 
Over (partition by dea.Location Order by dea.location, dea.date) as rollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location = vac. location
and dea.date= vac.date
where dea.continent is not null
--Order by 2,3

)
select *, (rollingPeopleVaccinated/population)*100
from popvsvac



--Temp Table
Drop table if exists #percentPopulationVaccinated
Create Table #percentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccination numeric,
rollingPeopleVaccinated numeric
)

Insert into #percentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations , SUM(convert(bigint,vac.new_vaccinations)) 
Over (partition by dea.Location Order by dea.location, dea.date) as rollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location = vac. location
and dea.date= vac.date
--where dea.continent is not null
--Order by 2,3

select *, (rollingPeopleVaccinated/population)*100
From #percentPopulationVaccinated



-- creating View to store data for later visualizations

create view PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations , SUM(convert(bigint,vac.new_vaccinations)) 
Over (partition by dea.Location Order by dea.location, dea.date) as rollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location = vac. location
and dea.date= vac.date
where dea.continent is not null
--Order by 2,3

