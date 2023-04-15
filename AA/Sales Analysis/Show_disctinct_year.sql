/****** Script for SelectTopNRows command from SSMS  ******/
/*
SELECT TOP (1000) [DateKey]
      ,[FullDateAlternateKey]
      ,[DayNumberOfWeek]
      ,[EnglishDayNameOfWeek]
      ,[SpanishDayNameOfWeek]
      ,[FrenchDayNameOfWeek]
      ,[DayNumberOfMonth]
      ,[DayNumberOfYear]
      ,[WeekNumberOfYear]
      ,[EnglishMonthName]
      ,[SpanishMonthName]
      ,[FrenchMonthName]
      ,[MonthNumberOfYear]
      ,[CalendarQuarter]
      ,[CalendarYear]
      ,[CalendarSemester]
      ,[FiscalQuarter]
      ,[FiscalYear]
      ,[FiscalSemester]
  FROM [AdventureWorksDW2019].[dbo].[DimDate]
  */
SELECT DISTINCT CalendarYear from [AdventureWorksDW2019].[dbo].[DimDate] order by CalendarYear 
  --SELECT Top(1) CalendarYear from [AdventureWorksDW2019].[dbo].[DimDate] order by CalendarYear desc

 -- select [CalendarYear]
  --FROM [AdventureWorksDW2019].[dbo].[DimDate]

  /* select EnglishDayNameOfWeek,SpanishDayNameOfWeek from [AdventureWorksDW2019].[dbo].[dimdate]  where 
   EnglishDayNameOfWeek != 'Monday' and 
   EnglishDayNameOfWeek != 'Tuesday' and 
   EnglishDayNameOfWeek != 'Wednesday' and 
   EnglishDayNameOfWeek != 'Thursday' and 
   EnglishDayNameOfWeek != 'Friday' and 
   EnglishDayNameOfWeek != 'Saturday' and 
   EnglishDayNameOfWeek != 'Sunday';*/