/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
       c.CustomerKey
      --,[GeographyKey]
      --,[CustomerAlternateKey]
      --,[Title]
      ,c.[FirstName] AS 'First Name'
		--,CASE c.[MiddleName] WHEN ISNULL(c.MiddleName) THEN ' ' ELSE c.[MiddleName] END AS 'Middle Name'
	  ,ISNULL(c.MiddleName,'') AS 'Middle Name'
      ,c.[LastName] AS 'Last Name'
	  --,c.FirstName+' '+ISNULL(c.MiddleName,'')+' '+c.LastName AS 'Full Name'
      ,CASE ISNULL(c.[MiddleName],'NULL') WHEN 'NULL' THEN c.FirstName+' '+c.LastName ELSE c.FirstName+' '+c.MiddleName+' '+c.LastName END AS 'Full Name'
	  --,[NameStyle]
      --,[BirthDate]
      --,[MaritalStatus]
      --,[Suffix]
      ,CASE c.[Gender] WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' ELSE 'NB' END AS 'Gender'
      --,[EmailAddress]
      --,[YearlyIncome]
      --,[TotalChildren]
      --,[NumberChildrenAtHome]
      --,[EnglishEducation]
      --,[SpanishEducation]
      --,[FrenchEducation]
      --,[EnglishOccupation]
      --,[SpanishOccupation]
      --,[FrenchOccupation]
      --,[HouseOwnerFlag]
      --,[NumberCarsOwned]
      ,c.[AddressLine1]
      ,ISNULL(c.[AddressLine2],'') AS 'AddressLine2'
      ,c.[Phone]
      ,c.[DateFirstPurchase] AS 'DateFirstPurchase'
      --,[CommuteDistance]
	  ,g.City as 'Customer City'
  FROM 
      [AdventureWorksDW2019].[dbo].[DimCustomer] AS c
	  LEFT JOIN [AdventureWorksDW2019].[dbo].[DimGeography] as g ON g.GeographyKey = c.GeographyKey
 ORDER BY
      CustomerKey ASC