/*  What I intend to do here is to import and load the HUDART data into a staging table and then split the content based on 
its values content into either the header or data table
*/

 If Object_ID (N'tempdb..#Imports',N'U') Is Not Null --Checks to see if there is data present in the staging table, if yes, drop, this will refresh with updated data 
  DROP TABLE #Imports
  
  CREATE TABLE #Imports(
    Content varchar(MAX) NOT NULL --Declaring the staging table, ensuring value is maxed out to handle all the data
  )
  
  BULK INSERT #Imports
  FROM 'Path_where_HURDAT_data_is_located.txt'
  WITH
  (
    FIRSTROW = 1, --Which row will the insertion commence
    ROWTERMINATOR = '\n', --provides all the data into rows. Not using fieldTerminator as this is not possible with different ',' lengths
    TABLOCK, --To provide minmial logging used upon insertion due to large database
    MAXERRORS = 100, --Number of syntax errors allowed in the bulk insert before the query cancels itself
    ERRORFILE = 'enter path here'
  );

----------------------------------------------------------------------------------------------------

DECLARE @StageID varchar(MAX)
DECLARE @Count int
DECLARE @FKRefernece varchar(8)

--Parsing the data
WHILE EXISTS(SELECT * FROM #Imports)
BEGIN 

     SELECT TOP 1 @StageID = Content FROM #Imports --we are gonna use stage ID to keep track of what row we are on for reference and to remove when finished
     SELECT TOP 1 @Count = LEN(Content) - LEN(REPLACE(Content, ',', '')) FROM #Imports --number to show if row we are on is a header or dat row
     
     CASE WHEN @Count = 3 --If header row
     THEN BEGIN
     																																									
					SELECT @FKReference = SUBSTRING(@StageID,1,8) --Gets the foreign key that we will be inserting
																																																						
     
             	                                         
                                                      