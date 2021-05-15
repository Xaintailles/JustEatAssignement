USE [stagingAmazonReviews]
GO

/****** Object:  StoredProcedure [dbo].[usp_merge_category]    Script Date: 5/15/2021 11:54:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_merge_category]
AS
MERGE [dbo].[category] AS T
USING [staging].[category] AS S
ON (T.[asin] = S.[asin] AND T.[categories] = S.[categories] AND T.[category_list_rank] = S.[category_list_rank])
WHEN MATCHED
THEN UPDATE
SET T.[asin] = S.[asin],
	T.[categories] = S.[categories],
	T.[category_list_rank] = S.[category_list_rank],
	T.[category_item_rank] = S.[category_item_rank]
WHEN NOT MATCHED
THEN INSERT ([asin],
[categories],
[category_list_rank],
[category_item_rank]
)
VALUES (S.[asin],
S.[categories],
S.[category_list_rank],
S.[category_item_rank]
);
GO


