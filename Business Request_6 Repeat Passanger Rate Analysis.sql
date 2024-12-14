/*Generate a report that calculates two metrics:
1. Monthly Repeat Passenger Rate: Calculate the repeat passenger rate for each city and month 
by comparing the number of repeat passengers to the total passengers.
2. City-wide Repeat Passenger Rate: Calculate the overall repeat passenger rate for each city, 
considering all passengers across months.
These metrics will provide insights into monthly repeat trends as well as the overall repeat behaviour for each city.
Fields:
city_name,
month,
total_passengers,
repeat_passengers,
monthly_repeat_passenger_rate,
city_repeat_passenger_rate
*/
# Select the database trips_db to run this query.

with city_level_calculation as
(select city_name, 
monthname(month) as month, 
total_passengers,
repeat_passengers,
concat(round((repeat_passengers/total_passengers)*100, 2)," %") as monthly_repeat_passenger_rate
from fact_passenger_summary fps join dim_city dc on dc.city_id = fps.city_id),

aggregation_table as 
(select city_name, 
concat(round(sum(repeat_passengers)/sum(total_passengers)*100, 2)," %") as city_repeat_passenger_rate
from fact_passenger_summary fps join dim_city dc on dc.city_id = fps.city_id
group by dc.city_name)

select 
t1.city_name, 
month, 
total_passengers, 
repeat_passengers, 
monthly_repeat_passenger_rate, 
city_repeat_passenger_rate 
from city_level_calculation t1 join aggregation_table t2 on t1.city_name = t2.city_name;