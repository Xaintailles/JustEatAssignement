USE [AmazonReviewsDWH]
GO

/****** Object:  StoredProcedure [dbo].[usp_dimDate]    Script Date: 5/17/2021 10:20:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_dimDate] AS

SET DATEFIRST 1 -- Set the first day of the week: 1 for Monday, 7 for Sunday

DECLARE @StartDate  date	= '20110101';
DECLARE @Today date			= CONVERT(DATE,GETDATE());
DECLARE @CutoffDate date	= DATEADD(DAY, -1, DATEADD(DAY, 120, @Today));

DROP TABLE IF EXISTS dimDate;

;WITH seq(n) AS 
(
  SELECT 0 UNION ALL SELECT n + 1 FROM seq
  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
),
d(d) AS 
(
  SELECT DATEADD(DAY, n, @StartDate) FROM seq
),
src AS
(
  SELECT

	 [DateKey]				= CONVERT(INT,CONCAT(FORMAT(YEAR(d),'d4'),FORMAT(DATEPART(MONTH,d),'d2'),FORMAT(DATEPART(DAY,d),'d2')))
	,[Date]					= CONVERT(date, d)
    ,[Year]					= CONVERT(INT,YEAR(d))
    ,[Quarter]				= CONVERT(TINYINT,DATEPART(QUARTER,d))
    ,[Month]				= CONVERT(TINYINT,DATEPART(MONTH,d))
    ,[YearMonth]			= CONVERT(INT,CONCAT(FORMAT(YEAR(d),'d4'),FORMAT(DATEPART(MONTH,d),'d2')))
    ,[MonthName]			= CONVERT(VARCHAR(20),CONCAT(FORMAT(d,'MMMM'),' ',YEAR(d)))
    ,[ShortMonthName]		= CONVERT(VARCHAR(4),LEFT(FORMAT(d,'MMMM'),3))
    ,[Week]					= CONVERT(TINYINT,DATEPART(iso_week,d))
    ,[Day]					= CONVERT(TINYINT,DATEPART(DAY,d))
    ,[DayInYear]			= CONVERT(SMALLINT,DATEPART(DAYOFYEAR,d))
    ,[DayInMonth]			= CONVERT(TINYINT,DATEPART(DAY,d))
    ,[DayName]				= CONVERT(CHAR(20),FORMAT(d,'dddd'))
    ,[ShortDayName]			= CONVERT(CHAR(3),LEFT(FORMAT(d,'dddd'),3))
    ,[YYYYMMDD]				= CONVERT(INT,CONCAT(FORMAT(YEAR(d),'d4'),FORMAT(DATEPART(MONTH,d),'d2'),FORMAT(DATEPART(DAY,d),'d2')))
    ,[YYYY/MM/DD]			= CONVERT(VARCHAR(10),CONCAT(FORMAT(YEAR(d),'d4'),'/',FORMAT(DATEPART(MONTH,d),'d2'),'/',FORMAT(DATEPART(DAY,d),'d2')))
    ,[LastDayInMonth]		= CONVERT(DATE,EOMONTH(d))
    --,[YearShortWeekName]	= CONVERT(VARCHAR(20),CONCAT('Wk ',DATEPART(iso_week,d),' - ',FORMAT(YEAR(d),'d4')))
    ,[YearShortWeekName]		= CASE
									WHEN DATEPART(ISO_WEEK, d) > 50 AND MONTH(d) = 1 
									THEN CONVERT(VARCHAR(20),CONCAT('Wk ',DATEPART(iso_week,d),' - ',FORMAT(YEAR(d)-1,'d4')))
									WHEN DATEPART(ISO_WEEK, d) = 1 AND MONTH(d) = 12 
									THEN CONVERT(VARCHAR(20),CONCAT('Wk ',DATEPART(iso_week,d),' - ',FORMAT(YEAR(d)+1,'d4')))
									ELSE CONVERT(VARCHAR(20),CONCAT('Wk ',DATEPART(iso_week,d),' - ',FORMAT(YEAR(d),'d4'))) END
    ,[YearShortMonthName]	= CONVERT(VARCHAR(20),CONCAT(LEFT(FORMAT(d,'MMMM'),3),' - ',FORMAT(YEAR(d),'d4')))
    --,[YearWeek]				= CONVERT(INT,CONCAT(FORMAT(YEAR(d),'d4'),DATEPART(iso_week,d)))
    ,[YearWeek]				= CASE
									WHEN DATEPART(ISO_WEEK, d) > 50 AND MONTH(d) = 1 THEN CONVERT(INT,CONCAT(FORMAT(YEAR(d) - 1,'d4'),FORMAT(DATEPART(iso_week,d), 'd2')))
									WHEN DATEPART(ISO_WEEK, d) = 1 AND MONTH(d) = 12 THEN CONVERT(INT,CONCAT(FORMAT(YEAR(d) + 1,'d4'),FORMAT(DATEPART(iso_week,d), 'd2')))
									ELSE CONVERT(INT,CONCAT(FORMAT(YEAR(d),'d4'),FORMAT(DATEPART(iso_week,d), 'd2'))) END
								--CONVERT(INT,CONCAT(FORMAT(YEAR(d),'d4'),DATEPART(iso_week,d)))--FORMAT(DATEPART(MONTH,d),'d2')
    ,[QuarterName]			= CONVERT(VARCHAR(20),CONCAT('Q',DATEPART(QUARTER,d),' - ',FORMAT(YEAR(d),'d4')))
    ,[YearName]				= CONVERT(VARCHAR(20),CONCAT('Year ',FORMAT(YEAR(d),'d4')))
    ,[YearQuarter]			= CONVERT(INT,CONCAT(FORMAT(YEAR(d),'d4'),FORMAT(DATEPART(QUARTER,d),'d4')))
    --,[YearLongWeekName]		= CONVERT(VARCHAR(20),CONCAT('Week ',DATEPART(iso_week,d),' - ',FORMAT(YEAR(d),'d4')))
    ,[YearLongWeekName]		= CASE
									WHEN DATEPART(ISO_WEEK, d) > 50 AND MONTH(d) = 1 
									THEN CONVERT(VARCHAR(20),CONCAT('Week ',DATEPART(iso_week,d),' - ',FORMAT(YEAR(d)-1,'d4')))
									WHEN DATEPART(ISO_WEEK, d) = 1 AND MONTH(d) = 12 
									THEN CONVERT(VARCHAR(20),CONCAT('Week ',DATEPART(iso_week,d),' - ',FORMAT(YEAR(d)+1,'d4')))
									ELSE CONVERT(VARCHAR(20),CONCAT('Week ',DATEPART(iso_week,d),' - ',FORMAT(YEAR(d),'d4'))) END
							--CONVERT(VARCHAR(20),CONCAT('Week ',DATEPART(iso_week,d),' - ',FORMAT(YEAR(d),'d4')))
  FROM d
)

SELECT * INTO dimDate FROM src
  ORDER BY Date
  OPTION (MAXRECURSION 0);
GO


