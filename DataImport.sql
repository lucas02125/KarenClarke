/*  What I intend to do here is to import and load the HUDART data into a staging table and then split the content based on 
its values content into either the header or data table
*/
--Importing text file into staging table
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
    ERRORFILE = 'enter path here' --Destination file to record if any syntax errors occurr. Providing logging  
  );

----------------------------------------------------------------------------------------------------

DECLARE @StageID varchar(MAX)
DECLARE @Count int
DECLARE @FKRefernece varchar(8)

--Parsing the data
WHILE EXISTS(SELECT * FROM #Imports) --While loop will continue to process until staging file has gone through entirely
BEGIN 

     SELECT TOP 1 @StageID = Content FROM #Imports --we are gonna use stage ID to keep track of what row we are on for reference and to remove when finished
     SELECT TOP 1 @Count = LEN(Content) - LEN(REPLACE(Content, ',', '')) FROM #Imports --number to show if row we are on is a header or dat row
     
     ;WITH r2c AS ( --CTE table declaration
    	SELECT value
    	,ROW_NUMBER() OVER(PARTITION BY @StageID ORDER BY (SELECT NULL) as pr --ROW_NUMBER function will provide a number for each value in the @StageID variable (1)
    	FROM #Imports i 
	   CROSS APPLY STRING_SPLIT(@StageID, ',') as spt --STRING_SPLIT splits the string based on the delimiter ,. With Cross apply the row number will be assigned to each new row from the split
	)					      
						      
						      
     IF @Count = 3 --If header row
     BEGIN TRY --Declared to catch any potential errros
     	
	BEGIN tran --Transaction to help commit and rollback changes that could be implemented on the table																																								
	SET @FKReference = SUBSTRING(@StageID,1,8) --Gets the foreign key that we will be inserting
	INSERT INTO HurricaneHeader		
	     SELECT cast(pr.[1] as varchar(8))
         ,cast(pr.[2] as varchar(50))
         ,cast(pr.[3] as int)	
	     FROM r2c	
	COMMIT tran --publishes changes onto table			
																																																			
     END TRY
     BEGIN CATCH --Catch will capture the error, if any
	IF(@@TRANCOUNT > 1)--Checks to see if potential errors that would result in a rollback
	BEGIN
		ROLLBACK tran
	END			
	PRINT @@ERROR_MESSAGE() as 'Error Message' --Displays what the error is appearing 
	PRINT @@ERROR_LINE() as 'Line of Error'
     END CATCH;
     
     ELSE --If data row
     BEGIN TRY
        
	BEGIN TRAN
				 
       INSERT INTO HurricaneData		
	     SELECT @FKReference --using FK declared from when the header row was declared 
	    ,cast(pr.[1] as date) --adding in the values from the CTE and casting them to fit in what is required from table schema
            ,cast(pr.[2] as int)
            ,cast(pr.[3] as varchar(1))
	    ,cast(pr.[4] as varchar(2))
	    ,cast(pr.[5] as varchar(10))
	    ,cast(pr.[6] as varchar(10))
	    ,cast(pr.[7] as int)
	    ,cast(pr.[8] as int)
	    ,cast(pr.[9] as int)
	    ,cast(pr.[10] as int)
	    ,cast(pr.[11] as int)
	    ,cast(pr.[12] as int)
	    ,cast(pr.[13] as int)
	    ,cast(pr.[14] as int)
	    ,cast(pr.[15] as int)
	    ,cast(pr.[16] as int)
	    ,cast(pr.[17] as int)
	    ,cast(pr.[18] as int)
	    ,cast(pr.[19] as int)		
	     FROM r2c	
	COMMIT Tran
     END TRY
     BEGIN CATCH
	IF(@@TRANCOUNT > 1)--Checks to see if potential errors that would result in a rollback
	BEGIN
		ROLLBACK tran --Reverts changes back to original state
	END				    
	PRINT @@ERROR_MESSAGE() as 'Error Message' --Displays what the error is appearing 
	PRINT @@ERROR_LINE() as 'Line of Error'
     END CATCH;
     
        DELETE FROM #Imports where content = @StageID --This record will remove the top row of the staging table and continue to do so in the while loop until staging table is gone
END
             	                                         
                                                      
