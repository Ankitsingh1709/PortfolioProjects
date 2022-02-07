


--Standardize Date Format

select SalesDateConverted, Convert(Date, SaleDate)
from [PortfolioProject].dbo.NashvilleHousing


Update NashvilleHousing
Set SaleDate = CONVERT (Date, SaleDate)

ALTER TABLE NashvilleHousing
Add salesDateConverted Date;


update NashvilleHousing
SET salesDateConverted = CONVERT(Date, SaleDate)

-------------------------------------------------------------------------------------------------------------------------------------------

-- Population Property Adress Data

select propertyAddress
From PortfolioProject.dbo.NashvilleHousing
order by parcelID

SELECT a.ParcelID, a.PropertyAddress, b.PropertyAddress, b.ParcelID, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
SET propertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


------------------------------------------------------------------------------------------------------------------------------------------

--Breaking out Adress into Individual Colums (Adress, City, State)

select propertyAddress
From PortfolioProject.dbo.NashvilleHousing


SELECT
SUBSTRING(propertyAddress, 1,  CHARINDEX(',', propertyAddress) -1 ) as Address
, SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress) + 1 , LEN(propertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE PortfolioProject.dbo. NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo. NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo. NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortfolioProject.dbo. NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo. NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.NashvilleHousing


-------------------------------------------------------------------------------------------

-- Change Y and N to yes and No in "sold as vacant feild"

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo. NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



	   --------------------------------------------------------------------------------------------
	   ---Delete unused Colums


Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
