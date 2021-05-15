USE [AmazonReviewsDWH]
GO

/****** Object:  View [dbo].[v_dimProductMetadata]    Script Date: 5/15/2021 4:41:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_dimProductMetadata] AS
SELECT *
FROM [dbo].[dimProductMetadata]
GO


