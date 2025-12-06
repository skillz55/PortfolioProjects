/*

Cleaning Data in SQL Queries

*/


Select *
From [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDate
From [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]
--where PropertyAddress IS NULL
order by parcelID


Select a.ParcelID ,a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [DataDB].[dbo].[Nashville Housing Data for Data Cleaning] a
JOIN [DataDB].[dbo].[Nashville Housing Data for Data Cleaning] b
	on a.parcelid= b.parcelid
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is NULL



update a
SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
From [DataDB].[dbo].[Nashville Housing Data for Data Cleaning] a
JOIN [DataDB].[dbo].[Nashville Housing Data for Data Cleaning] b
	on a.parcelid= b.parcelid
	AND a.[UniqueID] <> b.[UniqueID]
	WHERE a.PropertyAddress is NULL








--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)



Select PropertyAddress
From [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]
--where PropertyAddress IS NULL
--order by parcelID



SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, len(propertyaddress)) as Address


From [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]



ALTER TABLE [Nashville Housing Data for Data Cleaning]
Add PropertySplitAddress Nvarchar(255);



Update [Nashville Housing Data for Data Cleaning]
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE [Nashville Housing Data for Data Cleaning]
Add PropertySplitCity Nvarchar(255);



Update [Nashville Housing Data for Data Cleaning]
SET PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, len(propertyaddress))


SELECT * from [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]





SELECT OwnerAddress
from [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]


SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.')  ,3)
,PARSENAME(REPLACE(OwnerAddress,',', '.')  ,2)
,PARSENAME(REPLACE(OwnerAddress,',', '.')  ,1)

from [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]




ALTER TABLE [Nashville Housing Data for Data Cleaning]
Add OwnerSplitAddress Nvarchar(255);



Update [Nashville Housing Data for Data Cleaning]
SET OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress,',','.')  ,3)








ALTER TABLE [Nashville Housing Data for Data Cleaning]
Add OwnerSplitCity Nvarchar(255);



Update [Nashville Housing Data for Data Cleaning]
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.')  ,2)







ALTER TABLE [Nashville Housing Data for Data Cleaning]
Add OwnerSplitState Nvarchar(255);



Update [Nashville Housing Data for Data Cleaning]
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.')  ,1)




SELECT * from [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]










--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


select distinct(Soldasvacant), count(SoldAsVacant)
FROM [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]
GROUP BY SoldAsVacant
ORDER BY 2



SELECT SoldAsVacant
, CASE when SoldAsVacant='1' THEN 'Yes'
	when SoldAsVacant='0' THEN 'No'
	END
FROM [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]



ALTER TABLE [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]
ALTER COLUMN SoldAsVacant CHAR(3);


Update [Nashville Housing Data for Data Cleaning]
SET SoldAsVacant= CASE when SoldAsVacant='1' THEN 'Yes'
	when SoldAsVacant='0' THEN 'No'
	ELSE SoldAsVacant
	END







-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

FROM [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]
--order by ParcelID
)
SELECT *
FROM RowNumCTE
where row_num > 1
ORDER by PropertyAddress




SELECT * 

FROM [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]













---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


SELECT * 

FROM [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]


ALTER TABLE [DataDB].[dbo].[Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress



---------------------------------------------------------------------------------------------------------

