# Select the database trips_db to run this query.

with trip_count_table as 
(select 
city_name, 
monthname(date) as month_name, 
count(trip_id) as actual_trips 
from trips_db.fact_trips a1 join trips_db.dim_city a2 on a1.city_id = a2.city_id
group by city_name, month_name),
target_table as 
(select city_name, monthname(month) as month_name, total_target_trips 
from targets_db.monthly_target_trips b1 join trips_db.dim_city b2 on b1.city_id = b2.city_id),
combined_table as 
(select trip_count_table.city_name, trip_count_table.month_name, actual_trips, total_target_trips 
from trip_count_table join target_table on trip_count_table.city_name = target_table.city_name and trip_count_table.month_name = target_table.month_name),
final_table as 
(select *, 
(case 
when (actual_trips - total_target_trips) > 0 then "Above Target"
when (actual_trips - total_target_trips) < 0 then "Below Target"
end) as performance_status,
concat((round((((actual_trips - total_target_trips)/total_target_trips)*100),2)), " %") as percent_difference
from combined_table)

select * from final_table
order by city_name, 
case when month_name = "January" then 1
when month_name = "February" then 2
when month_name = "March" then 3
when month_name = "April" then 4
when month_name = "May" then 5
when month_name = "June" then 6
when month_name = "July" then 7
when month_name = "August" then 8
when month_name = "September" then 9
when month_name = "October" then 10
when month_name = "November" then 11
when month_name = "December" then 12 end;


