USE [DatabaseName]
GO

SET ANSI_NULLS ON -- This allows 0 rows returned if a query is searched with NULL value
GO

SET QUOTED_IDENTIFIER ON --Allows brackets to be used to declare db objects/tables
GO

CREATE TABLE [dbo].[HurricaneData](
    [hd_id] [int] IDENTITY(1,1), --Primary key column and increments by 1
    [hd_hh_value] [varchar](25) NOT NULL,
    [hd_date] [date] NOT NULL,
    [hd_time] [int] NOT NULL,
    [hd_identifier] [varchar](1) NULL,--Will add constraint for this value
    [hd_status] [varchar](2) NOT NULL,
    [hd_latitude] [varchar](10) NOT NULL, -- For the longitude and latitude, could potentially convert and use geo data type
    [hd_longitude] [varchar](10) NOT NULL, --However, seeing how data is being loaded, this option may not be possible to convert
    [hd_windSpeed] [int] NOT NULL,
    [hd_NE34] [int] NULL, --Will add constraint for values this and below
    [hd_SE34] [int] NULL,
    [hd_SW34] [int] NULL,
    [hd_NW34] [int] NULL,
    [hd_NE50] [int] NULL,
    [hd_SE50] [int] NULL,
    [hd_NW50] [int] NULL,
    [hd_SW50] [int] NULL,
    [hd_NE60] [int] NULL,
    [hd_SE60] [int] NULL,
    [hd_NW60] [int] NULL,
    [hd_SW60] [int] NULL,
)

ALTER TABLE [dbo].[HurricaneData] ADD CONSTRAINT [PK_HurricaneData] PRIMARY KEY ([hd_id])--Declares for Primary key
GO

ALTER TABLE [dbo].[HurricaneData] ADD CONSTRAINT [FK_HurricaneData] FOREIGN KEY ([hd_hh_Value]) --Declares foriegn key to refernce the header data
REFERENCES [dbo].[HurricaneHeader] ([hh_Value])
GO

ALTER TABLE [dbo].[HurricaneData] ADD Constraint [DF_HurricaneData] DEFAULT (NULL) for [hd_identifier] -- Rule to set the empty strings as null if no value found
GO
