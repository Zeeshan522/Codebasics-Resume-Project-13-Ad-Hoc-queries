/* Business request 1
Generate a report that displays the total trips, average fare per km, average fare per trip and 
the percentage contribution of each city's trips to the overall trips. 
This report will help in assessing trip volume, pricing efficiency and each city's contribution to 
the overall trip count. 
*/

# select the database trips_db to run this query


Create index i_city_name on dim_city(city_name);
create index i_trip_id on fact_trips (trip_id);

with city_level_aggregation as
(select 
dc.city_name, 
count(distinct(ft.trip_id)) as total_trips,
sum(ft.fare_amount)/sum(ft.distance_travelled_km) as avg_fare_per_km,
sum(ft.fare_amount)/count(distinct(ft.trip_id)) as avg_fare_per_trip
from 
dim_city dc join
fact_trips ft on ft.city_id = dc.city_id
group by city_name)
select  distinct t1.city_name, 
total_trips, 
concat("INR ", avg_fare_per_km) as avg_fare_per_km, 
concat("INR ", avg_fare_per_trip) as avg_fare_per_trip, 
concat(round((total_trips/count((ft.trip_id)) over ())*100, 2)," %") as percent_contribution_to_total_trips
from city_level_aggregation t1 join dim_city dc on t1.city_name = dc.city_name
join fact_trips ft on ft. city_id = dc.city_id
order by total_trips desc;