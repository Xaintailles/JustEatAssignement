USE [AmazonReviewsDWH]
GO

/****** Object:  StoredProcedure [dbo].[usp_dimProductMetadata]    Script Date: 5/15/2021 4:40:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_dimProductMetadata]
AS

DROP TABLE IF EXISTS dimProductMetadata;

SELECT [asin]
      ,[imUrl]
      ,[title]
      ,[description]
      ,[brand]
  INTO dimProductMetadata
  FROM [stagingAmazonReviews].[dbo].[metadata];
GO


