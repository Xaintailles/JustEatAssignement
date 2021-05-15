USE [stagingAmazonReviews]
GO

/****** Object:  StoredProcedure [dbo].[usp_merge_staging]    Script Date: 5/15/2021 8:49:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_merge_staging]
AS

EXEC [dbo].[usp_exec_usp_and_log] @table_name = N'category'

EXEC [dbo].[usp_exec_usp_and_log] @table_name = N'metadata'

EXEC [dbo].[usp_exec_usp_and_log] @table_name = N'related'

EXEC [dbo].[usp_exec_usp_and_log] @table_name = N'reviews'

EXEC [dbo].[usp_exec_usp_and_log] @table_name = N'salesrank'

GO


