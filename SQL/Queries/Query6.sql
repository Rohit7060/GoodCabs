# REQUEST 6
# Repeat Passenger Rate Analysis

SELECT 
	c.city_name, monthname(s.month) as month, 
	sum(s.repeat_passengers) as total_repeat_passengers,
	sum(s.total_passengers) as total_passengers,
	concat(round((s.repeat_passengers*100/s.total_passengers),2), " %") as monthly_repeat_passenger_rate,
    concat(round(sum(s.repeat_passengers) OVER(partition by c.city_id)*100/sum(s.total_passengers)OVER(partition by c.city_id),2), " %") as city_repeat_passenger_rate
FROM 
	fact_passenger_summary s
JOIN 
	dim_city c
ON 
	c.city_id = s.city_id

WHERE 
	s.total_passengers> 0
GROUP BY c.city_id, month
ORDER BY 
	city_name, s.month;
