USE [AmazonReviewsDWH]
GO

/****** Object:  View [dbo].[v_dimPriceRange]    Script Date: 5/15/2021 4:41:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_dimPriceRange] AS
SELECT *
FROM [dbo].[dimPriceRange]
GO


