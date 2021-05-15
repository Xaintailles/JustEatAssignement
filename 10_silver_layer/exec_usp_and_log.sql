USE [stagingAmazonReviews]
GO

/****** Object:  StoredProcedure [dbo].[usp_exec_usp_and_log]    Script Date: 5/15/2021 8:49:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_exec_usp_and_log] @table_name NVARCHAR(MAX)
AS

DECLARE @usp VARCHAR(max) = N'[dbo].[usp_merge_' + @table_name + ']'

DECLARE @count_before INT;
DECLARE @loaded_from_source INT;
DECLARE @count_after INT;

DECLARE @count_before_sql NVARCHAR(MAX) = N'SELECT @count = COUNT(*) FROM [dbo].' + @table_name
DECLARE @loaded_from_source_sql NVARCHAR(MAX) = N'SELECT @count = COUNT(*) FROM [staging].' + @table_name
DECLARE @count_after_sql NVARCHAR(MAX) = N'SELECT @count = COUNT(*) FROM [dbo].' + @table_name


EXEC sp_executesql @count_before_sql, N'@count int OUTPUT', @count = @count_before OUT

EXEC sp_executesql @loaded_from_source_sql, N'@count int OUTPUT', @count = @loaded_from_source OUT

EXEC @usp

EXEC sp_executesql @count_after_sql, N'@count int OUTPUT', @count = @count_after OUT

INSERT INTO [logs].[dbo].[silver_layer_log] (timestamp, [table], count_before, loaded_from_source, count_after)
VALUES (GETDATE(), @table_name, @count_before, @loaded_from_source, @count_after)
GO


