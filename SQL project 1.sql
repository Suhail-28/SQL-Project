Select * 
From PortfolioProject..CovidDeaths$
where continent IS NOT Null
order by 3,4

--Select * From PortfolioProject..CovidVaccinations$

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
where continent IS NOT Null
order by 1,2

-- Looking at the Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths$
where location like '%states%'
Order By 1, 2


-- Looking at Total Cases vs Population

Select location, date, total_cases, population, (total_cases/population)*100 AS ContractCasesPercentage
From PortfolioProject..CovidDeaths$
where location like '%states%'
Order By 1, 2


-- Looking at the countries at highest infectioin rate

Select location,population, MAX(total_cases) AS HighestInfection, MAX((total_cases/population)*100) AS ContractCasesPercentage
From PortfolioProject..CovidDeaths$
where continent IS NOT Null
Group By location, population
order by ContractCasesPercentage desc


-- Showing Countries with the Highest Death count per Population


Select location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent IS NOT Null
Group By location
order by TotalDeathCount desc


-- Sorting by Continent 


Select continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is Null
Group By continent
order by TotalDeathCount desc


-- Showing continents with the highest death count per population


Select continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is not Null
Group By continent
order by TotalDeathCount desc


-- Global numbers


Select date, SUM(new_cases) AS Total_cases , SUM(CAST(new_deaths AS INT)) AS Total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100  AS DeathPercentage
From PortfolioProject..CovidDeaths$
-- where location like '%states%'
where continent is not null
Group By date
Order By 1, 2


-- Use CTE


With Pop_vs_Vac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS(
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
   SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date)
   as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
Select *, (RollingPeopleVaccinated/population)*100
From Pop_vs_Vac


-- TEMP table

Drop Table if exists #PercentPopulationVaccinated 
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
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
   SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location 
   Order by dea.location, dea.date)
   as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View

Create View PercentPopulationVaccinated as 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
   SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date)
   as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null



Select * 
From PercentPopulationVaccinated


-- For visualization 

Select SUM(new_cases) AS Total_cases , SUM(CAST(new_deaths AS INT)) AS Total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100  AS DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
Order By 1, 2



Select location, SUM(CAST(total_deaths AS INT)) AS TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent IS Null
and location not in ('World', 'European Union', 'International')
Group By location
order by TotalDeathCount desc



Select location,population, MAX(total_cases) AS HighestInfection, MAX((total_cases/population)*100) AS ContractCasesPercentage
From PortfolioProject..CovidDeaths$
where continent IS NOT Null
Group By location, population
order by ContractCasesPercentage desc




Select location,date, population, MAX(total_cases) AS HighestInfection, MAX((total_cases/population)*100) AS ContractCasesPercentage
From PortfolioProject..CovidDeaths$
where continent IS NOT Null
Group By location, population, date
order by ContractCasesPercentage desc
