USE [stagingAmazonReviews]
GO

/****** Object:  StoredProcedure [dbo].[udp_merge_staging]    Script Date: 5/15/2021 4:48:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[udp_merge_staging]
AS

EXEC [dbo].[usp_merge_category];

EXEC [dbo].[usp_merge_metadata];

EXEC [dbo].[usp_merge_related];

EXEC [dbo].[usp_merge_reviews];

EXEC [dbo].[usp_merge_salesrank];
GO


