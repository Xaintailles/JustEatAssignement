USE [AmazonReviewsDWH]
GO

/****** Object:  View [dbo].[v_dimProductPrice]    Script Date: 5/15/2021 4:42:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_dimProductPrice] AS

SELECT *
,CEILING(LOG(price,4)) AS price_bucket_key
FROM [dbo].[dimProductPrice]
GO


