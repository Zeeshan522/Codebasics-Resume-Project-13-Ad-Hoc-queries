/*Generate a report that calculates the total new passengers for each city and ranks them based on this value. 
Identify the top 3 cities with the highest number of new passengers as well as the bottom 3 cities with the lowest number of new passengers, 
categorising them as "Top 3" or "Bottom 3" accordingly.
Fields:
city_name,
total_new_passengers,
city_category
*/

# Select the database trips_db to run this query.

with city_new_passengers as (select city_name, sum(new_passengers) as total_new_passengers
from dim_city db join fact_passenger_summary fps on db.city_id = fps.city_id
group by db.city_id),

city_ranking as (select city_name, total_new_passengers, row_number() over (order by total_new_passengers) as bottom_ranks,
row_number() over (order by total_new_passengers desc) as top_ranks
from city_new_passengers)

select 
city_name, 
total_new_passengers, 
(case when top_ranks < 4 then "Top 3" 
when bottom_ranks < 4 then "Bottom 3" else "Other" end) city_category 
from city_ranking;