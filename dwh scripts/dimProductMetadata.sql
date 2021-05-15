USE [AmazonReviewsDWH]
GO

/****** Object:  StoredProcedure [dbo].[usp_dimProductMetadata]    Script Date: 5/15/2021 1:24:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_dimProductMetadata]
AS

DROP TABLE IF EXISTS dimProductMetadata;

DECLARE @power INT = 4;

SELECT [asin]
      ,[imUrl]
      ,[title]
      ,[description]
      ,[price]
      ,[brand]
	  ,CEILING(LOG(price,@power)) AS price_bucket_key
  INTO dimProductMetadata
  FROM [stagingAmazonReviews].[dbo].[metadata];
GO


