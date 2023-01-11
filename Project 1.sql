Select *
From PortfolioProject..['Covid Admissions']
where continent is not null
order by 3,4

--Select *
--From PortfolioProject..['CovidVaccinations ']
--order by 3,4

--Select Location, date, total_cases, new_cases, total_deaths, population_density
--From PortfolioProject..['Covid Admissions']
--order by 1,2

----Comparing Total Cases to Total Deaths
--Shows likelihood of dying if you contract covid in Afghanistan
--Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PortfolioProject..['Covid Admissions']
--Where location like '%Afg%'
--order by 1,2


--Looking at Total Cases vs Population 
--Shows % of population that gotten covid

--Select Location, date, total_cases, population_density, (total_cases/population_density)*100 as DeathPercentage
--From PortfolioProject..['Covid Admissions']
--Order by 1, 2



-- Looking at Countries with Highest Infection Rate compared to Population

--Select Location, Max(total_cases) as HighestInfectionCount, population_density, Max((total_cases/population_density)*100) as PercentPopulationInfected
--From PortfolioProject..['Covid Admissions']
--Group by Location, population_density
--Order by PercentPopulationInfected desc


--Showing countries with the highest deathcount per pupulation

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..['Covid Admissions']
where continent is not null
Group by Location 
Order by TotalDeathCount desc

--Classify by Continent
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..['Covid Admissions']
where continent is not null
Group by continent
Order by TotalDeathCount desc


--Classify by location
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..['Covid Admissions']
where continent is not null
Group by Location 
Order by TotalDeathCount desc


--Showing continents with highest deathcount per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..['Covid Admissions']
where continent is not null
Group by continent
Order by TotalDeathCount desc




--Global Numbers (Cal everything across the entire world)

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..['Covid Admissions']
Where continent is not null
Group by date
order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, date, population, vac.new_vaccinations
,sum(convert(vac.new_vaccnations, int)) over (partition by dea.location, dea.Date)
as RollingPeopleVaccinated, (RollingPeopleVaccinated)/population_density*100
From PortfolioProject..['Covid Admissions dea']
Join PortfolioProject..CovidVaccinations vac
	On dea.Location = vac..location
	and dea.date = vac.date
where dea continent is not null
order by 2,3


--Use CTE

With PopsvsVac (Continent, Location,Data,Population_Density, New_Vaccinations,  RollingPeopleVaccinated) 
as 
(
Select dea.continent, dea.location, date, population, vac.new_vaccinations
,sum(convert(vac.new_vaccnations, int)) over (partition by dea.location, dea.Date)
as RollingPeopleVaccinated,
--(RollingPeopleVaccinated)/population_density*100
From PortfolioProject..['Covid Admissions dea']
Join PortfolioProject..CovidVaccinations vac
	On dea.Location = vac..location
	and dea.date = vac.date
where dea continent is not null
order by 2,3
)

Select *
From PopvsVac

--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table  #PercentPopulationVaccinated
(
Continennt nvarchar (225),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, date, population, vac.new_vaccinations
,sum(convert(vac.new_vaccnations, int)) over (partition by dea.location, dea.Date)
as RollingPeopleVaccinated
--(RollingPeopleVaccinated)/population_density*100
From PortfolioProject..['Covid Admissions dea']
Join PortfolioProject..CovidVaccinations vac
	On dea.Location = vac..location
	and dea.date = vac.date
--where dea continent is not null
order by 2,3

--Create Views to store data for visualisation


Create View as PercentPopulationVaccinated as

Select dea.continent, dea.location, date, population, vac.new_vaccinations
,sum(convert(vac.new_vaccnations, int)) over (partition by dea.location, dea.Date)
as RollingPeopleVaccinated
--(RollingPeopleVaccinated)/population_density*100
From PortfolioProject..['Covid Admissions dea']
Join PortfolioProject..CovidVaccinations vac
	On dea.Location = vac..location
	and dea.date = vac.date
where dea continent is not null
