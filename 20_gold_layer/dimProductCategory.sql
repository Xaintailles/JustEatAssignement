USE [AmazonReviewsDWH]
GO

/****** Object:  StoredProcedure [dbo].[usp_dimProductCategory]    Script Date: 5/15/2021 1:24:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_dimProductCategory]
AS

DROP TABLE IF EXISTS dimProductCategory;

WITH t1 AS (
SELECT asin, categories AS primary_category
FROM [stagingAmazonReviews].[dbo].[category]
WHERE [category_list_rank] = 1 AND [category_item_rank] = 1
)
,
t2 AS (
SELECT asin, categories AS secondary_category
FROM [stagingAmazonReviews].[dbo].[category]
WHERE [category_list_rank] = 1 AND [category_item_rank] = 2
)
,
t3 AS (
SELECT asin, categories AS tertiary_category
FROM [stagingAmazonReviews].[dbo].[category]
WHERE [category_list_rank] = 1 AND [category_item_rank] = 3
)

SELECT t1.asin
, [primary_category]
, [secondary_category]
, [tertiary_category]
INTO [dimProductCategory]
FROM t1
LEFT JOIN t2
	ON t2.asin = t1.asin
LEFT JOIN t3
	ON t3.asin = t1.asin
GO


