USE [AmazonReviewsDWH]
GO

/****** Object:  View [dbo].[v_dimSalesRank]    Script Date: 5/15/2021 4:42:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_dimSalesRank] AS

SELECT *
FROM [dbo].[dimSalesRank]
GO


