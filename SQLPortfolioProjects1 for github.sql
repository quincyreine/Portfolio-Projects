
***just checking initial data
Select * 
From [Portfolio Projects].dbo.CovidDeaths
order by 3,4

Select * 
From [Portfolio Projects].dbo.CovidVaccinations
order by 3,4

***Select Data we will be using

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Projects].dbo.CovidDeaths
order by 1,2


-- Looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Projects].dbo.CovidDeaths
order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Projects].dbo.CovidDeaths
Where Location like '%philippines%'
and total_cases is not null
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
Select Location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
From [Portfolio Projects].dbo.CovidDeaths
Where Location like '%philippines%'
order by 1,2

-- Countries with Highest Infection Rate compared to Population
Select Location, population, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Projects].dbo.CovidDeaths
Where Location like '%philippines%'
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, population, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Projects].dbo.CovidDeaths
Where Location like '%philippines%'
Group by Location, Population
order by 1,2

Select Location, population, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Projects].dbo.CovidDeaths
Where Location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as bigint)) as TotalDeathCount
From [Portfolio Projects].dbo.CovidDeaths
Group by Location, Population
order by TotalDeathCount desc

Select * 
From [Portfolio Projects].dbo.CovidDeaths
where continent is not null
order by 3,4

Select Location, MAX(cast(Total_deaths as bigint)) as TotalDeathCount
From [Portfolio Projects].dbo.CovidDeaths
where continent is not null
Group by Location, Population
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as bigint)) as TotalDeathCount
From [Portfolio Projects].dbo.CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

Select continent, MAX(cast(Total_deaths as bigint)) as TotalDeathCount
From [Portfolio Projects].dbo.CovidDeaths
where continent is null
Group by continent
order by TotalDeathCount desc

--Select continent, MAX(cast(Total_deaths as bigint)) as TotalDeathCount
--From [Portfolio Projects].dbo.CovidDeaths
--where continent is null
--Group by location
--order by TotalDeathCount desc
-- ^ dapat select location not continent for it to work

Select location, MAX(cast(Total_deaths as bigint)) as TotalDeathCount
From [Portfolio Projects].dbo.CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc

Select location, MAX(cast(Total_deaths as bigint)) as TotalDeathCount
From [Portfolio Projects].dbo.CovidDeaths
Where continent is null
Group by location
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(new_cases), total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Projects].dbo.CovidDeaths
Where continent is not null
Group by date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio Projects].dbo.CovidDeaths
where continent is not null 
Group By date
order by 1,2

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio Projects].dbo.CovidDeaths
where continent is not null 
Group By date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio Projects].dbo.CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


Select * 
From [Portfolio Projects].dbo.CovidVaccinations

-- Looking at Total Population vs Vaccinations
Select * 
From [Portfolio Projects].dbo.CovidDeaths dea
Join [Portfolio Projects].dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From [Portfolio Projects].dbo.CovidDeaths dea
Join [Portfolio Projects].dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(Cast(vac.new_vaccinations as bigint)) OVER 
 (Partition by dea.Location Order by dea.location,dea.Date)
From [Portfolio Projects].dbo.CovidDeaths dea
Join [Portfolio Projects].dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(Cast(vac.new_vaccinations as bigint)) OVER 
 (Partition by dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
 ,(RollingPeopleVaccinated/population)*100
From [Portfolio Projects].dbo.CovidDeaths dea
Join [Portfolio Projects].dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- USE CTE
 
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Projects].dbo.CovidDeaths dea
Join [Portfolio Projects].dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- USE Temp Table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Projects].dbo.CovidDeaths dea
Join [Portfolio Projects].dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Projects].dbo.CovidDeaths dea
Join [Portfolio Projects].dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select *
From PercentPopulationVaccinated