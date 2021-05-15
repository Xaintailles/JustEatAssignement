USE [AmazonReviewsDWH]
GO

/****** Object:  View [dbo].[v_factReviews]    Script Date: 5/15/2021 4:42:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_factReviews] AS

SELECT FR.*
, PP.[product_key] AS [product_key]
FROM [dbo].[factReviews] AS FR
LEFT JOIN [dbo].[dimProductPrice] AS PP
	ON FR.[asin] = PP.[asin]
	AND FR.date_key BETWEEN PP.[eff_date] AND PP.[end_date]
GO


