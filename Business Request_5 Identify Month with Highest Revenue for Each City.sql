/*Generate a report that identifies the month with the highest revenue for each city. 
For each city, display the month name, the revenue amount for that month, and the percentage contribution of that month's revenue to the city's total revenue.
Fields:
city_name,
highest_revenue_month,
revenue,
percent_contribution_to_city's_total_revenue
*/

# Select the database trips_db to run this query.

with city_monthly_revenue as 
(select dc.city_name, 
monthname(date) as month_name, 
sum(fare_amount) as total_revenue
from dim_city dc join fact_trips ft on dc.city_id = ft.city_id
group by city_name, month_name),

monthly_revenue_ranking as 
(select *,
row_number() over (partition by city_name order by total_revenue desc
rows between unbounded preceding and unbounded following) as month_ranking 
from city_monthly_revenue),

city_total_revenue as 
(select city_name, 
sum(total_revenue) as city_total_revenue 
from monthly_revenue_ranking group by city_name)

select ctr.city_name, 
month_name as highest_revenue_month, 
concat("INR ", total_revenue) as revenue, 
concat(round(((total_revenue/city_total_revenue)*100),2)," %") as percent_contribution_to_city_total_revenue
from city_total_revenue ctr join monthly_revenue_ranking mrr on mrr.city_name = ctr.city_name
where month_ranking = 1
order by revenue desc;