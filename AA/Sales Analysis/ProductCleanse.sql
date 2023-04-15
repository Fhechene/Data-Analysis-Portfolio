/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) 
	   p.[ProductKey]
      ,p.[ProductAlternateKey] as 'ProductItemCode'
      --,[ProductSubcategoryKey]
      --,[WeightUnitMeasureCode]
      --,[SizeUnitMeasureCode]
      ,p.[EnglishProductName] AS 'Product Name'
      --,[SpanishProductName]
	  ,ISNULL(ps.EnglishProductSubcategoryName,'Other') AS 'Sub Category'
	  ,ISNULL(pc.EnglishProductCategoryName,'Other') AS 'Product Category'
      --,[FrenchProductName]
      --,[StandardCost]
      --,[FinishedGoodsFlag]
      ,ISNULL([Color],'Other') AS 'Product Color'
      --,[SafetyStockLevel]
      --,[ReorderPoint]
      --,[ListPrice]
      ,ISNULL([Size],'Other') AS 'Product Size'
      --,[SizeRange]
      --,[Weight]
      --,[DaysToManufacture]
      ,ISNULL([ProductLine],'Other') AS 'Product Line'
      --,[DealerPrice]
      --,[Class]
      --,[Style]
      ,ISNULL([ModelName],'Other') AS 'Product Model Name'
      --,[LargePhoto]
      ,ISNULL(p.[EnglishDescription],'Not given') AS 'Product Description'
      --,[FrenchDescription]
      --,[ChineseDescription]
      --,[ArabicDescription]
      --,[HebrewDescription]
      --,[ThaiDescription]
      --,[GermanDescription]
      --,[JapaneseDescription]
      --,[TurkishDescription]
      --,[StartDate]
      --,[EndDate]
      ,ISNULL(p.[Status],'Outdated') AS 'Product Status'
FROM [AdventureWorksDW2019].[dbo].[DimProduct] as p
      LEFT JOIN [AdventureWorksDW2019].dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey=p.ProductSubcategoryKey
      LEFT JOIN [AdventureWorksDW2019].dbo.DimProductCategory AS pc on ps.ProductCategoryKey=pc.ProductCategoryKey
order by 
      p.ProductKey asc
  