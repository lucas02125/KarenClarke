CREATE TABLE Florida( --This table will store the full polygon 
    point int,
    latitude float,
    longitude float
)

INSERT INTO Florida
VALUES
 (1,-88.0,31.0)
,(2,-81.5,31.4)
,(3,-80.1,26.6)
,(4,-82.9,28.0)
,(5,-85.0,29.7)
,(6,-87.3,30.4)

--------------------------------------------------------
/*
  this function is expected to take in coordinate parameters and perform an in point algorithm of what is applied to above and return with a 
  bit value stating whether or not the storm is within landfall of the penninsula
*/

CREATE FUNCTION [dbo].[isItInFlorida]
(
    -- Add the parameters for the function here
    @pointLat FLOAT, 
    @pointLon FLOAT
)
RETURNS INT --Value that will be passed back to determine
AS
BEGIN
   
    DECLARE @insidePolygon INT

    DECLARE @nvert INT   
    DECLARE @lineLat1 FLOAT
    DECLARE @lineLon1 FLOAT
    DECLARE @lineLat2 FLOAT--Valriables that will be used to perform a calculation to see if it lies within Floarida
    DECLARE @lineLon2 FLOAT

    DECLARE @i INT
    DECLARE @j INT

    SELECT @nvert=count(*) FROM Florida --Will help with looping through all coordinate points

    SET @insidePolygon = -1 -- Value represented as false
    SET @i=0
    SET @j=@nvert-1 --5

    WHILE (@i<=@nvert) -- Continue looping until all coordinates are iterrated 
    BEGIN
        SELECT @lineLat1 = latitude, ---79.62194
	      @lineLon1 = longitude --43.97181
        FROM Something 
        WHERE point = @i

        SELECT @lineLat2 = latitude,--79.64452
	    @lineLon2 = longitude --44.06773
        FROM Something 
        WHERE point = @j

        IF( ((@lineLon1>@pointLon and @lineLon2<=@pointLon) OR (@lineLon1<=@pointLon and @lineLon2>@pointLon)) --This if statement checks to see if the longitude lies within any of the potential parameters of the coordinate
            AND (@pointLat < (																                                                  
              (@lineLat2 - @lineLat1) * (@pointLon - @lineLon1) / (@lineLon2 - @lineLon1)    --Calculation check made to see if the result will exceed 
              + @lineLat1				
                    )																								                                            
                )
            )
            SET @insidePolygon = -1 * @insidePolygon --Should the end result lie in the polygon, the value is set to true, 1 false remains -1
       
        SET @j = @i --@j = 0
        SET @i = @i + 1 --@i = 1
       
    END

    IF (@@ERROR <> 0) RETURN 0 --COrrect error handling

    RETURN @insidePolygon--returns result

END
GO
