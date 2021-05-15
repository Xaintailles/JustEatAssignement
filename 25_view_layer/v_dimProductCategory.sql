USE [AmazonReviewsDWH]
GO

/****** Object:  View [dbo].[v_dimProductCategory]    Script Date: 5/15/2021 4:41:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_dimProductCategory] AS
SELECT *
FROM [dbo].[dimProductCategory]
GO


