

select *
from Portfolio1.dbo.NashvilleHousing

----------------------------------------------------------------------------
/*
Standardize Date Format
*/

select SaleDateConverted, CONVERT(date, SaleDate) Date
from Portfolio1.dbo.NashvilleHousing
-- Removed the time

update Portfolio1.dbo.NashvilleHousing
set SaleDate = CONVERT(date, SaleDate)
-- Not working for some reason

select SaleDate
from Portfolio1.dbo.NashvilleHousing
----------------------------------------------------------------------------------------------------------

alter table Portfolio1.dbo.NashvilleHousing
	add SaleDateConverted Date;

update Portfolio1.dbo.NashvilleHousing
set SaleDateConverted = CONVERT(date, SaleDate)

select SaleDateConverted
from Portfolio1.dbo.NashvilleHousing
-- Now works +w+

/*
Populate Property Address Data
*/
select PropertyAddress
from Portfolio1.dbo.NashvilleHousing
where PropertyAddress is null

select *
from Portfolio1.dbo.NashvilleHousing
where PropertyAddress is null
-- Checking for Nulls

select *
from Portfolio1.dbo.NashvilleHousing
-- where PropertyAddress is null
order by ParcelID
-- Noticed that below each null PropertyAddress, each has a respective same OwnerName
  -- Can fix the null by populating the null with the property address above it

------------------------------------------------------------------------------------------------------
-- Fixing the column

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portfolio1.dbo.NashvilleHousing a
join Portfolio1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portfolio1.dbo.NashvilleHousing a
join Portfolio1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
-- Now fixed
--------------------------------------------------------------------------------------------------------------------
/*
Breaking out Address into individual columns (Adress, City, State)
*/

select PropertyAddress
from Portfolio1.dbo.NashvilleHousing
-- where PropertyAddress is null
-- order by ParcelID

-- Using substring and character index to separate based on the , delimiter
select
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)) as Address
-- charindex can be anything as long as it's enclosed by the ''
from Portfolio1.dbo.NashvilleHousing

-- removing comma from the Address
select
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)) as Address,
CHARINDEX((','), PropertyAddress)
from Portfolio1.dbo.NashvilleHousing
-- we see that it is a number so we can just remove the last num of each Address to remove the ,

select
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) - 1) as Address
from Portfolio1.dbo.NashvilleHousing
-- The address is isolated

---------------------------------------------------------------------------------------------------
-- Getting the City
select
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
from Portfolio1.dbo.NashvilleHousing

alter table Portfolio1.dbo.NashvilleHousing
	add PropertySplitAddress nvarchar(255);

update Portfolio1.dbo.NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) - 1) 

alter table Portfolio1.dbo.NashvilleHousing
	add PropertySplitCity nvarchar(255);

update Portfolio1.dbo.NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) + 1, LEN(PropertyAddress))

select *
from Portfolio1.dbo.NashvilleHousing
-- 2 new columns at the end of the column



select OwnerAddress
from Portfolio1.dbo.NashvilleHousing

select
PARSENAME(replace(OwnerAddress, ',', '.'), 1),
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 3)
from Portfolio1.dbo.NashvilleHousing
-- Only works with periods
-- 1 is the last/ right most part of the address

-- Changing the order to address -> city -> name
select
PARSENAME(replace(OwnerAddress, ',', '.'), 3),
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from Portfolio1.dbo.NashvilleHousing

-- Adding a new column for the state and the others from the owneraddress
alter table Portfolio1.dbo.NashvilleHousing
	add OwnerSplitAddress nvarchar(255);

update Portfolio1.dbo.NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.'), 3)

alter table Portfolio1.dbo.NashvilleHousing
	add OwnerSplitCity nvarchar(255);

update Portfolio1.dbo.NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)

alter table Portfolio1.dbo.NashvilleHousing
	add OwnerSplitState nvarchar(255);

update Portfolio1.dbo.NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'), 1)

select *
from Portfolio1.dbo.NashvilleHousing
-- New tables added
-- Have to execute it one by one or execute all tables at once before doing the update

---------------------------------------------------------------------------------------------------------------------
/*
Changing Y and N to Yes and No respectively in "Sold as Vacant" field
*/
select distinct (SoldAsVacant), count(SoldAsVacant)
from Portfolio1.dbo.NashvilleHousing
Group by SoldAsVacant
order by SoldAsVacant


select SoldAsVacant,
	case when SoldAsVacant = 'Y' Then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from Portfolio1.dbo.NashvilleHousing

update Portfolio1.dbo.NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end



-------------------------------------------------------------------------------------------------------------------
/*
Removing Duplicates
*/
-- not a standard practice to delete data that's in the table instead make a temp table w/o dupes

with RowNumCTE as (
select *,
	ROW_NUMBER() over (
	partition by ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		order by UniqueID
		) row_num
from Portfolio1.dbo.NashvilleHousing
)--order by ParcelID

select *
from RowNumCTE
where row_num > 1

----------------------------------------------------------------------------------------------------------------

-- Delete Unused Colums

select *
from Portfolio1.dbo.NashvilleHousing

-- removing propertyaddress, owneraddress, and taxdistrict

alter table Portfolio1.dbo.NashvilleHousing
	drop column OwnerAddress, TaxDistrict, PropertyAddress
-- Columns are now removed