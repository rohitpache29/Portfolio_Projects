Select * 
from PortfolioProject..Covid_deaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..Covid_Vaccination
--order by 3,4

--selecting the data that i am going to be using

Select location,date,total_cases,new_cases,population
from PortfolioProject..Covid_deaths
where continent is not null
order by 1,2

--looking at total cases vs total deaths
--shows likehood fo dying percentage in india

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 As death_percentage
from PortfolioProject..Covid_deaths
where location like '%india%'
and continent is not null
order by 1,2

--looking at total cases and population
--shows what percentage of population got covid

select location,date,total_cases,population,  (total_cases/population)*100 As Percentage_Population_infection
from PortfolioProject..Covid_deaths
--where location like '%india%'
where continent is not null
order by 1,2

--Looking at Countries with Highest Infection Rate compare to Population

select location,population,max(total_cases)as highest_infection_count,Max((total_cases/population))*100 As Percent_Population_Infected
from PortfolioProject..Covid_deaths
--where location like '%india%'
group by population,location
order by Percent_Population_Infected desc


--Showing Countries with Highest Death Count Population
Select location, MAX(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject..Covid_deaths
where continent is not null
group by location
order by totaldeathcount desc


--Let's break things duwn by continent

Select continent, MAX(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject..Covid_deaths
where continent is not null
group by continent
order by totaldeathcount desc

--Global Numbers

Select sum(new_cases)as TotalCases,sum(cast(new_deaths as int))as TotalDeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..Covid_deaths
where continent is not null
--group by date
order by 1,2

--Covid Vaccination

--looking at total population and vaccinations

with PopvsVac (continent,location,date, population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations  as bigint)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid_deaths dea
join PortfolioProject..Covid_Vaccination vac
   on dea.date = vac.date
   and dea.location = vac.location
where dea.continent is not null
--order by 2,3
)
select * ,(RollingPeopleVaccinated/population)*100
from PopvsVac



--temp table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(225),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric,
)



Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations  as bigint)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid_deaths dea
join PortfolioProject..Covid_Vaccination vac
   on dea.date = vac.date
   and dea.location = vac.location
where dea.continent is not null
--order by 2,3

select * ,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--Creating view to store data for later visulalizations

Create view PercentPopulationVaccinated as 
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations  as bigint)) OVER (Partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid_deaths dea
join PortfolioProject..Covid_Vaccination vac
   on dea.date = vac.date
   and dea.location = vac.location
where dea.continent is not null
--order by 2,3

select * 
from PercentPopulationVaccinated