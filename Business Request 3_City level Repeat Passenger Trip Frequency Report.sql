/*Generate a report that shows the percentage distribution of repeat passengers by the number of trips they have taken in each city. 
Calculate the percentage of repeat passengers who took 2 trips, 3 trips, and so on, up to 10 trips.
Each column should represent a trip count category, displaying the percentage of repeat passengers 
who fall into that category out of the total repeat passengers for that city.
This report will help identify cities with high repeat trip frequency, which can indicate strong customer loyalty or frequent usage patterns.
Fields:
city_name,
2-trips,
3-trips,...
10-trips
*/

# Select the database trips_db to run this query.  

with city_total_repeat_passengers as 
(select dc.city_name, sum(repeat_passenger_count) as total_repeat_passengers 
from dim_city dc join dim_repeat_trip_distribution drtd on dc.city_id = drtd.city_id
group by city_name), 

repeat_passenger_trip_count as 
(select city_name, trip_count, sum(repeat_passenger_count) as repeat_passenger_count 
from dim_city dc join dim_repeat_trip_distribution drtd on dc.city_id = drtd.city_id
group by city_name, trip_count),

combined_table as 
(select t1.city_name, total_repeat_passengers, trip_count, repeat_passenger_count 
from city_total_repeat_passengers t1 join repeat_passenger_trip_count t2 on t1.city_name = t2.city_name)

select 
city_name,  
concat(round((sum((case when trip_count = "2-Trips" then repeat_passenger_count else 0 end))/total_repeat_passengers)*100,2), " %") as 2_trips,
concat(round((sum((case when trip_count = "3-Trips" then repeat_passenger_count else 0 end))/total_repeat_passengers)*100,2), " %") as 3_trips,
concat(round((sum((case when trip_count = "4-Trips" then repeat_passenger_count else 0 end))/total_repeat_passengers)*100,2), " %") as 4_trips,
concat(round((sum((case when trip_count = "5-Trips" then repeat_passenger_count else 0 end))/total_repeat_passengers)*100,2), " %") as 5_trips,
concat(round((sum((case when trip_count = "6-Trips" then repeat_passenger_count else 0 end))/total_repeat_passengers)*100,2), " %") as 6_trips,
concat(round((sum((case when trip_count = "7-Trips" then repeat_passenger_count else 0 end))/total_repeat_passengers)*100,2), " %") as 7_trips,
concat(round((sum((case when trip_count = "8-Trips" then repeat_passenger_count else 0 end))/total_repeat_passengers)*100,2), " %") as 8_trips,
concat(round((sum((case when trip_count = "9-Trips" then repeat_passenger_count else 0 end))/total_repeat_passengers)*100,2), " %") as 9_trips,
concat(round((sum((case when trip_count = "10-Trips" then repeat_passenger_count else 0 end))/total_repeat_passengers)*100,2), " %") as 10_trips
from combined_table
group by city_name
order by city_name;
 
 