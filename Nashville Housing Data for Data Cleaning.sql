/*
Cleaning Data in SQL queries

*/

Select * 
from PortfolioProject.dbo.NashvilleHousing

--Standardize Data format
Select SaleDateConverted, convert(date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate= convert(date,Saledate)

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted= convert(date,Saledate)

-- Populate Property Address Data

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

Update a
set propertyaddress=isnull(a.propertyaddress,b.propertyaddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null
 
--Breaking out address into individual columns(Address,City,State)
Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select 
substring(PropertyAddress, 1, Charindex(',',PropertyAddress)-1) as address
, SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)+1, Len(PropertyAddress)) as Address

from PortfolioProject.dbo.NashvilleHousing

select * 
from PortfolioProject.dbo.NashvilleHousing

select owneraddress
from PortfolioProject.dbo.NashvilleHousing

select 
Parsename(replace(owneraddress,',','.',1)
,Parsename(replace(owneraddress,',','.',2)
,Parsename(replace(owneraddress,',','.',3)
from PortfolioProject.dbo.NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, Case when soldasvacant='Y' Then 'Yes'
	   when soldasvacant='N' Then 'No'
	   Else soldasvacant
	   End
from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
set soldasvacant= CASE when soldasvacant='Y' Then 'Yes'
	   WHEN soldasvacant='N' Then 'No'
	   Else soldasvacant
	   End
from PortfolioProject.dbo.NashvilleHousing


--Remove Duplicates
Select *,
	Row_number() over(
	Partition by parcel ID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by 
					uniqueID 
					) row_num
from PortfolioProject.dbo.NashvilleHousing
order by ParcelID

--Delete unused columns
select * 
from PortfolioProject.dbo.NashvilleHousing

Alter table PortfolioProject.dbo.NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress

Alter table PortfolioProject.dbo.NashvilleHousing
drop column Saledate