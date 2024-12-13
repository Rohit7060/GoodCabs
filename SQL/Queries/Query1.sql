#BUSINESS REQUEST 1

#City Level Fare and Trip Summary Report


WITH total AS (
SELECT count(trip_id) AS total_trips
FROM fact_trips),

city_trips AS (
SELECT 
      c.city_name, count(f.trip_id) AS city_total_trips,
      round(sum(fare_amount)/sum(distance_travelled_km),2) AS Avg_Fare_per_km,
      round(sum(fare_amount)/count(trip_id),2) AS Avg_Fare_per_Trip

FROM 
      dim_city c
LEFT JOIN 
     fact_trips f
ON 
	 c.city_id = f.city_id
     
GROUP BY c.city_name
)

SELECT 
       city_trips.city_name, city_trips.city_total_trips, 
       city_trips.Avg_Fare_per_km, 
	   city_trips.Avg_Fare_per_Trip, 
	   concat(round((city_trips.city_total_trips/total.total_trips)*100,2), " %") AS pct_contribution
FROM 
       city_trips
JOIN 
	   total
ON 1 = 1
ORDER BY pct_contribution DESC ;
