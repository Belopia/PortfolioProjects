-- Checking the info from the imported files

select *
from Portfolio1..covid_deaths$
order by 3, 4

-- Orders by location then orders those w/ same location by date

select *
from Portfolio1..covid_vacinations$
order by 3, 4

-- Same Order as covid_deaths$

-- Selecting the Data that I'll be using

select location, date, total_cases, new_cases, total_deaths, population_density
from Portfolio1..covid_deaths$
order by 1, 2

-- Realized that I didn't add in population but needed for the tutorial
  -- Debating on whether to fix excel or try to use the inner join 
  -- Need to find a way to give both excel sheets a primary key to link to each other
  -- Or try to base it off location and date
    -- Realized that they have same dates w/ same time so I can't use this method

-- Decided to just fix the excel sheet for now
select *
from Portfolio1..covid_deaths_fixed$
order by location, date

-- Using join to get them populations right!
select dea.location, dea.date, total_cases, new_cases, total_deaths, population
from Portfolio1..covid_vacinations$ vac
join Portfolio1..covid_deaths$ dea
	on dea.location = vac.location and 
	dea.date = vac.date
order by dea.location
-- So I managed to fix the excel sheet and also use the joins to get the missing population
-- Just placed this after finding out you can use and with joins


select location, date, total_cases, new_cases, total_deaths, population
from Portfolio1..covid_deaths_fixed$
order by location, date

-- Looking at the total cases vs total deaths
-- What's the percentage who died that had covid
  -- Likelihood of dying from covid in your country on a certain point of time/ day

select location, date, total_cases, total_deaths, (cast(total_deaths as int)/ cast(total_cases as int))*100 death_percentage
from Portfolio1..covid_deaths_fixed$
order by location, date
-- Using the cast(columnName as int) changes the values within the column as integers 
-- Realized that there's a problem with this code as death_percentage always outputs 0
  -- Tried changing it to bigint but no difference

select location, date, total_cases, total_deaths, (cast(total_deaths as float)/ cast(total_cases as float))*100 death_percentage
from Portfolio1..covid_deaths_fixed$
order by location, date
-- Changing it to floats work
  -- Must be bc int only accounts as a whole number while floats go all the way through decimals

select location, date, total_cases, total_deaths, (cast(total_deaths as float)/ cast(total_cases as float))*100 death_percentage
from Portfolio1..covid_deaths_fixed$
where location like '%Philippines%'
order by location, date
-- Tryingn to filter and see how the Philippines fare

-- Total Cases vs Population
  -- Shows the percentage of the population that was infected by Covid in a certain point of day
select location, date, total_cases, population, (cast(total_cases as float)/ cast(population as float))*100 infected_percentage
from Portfolio1..covid_deaths_fixed$
where location like '%Philippines%'
order by location, date
-- When you look at the first infected_percentage with value, one would notice that it shows 8.65358
  -- I checked the calculator and saw the same value but x10^-7
  -- Something to look out for when studying the data
  -- May 23, 2021 is when the around 1% of the population was infected


-- Looking at countries with highest infection rate compared to population
select location, population, max(cast(total_cases as float)) as highest_infection_count, max((cast(total_cases as float)/ cast(population as float))*100) infected_percentage
from Portfolio1..covid_deaths_fixed$
group by location, population
order by infected_percentage desc

-- Looking at countries with the highest death count compared to population
select location, max(cast(total_deaths as float)) as total_death_count
from Portfolio1..covid_deaths_fixed$
group by location
order by total_death_count desc
-- Slight issue as there's other items such as world, high income, etc., they group entire continents
-- when we only want the countries separately

select *
from Portfolio1..covid_deaths$
where continent is not null
order by 3, 4

select location, max(cast(total_deaths as float)) as total_death_count
from Portfolio1..covid_deaths_fixed$
where continent is not null
group by location
order by total_death_count desc
-- Now it's separated by the countries separately


-- Breaking things down by continent

-- Showing the continents with the highest death count
select continent, max(cast(total_deaths as float)) as total_death_count
from Portfolio1..covid_deaths_fixed$
where continent is not null
group by continent
order by total_death_count desc
-- This may be inaccurate, but I'll use this for better visualization for Tableau


select location, max(cast(total_deaths as float)) as total_death_count
from Portfolio1..covid_deaths_fixed$
where continent is null
group by location
order by total_death_count desc
-- This is more accurate then the one above

-- Global Numbers

select date, sum(new_cases) total_cases, SUM(CAST(new_deaths as int)) total_deaths, (SUM(CAST(new_deaths as float))/sum(cast(new_cases as float)))*100 death_percentage_from_infected
from Portfolio1..covid_deaths_fixed$
where (continent is not null) and (new_cases > 0)
group by date
order by 1, 2
-- There is something wrong with my data as There are some days in which the cases and deaths would be 0 despite it
-- should be increasing by the day, currently I removed the instances in which both are 0 to keep the code running
  -- Will need to investigate why it is so QAQ
    -- There might be something wrong with how the file places the data
	-- The data rlly is like that so Ig I have to stick with adding (new_cases > 0)

select date, sum(cast(new_cases as float)) total_cases, SUM(CAST(new_deaths as int)) total_deaths, (SUM(CAST(new_deaths as float))/sum(cast(new_cases as float)))*100 death_percentage_from_infected
from Portfolio1..covid_deaths_fixed$
where continent is not null
group by date
order by 1, 2
-- The code that has error cuz you can't divide 0/0


select sum(new_cases) total_cases, SUM(CAST(new_deaths as int)) total_deaths, (SUM(CAST(new_deaths as float))/sum(cast(new_cases as float)))*100 death_percentage_from_infected
from Portfolio1..covid_deaths_fixed$
where (continent is not null) and (new_cases > 0)
--group by date
order by 1, 2
-- Removing the date adds all total cases and deaths in one row




-- Looking at Total Population vs Total Vacination
select *
from Portfolio1..covid_vacinations$ vac
join Portfolio1..covid_deaths_fixed$ dea
	on dea.location = vac.location and 
	dea.date = vac.date
-- Joining Tables together

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from Portfolio1..covid_vacinations$ vac
join Portfolio1..covid_deaths_fixed$ dea
	on dea.location = vac.location and 
	dea.date = vac.date
where dea.continent is not null
order by 1, 2, 3


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(float, vac.new_vaccinations)) over (partition by dea.location) rolling_vaccinated
from Portfolio1..covid_vacinations$ vac
join Portfolio1..covid_deaths_fixed$ dea
	on dea.location = vac.location and 
	dea.date = vac.date
where dea.continent is not null
order by 2, 3
-- Only added the sum of everything with the same location so it doesn't add up and shows the sum upfront

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) rolling_vaccinated
from Portfolio1..covid_vacinations$ vac
join Portfolio1..covid_deaths_fixed$ dea
	on dea.location = vac.location and 
	dea.date = vac.date
where dea.continent is not null
order by 2, 3
-- By adding the order, the total_vaccinations start to add up to each other/ rolling count

-- Getting the percentage of vaccinated per day
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) rolling_vaccinated
--, (rolling_vaccinated / dea.population)*100
from Portfolio1..covid_vacinations$ vac
join Portfolio1..covid_deaths_fixed$ dea
	on dea.location = vac.location and 
	dea.date = vac.date
where dea.continent is not null
order by 2, 3
-- error cuz you can't use the the column you made to do another operation

-- Using CTE
with PopVsVac (Continent, Location, Date, Population, New_Vaccinated, Rolling_vaccinated) 
as 
(
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) rolling_vaccinated
	from Portfolio1..covid_vacinations$ vac
	join Portfolio1..covid_deaths_fixed$ dea
		on dea.location = vac.location and 
		dea.date = vac.date
	where dea.continent is not null
)

select *, (Rolling_vaccinated/ Population)* 100 vaccinated_population_percentage
from PopVsVac
Order by 2, 3
-- Got the vaccinated population percentage, must keep in mind that I can only do CTE once w/o giving it an error
  -- and that I have to include the CTE table as I use this


select *
from PopVsVac
-- learned that I needed to inlclude the select* with the CTE to not have the invalid syntax


--Using Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255), 
	Date datetime,
	Population float,
	New_Vaccinated bigint,
	Rolling_vaccinated float
)

Insert Into #PercentPopulationVaccinated
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) rolling_vaccinated
	from Portfolio1..covid_vacinations$ vac
	join Portfolio1..covid_deaths_fixed$ dea
		on dea.location = vac.location and 
		dea.date = vac.date
	where dea.continent is not null

select *, (Rolling_vaccinated/ Population)* 100 vaccinated_population_percentage
from #PercentPopulationVaccinated
Order by 2, 3
-- Similar to CTE you have to also select the temp table
-- Adding an edit to you table causes it to make an table with the same name which results in an error
  -- can be fixted by adding an drop table if exist #NameOfTable statement 


  -- Creating View to store data for visualizations

USE Portfolio1
Go
Create View PerPopuVac as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) rolling_vaccinated
from Portfolio1..covid_vacinations$ vac
join Portfolio1..covid_deaths_fixed$ dea
	on dea.location = vac.location and 
	dea.date = vac.date
where dea.continent is not null
-- Good practice to use USE [database name] to see it in the views


Select*
from PerPopuVac