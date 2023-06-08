/*

Data cleaning in SQL Queries


*/

select * 
from PortfolioProject..NashvileHousing

---------------------------------------------------------------------------------------------------------------------------------------------------------

--Standardize Date Format


select SaleDate,convert(date,SaleDate)
from PortfolioProject..NashvileHousing

Update PortfolioProject..NashvileHousing
Set SaleDate = convert(date,SaleDate)

---------------------------------------------------------------------------------------------------------------------------------------------------------

--Populate Property Address data

Select * from PortfolioProject..NashvileHousing
--where PropertyAddress is not null
order by ParcelID


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.propertyAddress,b.PropertyAddress)
from PortfolioProject..NashvileHousing a
Join PortfolioProject..NashvileHousing b
  ON a.ParcelID=b.ParcelID
  AND a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is null

  Update a
  set a.ParcelID= ISNULL(a.propertyAddress,b.PropertyAddress)
from PortfolioProject..NashvileHousing a
Join PortfolioProject..NashvileHousing b
  ON a.ParcelID=b.ParcelID
  AND a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is null


  ---------------------------------------------------------------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (address,City,State)



Select 

SUBSTRING(PropertyAddress,1,charindex(',',propertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,charindex(',',propertyAddress)+1,LEN(PropertyAddress)) as Address
from PortfolioProject..NashvileHousing


Alter table portfolioproject..NashvileHousing
Add PropertySplitAddress nvarchar(255);

Update Nashvilehousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,charindex(',',propertyAddress)-1) 

Alter table portfolioproject..NashvileHousing
Add PropertySplitCity Nvarchar(255);

Update Nashvilehousing
Set PropertySplitCity =SUBSTRING(PropertyAddress,charindex(',',propertyAddress)+1,LEN(PropertyAddress)) 

Select propertysplitCity,propertysplitaddress
from NashvileHousing

select
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from NashvileHousing


Alter table portfolioproject..NashvileHousing
Add OwnerSplitAddress nvarchar(255);

Update Nashvilehousing
Set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3) 

Alter table portfolioproject..NashvileHousing
Add OwnerSplitCity Nvarchar(255);

Update Nashvilehousing
Set OwnerSplitCity =PARSENAME(replace(OwnerAddress,',','.'),2) 

Alter table portfolioproject..NashvileHousing
Add OwnerSplitState Nvarchar(255);

Update Nashvilehousing
Set OwnerSplitState =PARSENAME(replace(OwnerAddress,',','.'),2) 

  ---------------------------------------------------------------------------------------------------------------------------------------------------------

--Change Y and N to yes and No in "Sold as Vacant" field

Select Distinct(SoldAsvacant),Count(soldAsvacant)
from PortfolioProject..NashvileHousing
group by SoldAsVacant
order by 2

Select Distinct(SoldAsvacant)
, case when SoldAsVacant ='Y'Then 'Yes'
	   When SoldAsVacant='N' Then 'No'
	   Else SoldAsVacant
	   END
	   from PortfolioProject..NashvileHousing


	   Update  NashvileHousing
Set SoldAsVacant = case when SoldAsVacant ='Y'Then 'Yes'
	   When SoldAsVacant='N' Then 'No'
	   Else SoldAsVacant
	   END

	   Select SoldAsVacant
	   from PortfolioProject..NashvileHousing




---------------------------------------------------------------------------------------------------------------------------------------------------------

--Remove Duplicate Value
With RowNumCTE AS (
Select *,
ROW_number() Over(
Partition By ParcelID, PropertyAddress,SalePrice,SaleDate,LegalReference
Order by UniqueID)row_num

From PortfolioProject..NashvileHousing
--Order by ParcelID
)
select *
From RowNumCTE
where row_num> 1

Delete
From RowNumCTE
where row_num> 1
--Order by PropertyAddress
	 


---------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

Select * 
from PortfolioProject..NashvileHousing

Alter Table Portfolioproject..nashvileHousing
Drop Column OwnerAddress,TaxDistrict, PropertyAddress

Alter Table Portfolioproject..nashvileHousing
Drop Column SaleDate