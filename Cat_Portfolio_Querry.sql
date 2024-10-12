-- Cat Database 
/*
Main goals for this query:
1. Checking the dataset for any nulls/ cleaning the dataset
2. Finding the distinct values for each column
3. Find data on:
  a. Avg age of each breed
  b. Avg Female cat age vs Avg Male cat age
  c. Avg Female cat weight vs Avg Male cat weight
  d. Division of different color of cats and breed
  e. Division of different color of cats for females and males separately
  f. Amount of colors vs age
  g. Amount of colors vs weight
*/

/* Cleaning the Dataset */
select *
from [Cat Portfolio]..cats_dataset$

select *
from [Cat Portfolio]..cats_dataset_key$

-- Looking for Nulls

select *
from [Cat Portfolio]..cats_dataset$
WHERE ISNULL(Breed, '') = '' 

select *
from [Cat Portfolio]..cats_dataset$
WHERE NOT ISNULL(Breed, '') = '' 
-- No NULL values found






/*Looking for distinct values in each column */

-- Cat Breed -- -- -- -- --
select distinct Breed
from [Cat Portfolio]..cats_dataset$
-- The different cat breeds within the datset

select Breed, count(Breed) No_of_cats_breed
from [Cat Portfolio]..cats_dataset$
group by Breed
order by Breed
-- The number of cats within each breed and arranged alphabetically

select Breed, count(Breed) No_of_cats_breed
from [Cat Portfolio]..cats_dataset$
group by Breed
order by No_of_cats_breed desc
-- This one is ranged based on which breed has the most cats to the least
  -- Most of the cats are of Ragdoll breed while the Norweigian Forest breed contains the least



-- Cat Age -- -- -- -- --
select distinct [Age (Years)]
from [Cat Portfolio]..cats_dataset$
-- The different cat breeds within the datset

select [Age (Years)], count([Age (Years)]) No_of_cats_age
from [Cat Portfolio]..cats_dataset$
group by [Age (Years)]
order by [Age (Years)] desc
-- The number of cats within each age



-- Cat Weight -- -- -- -- --
select distinct [Weight (kg)]
from [Cat Portfolio]..cats_dataset$
-- The different cat weights within the datset

select [Weight (kg)], count([Weight (kg)]) No_of_cats_weight
from [Cat Portfolio]..cats_dataset$
group by [Weight (kg)]
order by [Weight (kg)] desc
-- The number of cats within each weight



-- Cat Color -- -- -- -- --
select distinct Color
from [Cat Portfolio]..cats_dataset$
-- The different cat colors within the datset

select Color, count(Color) No_of_cats_color
from [Cat Portfolio]..cats_dataset$
group by Color
order by Color desc
-- The number of cats within each color and arranged alphabetically

select Color, count(Color) No_of_cats_color
from [Cat Portfolio]..cats_dataset$
group by Color
order by No_of_cats_color desc
-- This one is arranged based on which color had the most cats in the dataset to the least
  -- Most of the cast are either gray or tricolor while white has the least number of cats



-- Cat Gender -- -- -- -- --
select distinct Gender
from [Cat Portfolio]..cats_dataset$
-- The different cat genders within the datset

select Gender, count(Gender) No_of_cats
from [Cat Portfolio]..cats_dataset$
group by Gender
-- The number of cats within each gender
  -- There seems to be slightly more male cats than female cats in the dataset


/*Finding Data on: */

 -- a. Avg age of each breed -- -- -- -- --
select Breed, AVG([Age (Years)]) avg_breed_age
from [Cat Portfolio]..cats_dataset$
group by Breed
order by avg_breed_age desc
-- The Himalayan breed has the higest average age while the Singapura had the least average age

  -- a.i Max age of each breed -- -- -- -- --
select Breed, MAX([Age (Years)]) max_breed_age
from [Cat Portfolio]..cats_dataset$
group by Breed
order by max_breed_age desc
-- Almost all breeds had the same max age
  -- The highest being 19, the lowest being 17 belonging to the Singapura

  -- a.ii Breed vs avg age vs max age vs min age
select Breed, 
AVG([Age (Years)]) avg_breed_age, 
MAX([Age (Years)]) max_breed_age,
MIN([Age (Years)]) min_breed_age,
COUNT([Age (Years)]) no_per_breed
from [Cat Portfolio]..cats_dataset$
group by Breed
order by avg_breed_age desc


 -- b. Avg Female cat age vs Avg Male cat age -- -- -- -- --
select Gender, AVG([Age (Years)]) avg_age_gender
from [Cat Portfolio]..cats_dataset$
group by Gender
order by avg_age_gender desc
  -- The female cats are slightly older than male cats on average

  -- b.i  gender vs avg age vs max age vs min age
select Gender, 
AVG([Age (Years)]) avg_age_gender, 
MAX([Age (Years)]) max_age_gender, 
MIN([Age (Years)]) min_age_gender
from [Cat Portfolio]..cats_dataset$
group by Gender
order by avg_age_gender desc
 -- despite female cats being slightly older in average, both feline genders have the same max and min age



 -- c. Avg Female cat weight vs Avg Male cat weight -- -- -- -- --
select Gender, AVG([Weight (kg)]) avg_weight_gender
from [Cat Portfolio]..cats_dataset$
group by Gender
order by avg_weight_gender desc
  -- The female cats are slightly heavier than male cats on average

  -- c.i  gender vs avg weight vs max weight vs min weight
select Gender, 
AVG([Weight (kg)]) avg_weight_gender, 
MAX([Weight (kg)]) max_weight_gender, 
MIN([Weight (kg)]) min_weight_gender
from [Cat Portfolio]..cats_dataset$
group by Gender
order by avg_weight_gender desc
 -- despite female cats being slightly heavier in average, both feline genders have the same max and min weight



 -- d. Division of different color of cats and breed -- -- -- -- --
select distinct Breed, Color
from [Cat Portfolio]..cats_dataset$
-- From the table we can see that same breed cats may not have the share one absolute type of color

select distinct Color, Breed
from [Cat Portfolio]..cats_dataset$
-- While both give out the same number of outputs in the end, the previous one shows the point more clearly



 -- e. Division of different color of cats for females and males separately -- -- -- -- --
 -- Try to find a way to make it like a check list to find the amount for female and male cats for each breed side by side

select Breed,
count(case
	when Gender = 'Female' then 'True'
end) is_female,
count(case
	when Gender = 'Male' then 'True'
end) is_male
from [Cat Portfolio]..cats_dataset_key$
group by Breed
order by Breed


 -- f. Amount of colors vs age -- -- -- -- --
select Color, 
AVG([Age (Years)]) avg_age_gender, 
MAX([Age (Years)]) max_age_gender, 
MIN([Age (Years)]) min_age_gender
from [Cat Portfolio]..cats_dataset$
group by Color
order by avg_age_gender desc
-- cats with the black color have the highest avg age while cats with the tricolor color have the lowest.
-- All cat color types have the same min and max weight



 -- g. Amount of colors vs weight -- -- -- -- --
select Color, 
AVG([Weight (kg)]) avg_weight_gender, 
MAX([Weight (kg)]) max_weight_gender, 
MIN([Weight (kg)]) min_weight_gender
from [Cat Portfolio]..cats_dataset$
group by Color
order by avg_weight_gender desc
-- cats with the sable color have the highest avg weight while cats with the tabby color have the lowest.
-- All cat color types have the same min and max weight