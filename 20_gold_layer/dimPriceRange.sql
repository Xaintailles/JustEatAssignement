USE [AmazonReviewsDWH]
GO

/****** Object:  StoredProcedure [dbo].[usp_dimPriceRange]    Script Date: 5/15/2021 5:25:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/


CREATE PROCEDURE [dbo].[usp_dimPriceRange]
AS

DROP TABLE IF EXISTS dimPriceRange;

DECLARE @power INT = 10;
DECLARE @startnum INT = 0
DECLARE @endnum INT = 8
;
WITH gen AS (
    SELECT @startnum AS num
    UNION ALL
    SELECT num+1 FROM gen WHERE num+1<=@endnum
)
,
final AS (
SELECT num as price_bucket_key
, CONCAT(COALESCE(POWER(@power,LAG(num) OVER (ORDER BY num ASC)),0),'-',POWER(@power,num)) AS price_range
FROM gen
)

SELECT * INTO dimPriceRange FROM final

GO


