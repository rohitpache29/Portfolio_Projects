--Cleaning data

Select *
from PortfolioProject.dbo.Nashville_Housing


--------------------------------------------------
--Standardize date

Select SaleDateConverted, convert(date,SaleDate)
from PortfolioProject.dbo.Nashville_Housing

update Nashville_Housing
SET SaleDate=convert(date,SaleDate)

Alter table Nashville_Housing
add Saledateconverted date;

update Nashville_Housing
set SaleDateConverted = CONVERT(date,SaleDate)

-------------------------------------------------------

--Populate Property Address data 

select * 
from PortfolioProject.dbo.Nashville_Housing
--Where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.Nashville_Housing a
join PortfolioProject.dbo.Nashville_Housing b
 on a.ParcelID = b.ParcelID 
 and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.Nashville_Housing a
join PortfolioProject.dbo.Nashville_Housing b
 on a.ParcelID = b.ParcelID 
 and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

------------------------------------------------------------------------

--Breaking out address into individual colums (address,city,state)


select PropertyAddress
from PortfolioProject.dbo.Nashville_Housing
--Where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))as address
from PortfolioProject.dbo.Nashville_Housing

Alter table PortfolioProject.dbo.Nashville_Housing
add PropertysplitAddress nvarchar(255);


update PortfolioProject.dbo.Nashville_Housing
set PropertysplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


Alter table PortfolioProject.dbo.Nashville_Housing
add PropertysplitCity nvarchar(255);

update PortfolioProject.dbo.Nashville_Housing
set PropertysplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))

select *
from PortfolioProject.dbo.Nashville_Housing



select OwnerAddress
from PortfolioProject.dbo.Nashville_Housing

Select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.Nashville_Housing

Alter table PortfolioProject.dbo.Nashville_Housing
add OwnersplitAddress nvarchar(255);


update PortfolioProject.dbo.Nashville_Housing
set ownersplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)


Alter table PortfolioProject.dbo.Nashville_Housing
add OwnersplitCity nvarchar(255);

update PortfolioProject.dbo.Nashville_Housing
set OwnersplitCity =PARSENAME(replace(OwnerAddress,',','.'),2)

Alter table PortfolioProject.dbo.Nashville_Housing
add Ownersplitstate nvarchar(255);

Update PortfolioProject.dbo.Nashville_Housing
set Ownersplitstate = PARSENAME(replace(OwnerAddress,',','.'),1)


select *
from PortfolioProject.dbo.Nashville_Housing


-----------------------------------------------------------------------


--Chnage Y and N to Yes and No in "Sold as Vacant"field

Select Distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.dbo.Nashville_Housing
Group by SoldAsVacant
Order by 2

select SoldAsVacant,
Case when SoldAsVacant ='Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End
from PortfolioProject.dbo.Nashville_Housing

Update PortfolioProject.dbo.Nashville_Housing
set SoldAsVacant= Case when SoldAsVacant ='Y' then 'Yes'
                  when SoldAsVacant = 'N' then 'No'
	              Else SoldAsVacant
	              End
---------------------------------------------------------------


--Remove Duplicates

with RowNumCTE as(
select*,
ROW_NUMBER()over(
partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by
			 UniqueID)row_num

from PortfolioProject.dbo.Nashville_Housing
--order by ParcelID
)
select*
from RowNumCTE
where row_num >1
order by PropertyAddress

---------------------------------------------------------

--Delete unused column

Select *
from PortfolioProject.dbo.Nashville_Housing

Alter Table PortfolioProject.dbo.Nashville_Housing
Drop column OwnerAddress,TaxDistrict,PropertyAddress

Alter Table PortfolioProject.dbo.Nashville_Housing
Drop column SaleDate