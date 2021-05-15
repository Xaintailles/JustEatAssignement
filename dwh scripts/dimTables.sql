USE [AmazonReviewsDWH]
GO

/****** Object:  StoredProcedure [dbo].[usp_dimTables]    Script Date: 5/15/2021 1:27:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_dimTables]
AS

EXEC [dbo].[usp_dimPriceRange];

EXEC [dbo].[usp_dimProductCategory];

EXEC [dbo].[usp_dimProductMetadata];

EXEC [dbo].[usp_dimSalesRank];
GO


