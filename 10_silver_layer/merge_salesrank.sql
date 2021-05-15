USE [stagingAmazonReviews]
GO

/****** Object:  StoredProcedure [dbo].[usp_merge_salesrank]    Script Date: 5/15/2021 11:55:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_merge_salesrank]
AS
INSERT INTO [dbo].[salesrank]
SELECT * FROM [staging].[salesrank];

WITH cte AS (
SELECT *
, ROW_NUMBER() OVER (PARTITION BY [asin],[category],[sales_rank] ORDER BY [asin]) AS RN
FROM [dbo].[salesrank])

DELETE FROM cte
WHERE RN > 1;
GO


