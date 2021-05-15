USE [AmazonReviewsDWH]
GO

/****** Object:  StoredProcedure [dbo].[usp_factReviews]    Script Date: 5/15/2021 1:41:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROCEDURE [dbo].[usp_factReviews]
AS

DROP TABLE IF EXISTS [factReviews];

WITH base AS (
SELECT reviewerID
, asin
, reviewerName
, REPLACE(LEFT(helpful,CHARINDEX(', ',helpful) - 1),'[','') AS helpful_grade
, REPLACE(RIGHT(helpful,CHARINDEX(', ',helpful)),']','') AS helpful_out_of
, overall
, summary
, CONVERT(DATE,dateadd(S, unixReviewTime, '1970-01-01')) AS date_key
  FROM [stagingAmazonReviews].[staging].[reviews]
)

SELECT reviewerID
, asin
, reviewerName
, CASE WHEN helpful_out_of = 0 THEN NULL ELSE helpful_grade END AS helpful_grade
, CASE WHEN helpful_out_of = 0 THEN NULL ELSE helpful_out_of END AS helpful_out_of
, overall
, summary
, date_key
INTO [factReviews]
FROM base
GO


