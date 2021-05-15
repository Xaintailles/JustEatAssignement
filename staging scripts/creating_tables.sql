USE [stagingAmazonReviews];

CREATE SCHEMA [staging];

CREATE TABLE [dbo].[category](
	[asin] [nvarchar](40) NULL,
	[categories] [nvarchar](4000) NULL,
	[category_list_rank] [int] NULL,
	[category_item_rank] [int] NULL
);

CREATE TABLE [staging].[category](
	[asin] [nvarchar](40) NULL,
	[categories] [nvarchar](4000) NULL,
	[category_list_rank] [int] NULL,
	[category_item_rank] [int] NULL
);

CREATE TABLE [dbo].[metadata](
	[asin] [nvarchar](40) NULL,
	[imUrl] [nvarchar](4000) NULL,
	[title] [nvarchar](4000) NULL,
	[description] [nvarchar](4000) NULL,
	[price] [float] NULL,
	[brand] [nvarchar](4000) NULL
);

CREATE TABLE [staging].[metadata](
	[asin] [nvarchar](40) NULL,
	[imUrl] [nvarchar](4000) NULL,
	[title] [nvarchar](4000) NULL,
	[description] [nvarchar](4000) NULL,
	[price] [float](9, 0) NULL,
	[brand] [nvarchar](4000) NULL
);

CREATE TABLE [dbo].[related](
	[asin] [nvarchar](40) NULL,
	[related_type] [nvarchar](4000) NULL,
	[related] [nvarchar](40) NULL
);

CREATE TABLE [staging].[related](
	[asin] [nvarchar](40) NULL,
	[related_type] [nvarchar](4000) NULL,
	[related] [nvarchar](40) NULL
);

CREATE TABLE [dbo].[reviews](
	[reviewerID] [nvarchar](14) NULL,
	[asin] [nvarchar](40) NULL,
	[reviewerName] [nvarchar](4000) NULL,
	[helpful] [nvarchar](20) NULL,
	[reviewText] [nvarchar](max) NULL,
	[overall] [int] NULL,
	[summary] [nvarchar](4000) NULL,
	[unixReviewTime] [bigint] NULL,
	[reviewTime] [nvarchar](50) NULL
);

CREATE TABLE [staging].[reviews](
	[reviewerID] [nvarchar](14) NULL,
	[asin] [nvarchar](40) NULL,
	[reviewerName] [nvarchar](4000) NULL,
	[helpful] [nvarchar](20) NULL,
	[reviewText] [nvarchar](max) NULL,
	[overall] [int] NULL,
	[summary] [nvarchar](4000) NULL,
	[unixReviewTime] [bigint] NULL,
	[reviewTime] [nvarchar](50) NULL
);

CREATE TABLE [dbo].[salesrank](
	[asin] [nvarchar](40) NULL,
	[category] [nvarchar](4000) NULL,
	[sales_rank] [int] NULL
);

CREATE TABLE [staging].[salesrank](
	[asin] [nvarchar](40) NULL,
	[category] [nvarchar](4000) NULL,
	[sales_rank] [int] NULL
);