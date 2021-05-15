USE [AmazonReviewsDWH]
GO

/****** Object:  View [dbo].[v_dimProductPrice]    Script Date: 5/15/2021 5:24:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[v_dimProductPrice] AS

SELECT *
,CASE WHEN price = 0 THEN 0 ELSE CEILING(LOG(price,4)) END AS price_bucket_key
FROM [dbo].[dimProductPrice]
GO


