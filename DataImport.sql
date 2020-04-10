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
