
Select *
From PortfolioProject.dbo.NashvilleHousing$


-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing$


Update NashvilleHousing$
SET SaleDate = CONVERT(Date, SaleDate)


ALTER TABLE NashvilleHousing$
Add SaleDateConverted Date;


Update NashvilleHousing$
SET SaleDateConverted = CONVERT(Date, SaleDate)



-- Populate Property Address data

Select *
From PortfolioProject.dbo.NashvilleHousing$
-- Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing$ a
Join PortfolioProject.dbo.NashvilleHousing$ b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID] <> b.[UniqueID]
 Where a.PropertyAddress is null


 Update a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 From PortfolioProject.dbo.NashvilleHousing$ a
Join PortfolioProject.dbo.NashvilleHousing$ b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID] <> b.[UniqueID]
 Where a.PropertyAddress is null


-- Breaking out Address into indivdual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing$


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing$




ALTER TABLE NashvilleHousing$
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing$
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
From PortfolioProject.dbo.NashvilleHousing$




ALTER TABLE NashvilleHousing$
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)


ALTER TABLE NashvilleHousing$
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)



ALTER TABLE NashvilleHousing$
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


Select *
From PortfolioProject.dbo.NashvilleHousing$


-- Change Y and N TO Yes and No

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing$
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing$


Update NashvilleHousing$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing$

)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing$


-- Delete Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing$


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate