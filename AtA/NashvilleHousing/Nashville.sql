/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortafolioAA].[dbo].[Nashville]

 

 --sale date
 SELECT [SaleDate], CONVERT(date, SaleDate)

  FROM [PortafolioAA].[dbo].[Nashville]

UPDATE [PortafolioAA].[dbo].[Nashville]
SET SaleDate=CONVERT(date, SaleDate)

--ALTER TABLE [PortafolioAA].[dbo].[Nashville]
--ADD saleDateNew date

--property address, remove nulls
 SELECT *
  FROM [PortafolioAA].[dbo].[Nashville] a
  WHERE NOT a.OwnerAddress like a.PropertyAddress+'%'
 -- WHERE PropertyAddress IS NULL

--notice ParcelID is the same as property address
SELECT a.ParcelId,a.PropertyAddress,b.ParcelID , b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [PortafolioAA].[dbo].[Nashville] a
JOIN [PortafolioAA].[dbo].[Nashville] b
ON  a.[ParcelID]=b.[ParcelID]
AND NOT a.[UniqueID]=b.[UniqueID] 
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [PortafolioAA].[dbo].[Nashville] a
JOIN [PortafolioAA].[dbo].[Nashville] b
ON  a.[ParcelID]=b.[ParcelID]
AND NOT a.[UniqueID]=b.[UniqueID] 

--splitting addressçity into address and city
SELECT SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address
,SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+2,LEN(PropertyAddress)) AS City
FROM [PortafolioAA].[dbo].[Nashville]

ALTER TABLE [PortafolioAA].[dbo].[Nashville]
--ADD State nvarchar(255)
ADD PropertyStreet nvarchar(255),PropertyCity nvarchar(255)

UPDATE [PortafolioAA].[dbo].[Nashville]
--SET Street=SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
SET PropertyCity=SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+2,LEN(PropertyAddress))

UPDATE [PortafolioAA].[dbo].[Nashville]
--SET Street=SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
SET PropertyStreet=SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

--parsename works only with dots and goes backwards
 SELECT PARSENAME(REPLACE(OwnerAddress, ',','.' ),1) AS 'OwnerState',
 PARSENAME(REPLACE(OwnerAddress, ',','.' ),2) as 'OwnerCity',
 PARSENAME(REPLACE(OwnerAddress, ',','.' ),3) as 'OwnerStreet'
FROM [PortafolioAA].[dbo].[Nashville]

ALTER TABLE [PortafolioAA].[dbo].[Nashville]
ADD OwnerState nvarchar(255),OwnerCity nvarchar(255),OwnerStreet nvarchar(255)

UPDATE [PortafolioAA].[dbo].[Nashville]
SET OwnerState=PARSENAME(REPLACE(OwnerAddress, ',','.' ),1)

UPDATE [PortafolioAA].[dbo].[Nashville]
SET OwnerCity=PARSENAME(REPLACE(OwnerAddress, ',','.' ),2)

UPDATE [PortafolioAA].[dbo].[Nashville]
SET OwnerStreet=PARSENAME(REPLACE(OwnerAddress, ',','.' ),3)

--standarize Y, -N, Yes, -No
select SoldAsVacant--DISTINCT(SoldAsVacant)
from [PortafolioAA].[dbo].[Nashville]
--GROUP BY SoldAsVacant

SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant = 1 THEN 'Y'
WHEN SoldAsVacant=0 THEN 'N'
END
from [PortafolioAA].[dbo].[Nashville]

--NYET. SoldAsVacant no es varchar
UPDATE [PortafolioAA].[dbo].[Nashville]
SET SoldAsVacant =
CASE 
WHEN SoldAsVacant = 1 THEN 'Y'
WHEN SoldAsVacant=0 THEN 'N'
END


--chao duplicates
--CTE
--leer dobre RANK, ORDERRANK, ROW_NUMBER

SELECT *,
ROW_NUMBER() OVER (
					PARTITION BY --partition by parcelID, address, saledate legalreference:if all those are the same, it's the same sle
					ParcelID, PropertyAddress, SalePrice,SaleDate,LegalReference
					ORDER BY --order by dentro del over da una nueva columna!!! --ver el porqué
						UniqueID						
					)
FROM [PortafolioAA].[dbo].[Nashville]
ORDER BY ParcelID


WITH RowNumCTE as (
	SELECT *,
	ROW_NUMBER() OVER (
						PARTITION BY --partition by parcelID, address, saledate legalreference:if all those are the same, it's the same sle
						ParcelID, PropertyAddress, SalePrice,SaleDate,LegalReference
						ORDER BY 
							UniqueID						
						) rw
	FROM [PortafolioAA].[dbo].[Nashville]
	--ORDER BY ParcelID--a los CTE no les gustan los ORDER BY
	--WHERE rw>1--WHERE no va a funcionar porque es una windows function, necesitamos ponerlo en CTE

)
DELETE --SELECT *
FROM RowNumCTE
WHERE rw>1


--NO INTENTION OF DELETING STUFF
