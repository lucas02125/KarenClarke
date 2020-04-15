--Converting the varchar values to float 
UPDATE HurricaneData hd set hd.hd_Longitude = '-' + hd.hd_Longitude --Providing the longitude coordinates with their -
UPDATE HurricaneData hd set hd.hd_Longitude = REPLACE(hd.hd_Longitude, 'W','') --Gets rid of the Letters
,hd.hd_Latitude = REPLACE(hd.hd_Latitude, 'N','')

ALTER TABLE HurricaneData ALTER COLUMN hd_latitude float -- changing them to float time to be used in function
ALTER TABLE HurricaneData ALTER COLUMN hd_longitude float

-------------------------------------------------------------

SELECT 
REPLACE(hh.hh_Name,' ','') as 'Name of Hurricane' -- Values coming back from this file have uneeded white space so the Replace function is to remove 
,hh.hh_Date as 'Date of Landfall' --No specification of time as this is just required for time
,hd.hd_windspeed as 'Max Wind Speed'
FROM dbo.HurricaneHeader hh 
INNER JOIN dbo.HurricaneData hd ON hh.hh_Value = hd.hd_hh_Value --Inner join with header data and row data to join data of wind speed and date/Name
WHERE hd.hd_date > '1900-01-01' --Since 1900
AND hd.hd_status = 'HU' --Ensuring status is a Hurricane
AND (
      SELECT hd.hd_longitude,
             hd.hd_latitude
             from [dbo].[isItInFlorida]
             Where @insidePolygon = 1) as 'Coordinate Check' --Sub query used to call the function for only targets that are within Florida


/* For the longitude and latitude I had ideas of taking in as geography data type but converting seemed a bit too tricky
I used a startpoint and enpoint of latitude and longitude for the area of Florida and used the between clause to have an general data return 
of areas the storm could hit in the Florida region

Potentially incorrporating an index for the startpoints and endpoints of the coordinates to enhance result performance/speed

AND hd.hd_identifier = 'L' As suggested in email, not to use Landfall identifier as 
*/






