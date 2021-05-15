USE [AmazonReviewsDWH]
GO

/****** Object:  StoredProcedure [dbo].[usp_dimSalesRank]    Script Date: 5/15/2021 1:26:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROCEDURE [dbo].[usp_dimSalesRank]
AS

DROP TABLE IF EXISTS dimSalesRank;

SELECT [asin]
      ,[category]
      ,[sales_rank]
INTO [dimSalesRank]
  FROM [stagingAmazonReviews].[dbo].[salesrank]
GO


