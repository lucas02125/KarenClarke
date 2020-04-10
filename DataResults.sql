DECLARE @startpointLat varchar(6) = '25.0N'
DECLARE @endpointLat varchar(6) = '31.0N'
DECLARE @startpointLong varchar(6) = '80.0W'
DECLARE @endpointLong varchar(6) = '87.5W'

SELECT 
REPLACE(hh.hh_Name,' ','') as 'Name of Hurricane' -- Values coming back from this file have uneeded white space so the Replace function is to remove 
,hh.hh_Date as 'Date of Landfall' --No specification of time as this is just required for time
,hd.hd_windspeed as 'Max Wind Speed'
FROM HurricaneHeader hh 
INNER JOIN HurricaneData hd ON hh.hh_Value = hd.hd_hh_Value
WHERE hd.hd_date > '1900-01-01'
AND hd.hd_status = 'HU'
AND hd.hd_latitude BETWEEN @startpointLat AND @endpointLat
AND hd.hd_longitude BETWEEN @startpointLong AND @endpointLong
--AND hd.hd_identifier = 'L'







