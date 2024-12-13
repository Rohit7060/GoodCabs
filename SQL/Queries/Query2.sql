#BUSINESS REQUEST 2
#Monthly City Level Trips Target Performance Report               


 
 
 
WITH a as(
SELECT
	month,c.city_name as city_name, 
	total_target_trips as target_trips 
FROM 
	targets_db.monthly_target_trips mt
JOIN 
	dim_city c ON c.city_id = mt.city_id
GROUP BY 
	c.city_id,month
),

b as (
SELECT 
	c.city_name, d.start_of_month as start_date,
       Count(distinctrow(f.trip_id)) as actual_trips
FROM 
	dim_city c
JOIN
	fact_trips f ON c.city_id = f.city_id
JOIN 
	dim_date d ON d.date = f.date
GROUP BY 
	c.city_name, d.start_of_month
)

SELECT 
	a.city_name, monthname(a.month) as month_name, 
    b.actual_trips, a.target_trips,
	case 
		when b.actual_trips > a.target_trips then "Above Target"
		else "Below Target"
		end as performance_status,
	concat(round((((b.actual_trips- a.target_trips)/ a.target_trips)*100),2), " %") as percent_difference
FROM a
JOIN b  on a.city_name = b.city_name and a.month = b.start_date
ORDER BY a.city_name, a.month ;
