DECLARE @startpointLat varchar(6) = '25.0N'
DECLARE @endpointLat varchar(6) = '31.0N'
DECLARE @startpointLong varchar(6) = '80.0W'
DECLARE @endpointLong varchar(6) = '87.5W'

SELECT 
REPLACE(hh.hh_Name,' ','') as 'Name of Hurricane' -- Values coming back from this file have uneeded white space so the Replace function is to remove 
,hh.hh_Date as 'Date of Landfall' --No specification of time as this is just required for time
,hd.hd_windspeed as 'Max Wind Speed'
FROM dbo.HurricaneHeader hh 
INNER JOIN dbo.HurricaneData hd ON hh.hh_Value = hd.hd_hh_Value --Inner join with header data and row data to join data of wind speed and date/Name
WHERE hd.hd_date > '1900-01-01' --Since 1900
AND hd.hd_status = 'HU' --Ensuring status is a Hurricane
AND hd.hd_latitude BETWEEN @startpointLat AND @endpointLat
AND hd.hd_longitude BETWEEN @startpointLong AND @endpointLong
/* For the longitude and latitude I had ideas of taking in as geography data type but converting seemed a bit too tricky
I used a startpoint and enpoint of latitude and longitude for the area of Florida and used the between clause to have an general data return 
of areas the storm could hit in the Florida region
AND hd.hd_identifier = 'L' As suggested in email, not to use Landfall identifier as 
*/






