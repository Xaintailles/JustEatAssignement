USE [stagingAmazonReviews]
GO

/****** Object:  StoredProcedure [dbo].[usp_merge_related]    Script Date: 5/15/2021 11:55:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_merge_related]
AS
INSERT INTO [dbo].[related]
SELECT * FROM [staging].[related];

WITH cte AS (
SELECT *
, ROW_NUMBER() OVER (PARTITION BY [asin],[related_type],[related] ORDER BY [asin]) AS RN
FROM [dbo].[related])

DELETE FROM cte
WHERE RN > 1;
GO


