USE [DatabaseName]
GO

SET ANSI_NULLS ON -- This allows 0 rows returned if a query is searched with NULL value
GO

SET QUOTED_IDENTIFIER ON --Allows brackets to be used to declare db objects/tables
GO

CREATE TABLE [dbo].[HurricaneHeader](
    [hh_id] [int] IDENTITY(1,1), --Primary key column and increments by 1
    [hh_value] [varchar](8) NOT NULL,--Foreign Key to join with Data
    [hh_name] [varchar](50) NOT NULL,
    [hh_tracks] [int] NOT NULL
)

ALTER TABLE [dbo].[HurricaneHeader] ADD CONSTRAINT [PK_HurricaneHeader] PRIMARY KEY ([hh_id])--Declares for Primary key
GO

ALTER TABLE [dbo].[HurricaneHeader] ADD CONSTRAINT [FK_HurricaneHeader] FOREIGN KEY ([hh_Value]) --Declares foriegn key to refernce the header data
REFERENCES [dbo].[HurricaneData] ([hd_hh_Value])
GO
