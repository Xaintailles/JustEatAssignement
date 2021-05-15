USE [AmazonReviewsDWH]
GO

/****** Object:  StoredProcedure [dbo].[usp_factTables]    Script Date: 5/15/2021 1:40:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_factTables]
AS

EXEC [dbo].[usp_factReviews];

GO


