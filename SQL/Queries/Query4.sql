# REQUEST 4 
#Identify Cities with the Highest and Lowest Total New Passengers

with total_new_passengers as(
select 
	ps.city_id, c.city_name, 
	sum(new_passengers) as total_new_passengers
FROM 
	fact_passenger_summary ps
JOIN 
	dim_city c
ON 
	c.city_id = ps.city_id
GROUP BY
	ps.city_id, c.city_name),

city_ranking as (
SELECT 
	city_name, total_new_passengers,
    dense_rank() over( order by total_new_passengers DESC) as "top_ranking",
    dense_rank()over( order by total_new_passengers ASC) as "bottom_ranking"
FROM 
	total_new_passengers)
SELECT
	city_name, total_new_passengers,
    case when top_ranking <=3 then "Top 3"
         when bottom_ranking <=3 then " Bottom 3"
         else null
	END AS city_category
FROM 
	city_ranking
WHERE
	top_ranking <=3 OR bottom_ranking<=3
ORDER BY total_new_passengers DESC ;
