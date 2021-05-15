USE [stagingAmazonReviews]
GO

/****** Object:  StoredProcedure [dbo].[usp_merge_metadata]    Script Date: 5/15/2021 11:54:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_merge_metadata]
AS
MERGE [dbo].[metadata] AS T
USING [staging].[metadata] AS S
ON (T.[asin] = S.[asin])
WHEN MATCHED
THEN UPDATE
SET T.[asin] = S.[asin],
	T.[imUrl] = S.[imUrl],
	T.[title] = S.[title],
	T.[description] = S.[description],
	T.[price] = S.[price],
	T.[brand] = S.[brand]
WHEN NOT MATCHED
THEN INSERT ([asin],
[imUrl],
[title],
[description],
[price],
[brand]
)
VALUES (S.[asin],
S.[imUrl],
S.[title],
S.[description],
S.[price],
S.[brand]
);
GO


