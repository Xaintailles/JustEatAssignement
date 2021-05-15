USE [AmazonReviewsDWH]
GO

/****** Object:  StoredProcedure [dbo].[usp_dimProductPrice]    Script Date: 5/15/2021 4:40:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE PROCEDURE [dbo].[usp_dimProductPrice]
AS

  INSERT  INTO dimProductPrice
        SELECT  [asin] ,
                price ,
                Eff_Date,
				End_Date,
				Current_Flag
        FROM    ( MERGE dimProductPrice CM
                    USING [stagingAmazonReviews].[dbo].[metadata] CS
                    ON ( CM.[asin] = CS.[asin] )
                    WHEN NOT MATCHED
                        THEN
		INSERT           VALUES
                ( CS.[asin] ,
                  CS.price ,
                  CONVERT(CHAR(10), GETDATE() - 1, 101) ,
                  '12/31/2199' ,
                  'y'
                )
                    WHEN MATCHED AND CM.Current_Flag = 'y'
                        AND ( CM.price <> CS.price )
                        THEN
		 UPDATE          SET
                CM.Current_Flag = 'n' ,
                CM.End_date = CONVERT(CHAR(10), GETDATE() - 2, 101)
                    OUTPUT
                        $Action Action_Out ,
                        CS.[asin] ,
                        CS.price ,
                        CONVERT(CHAR(10), GETDATE() - 1, 101) Eff_Date ,
                        '12/31/2199' End_Date ,
                        'y' Current_Flag) AS MERGE_OUT
        WHERE   MERGE_OUT.Action_Out = 'UPDATE';
GO


