create or replace database  temp;

use database temp;
use SCHEMA temp.TEMP;


use role A_SC_TEMP_TEMP_DBA;


create or replace table temp.temp.trips
(tripduration integer,
starttime timestamp,
stoptime timestamp,
start_station_id integer,
start_station_name string,
start_station_latitude float,
start_station_longitude float,
end_station_id integer,
end_station_name string,
end_station_latitude float,
end_station_longitude float,
bikeid integer,
membership_type string,
usertype string,
birth_year integer,
gender integer);


use temp;
use schema temp.temp_2;

use role A_SC_TEMP_TEMP_2_DBA;



create or replace table temp.temp_2.trips_12
(tripduration integer,
starttime timestamp,
stoptime timestamp,
start_station_id integer,
start_station_name string,
start_station_latitude float,
start_station_longitude float,
end_station_id integer,
end_station_name string,
end_station_latitude float,
end_station_longitude float,
bikeid integer,
membership_type string,
usertype string,
birth_year integer,
gender integer);

use role A_SC_TEMP_TEMP_2_DBA;
select * from temp.temp_2.trips_12; --성공
select * from temp.temp.trips;--실패

use role A_SC_TEMP_TEMP_DBA;

select * from temp.temp_2.trips_12; --실패
select * from temp.temp.trips; -- 성공
