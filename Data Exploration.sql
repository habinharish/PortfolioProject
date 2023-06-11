Select *
From PortfolioProject..DeathsCovid19$
Where continent is not null
order by 3,4


--Select Data that we are going to be using

Select Location,date,total_cases, new_cases,total_deaths, population
from PortfolioProject..DeathsCovid19$
Where continent is not null
Order by location ASC

--Looking at Total cases vs Total Deaths
--Shows percentage of dying at different Countries

select location, date, total_cases, total_deaths, 
    CONVERT(DECIMAL(18, 2), (CONVERT(DECIMAL(18, 2), total_deaths) / CONVERT(DECIMAL(18, 2), total_cases)))*100 as [DeathsOverTotal]
from PortfolioProject..DeathsCovid19$
where location like 'can%'
order by 1,2


--Total Cases vs Population. Convert(decimal(18,2) to change datatype nvarchar
--shows what percentage of population got Covid19

select location, date, total_cases, population, 
    CONVERT(DECIMAL(18, 2), (CONVERT(DECIMAL(18, 2), total_cases) / CONVERT(DECIMAL(18, 2), population)))*100 as [DeathsOverTotal]
from PortfolioProject..DeathsCovid19$
Where continent is not null
order by 1,2


---Looking at Countries with highest infection rate compared to population ( Casiting as datatype is nvarchar)
---What percentage its infected per Country

select location, population, 
	Max(total_cases) as HighestInfectionCount,
	Max ( Cast(total_cases /  population as int))*100 as percentPopulationInfected
    from PortfolioProject..DeathsCovid19$
	Where continent is not null
	group by location,population
	order by percentPopulationInfected desc

---showing Countries higest death count per population 

select location, population, 
	Max(total_deaths) as TotalDeathCount
	from PortfolioProject..DeathsCovid19$
	Where continent is not null
	group by location,population
	order by TotalDeathCount desc

 --Breaking Covid Death by Continent

 select continent, 
	Max(cast(total_deaths as int)) as TotalDeathCount
	from PortfolioProject..DeathsCovid19$
	--where location like '%canada'
	where continent is not Null
	group by continent
	order by TotalDeathCount desc


--Global Numbers

---by categoriezed by dates 

Select date,sum(new_cases) As SumofNewCases,sum(new_deaths) As SumofnewDeaths
from PortfolioProject..DeathsCovid19$
group by date
order by date



--JOINING TWO TABLES

--locating people for total population vs Vaccination

Select dea.continent,dea.location,dea.date,dea.population,va.new_vaccinations,
sum(convert(decimal,va.new_vaccinations ))over(partition by dea.Location order by dea.location,dea.date)as sumofvacination 
from PortfolioProject..DeathsCovid19$ dea
 join PortfolioProject..VaccinationCovid19$ va
on dea.location = va.location
and dea.date = va.date
WHERE DEA.continent IS NOT NULL and va.new_vaccinations is not null
ORDER BY 2,3 



--Use CTE 
--table to use alias table

with popvsvac (continent,location,date,population,new_vaccinations,Sumofvaccination)
as
(Select dea.continent,dea.location,dea.date,dea.population,va.new_vaccinations,
sum(convert(decimal,va.new_vaccinations ))over(partition by dea.Location order by dea.location,dea.date)as sumofvaccination 
from PortfolioProject..DeathsCovid19$ dea
 join PortfolioProject..VaccinationCovid19$ va
on dea.location = va.location
and dea.date = va.date
WHERE DEA.continent IS NOT NULL and va.new_vaccinations is not null
--ORDER BY 2,3 
)
Select * , (Sumofvaccination/population)*100 as percentofvaccine
from popvsvac


--Temp table

Drop table if exists #percentPopulationVaccination
Create table #percentPopulationVaccination
(continent nvarchar(255) null,
location nvarchar(255) ,
date datetime,
population nvarchar(255),
new_vaccinations numeric null,
Sumofvaccination numeric null
)

insert into #percentPopulationVaccination
Select dea.continent,dea.location,dea.date,dea.population,va.new_vaccinations,
sum(CONVERT(DECIMAL(18, 2),(CONVERT(DECIMAL(18, 2),va.new_vaccinations))))over(partition by dea.Location order by dea.location,dea.date)as sumofvaccination 
from PortfolioProject..DeathsCovid19$ dea
 join PortfolioProject..VaccinationCovid19$ va
on dea.location = va.location
and dea.date = va.date
--WHERE DEA.continent IS NOT NULL and va.new_vaccinations is not null
--ORDER BY 2,3 
Select * , (Sumofvaccination/population)*100 as percentofvaccine
from #percentPopulationVaccination



--create View to store data for later visualisations

Create view PercentpopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population,va.new_vaccinations,
sum(CONVERT(DECIMAL(18, 2),(CONVERT(DECIMAL(18, 2),va.new_vaccinations))))over(partition by dea.Location order by dea.location,dea.date)as sumofvaccination 
from PortfolioProject..DeathsCovid19$ dea
 join PortfolioProject..VaccinationCovid19$ va
on dea.location = va.location
and dea.date = va.date
WHERE DEA.continent IS NOT NULL and va.new_vaccinations is not null
--ORDER BY 2,3 


select *
from PercentpopulationVaccinated
