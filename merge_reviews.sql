USE [stagingAmazonReviews]
GO

/****** Object:  StoredProcedure [dbo].[usp_merge_reviews]    Script Date: 5/15/2021 11:55:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_merge_reviews]
AS
MERGE [dbo].[reviews] AS T
USING [staging].[reviews] AS S
ON (T.[reviewerID] = S.[reviewerID] AND T.[asin] = S.[asin])
WHEN MATCHED
THEN UPDATE
SET T.[reviewerID] = S.[reviewerID],
	T.[asin] = S.[asin],
	T.[reviewerName] = S.[reviewerName],
	T.[helpful] = S.[helpful],
	T.[reviewText] = S.[reviewText],
	T.[overall] = S.[overall],
	T.[summary] = S.[summary],
	T.[unixReviewTime] = S.[unixReviewTime],
	T.[reviewTime] = S.[reviewTime]
WHEN NOT MATCHED
THEN INSERT ([reviewerID]
      ,[asin]
      ,[reviewerName]
      ,[helpful]
      ,[reviewText]
      ,[overall]
      ,[summary]
      ,[unixReviewTime]
      ,[reviewTime]
)
VALUES (S.[reviewerID]
      ,S.[asin]
      ,S.[reviewerName]
      ,S.[helpful]
      ,S.[reviewText]
      ,S.[overall]
      ,S.[summary]
      ,S.[unixReviewTime]
      ,S.[reviewTime]
);
GO


