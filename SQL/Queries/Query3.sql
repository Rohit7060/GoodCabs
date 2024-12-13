#BUSINESS REQUEST 3

#City Level Repeat Passenger Trip Frequency Report

 
WITH repeat_passenger AS (
  SELECT 
    c.city_name, 
    dr.city_id,
    SUM(dr.repeat_passenger_count) AS total_repeat_passenger
  FROM 
    dim_city c 
  JOIN 
    dim_repeat_trip_distribution dr 
  ON 
    c.city_id = dr.city_id
  GROUP BY 
    c.city_name, dr.city_id
)

SELECT 
    rp.city_name,
    ROUND(SUM(CASE 
      WHEN td.trip_count = '2-Trips' THEN td.repeat_passenger_count * 100.0 / rp.total_repeat_passenger ELSE 0 
    END), 2) AS `2_Trips`,
    ROUND(SUM(CASE 
      WHEN td.trip_count = '3-Trips' THEN td.repeat_passenger_count * 100.0 / rp.total_repeat_passenger ELSE 0 
    END), 2) AS `3_Trips`,
    ROUND(SUM(CASE 
      WHEN td.trip_count = '4-Trips' THEN td.repeat_passenger_count * 100.0 / rp.total_repeat_passenger ELSE 0 
    END), 2) AS `4_Trips`,
    ROUND(SUM(CASE 
      WHEN td.trip_count = '5-Trips' THEN td.repeat_passenger_count * 100.0 / rp.total_repeat_passenger ELSE 0 
    END), 2) AS `5_Trips`,
    ROUND(SUM(CASE 
      WHEN td.trip_count = '6-Trips' THEN td.repeat_passenger_count * 100.0 / rp.total_repeat_passenger ELSE 0 
    END), 2) AS `6_Trips`,
    ROUND(SUM(CASE 
      WHEN td.trip_count = '7-Trips' THEN td.repeat_passenger_count * 100.0 / rp.total_repeat_passenger ELSE 0 
    END), 2) AS `7_Trips`,
    ROUND(SUM(CASE 
      WHEN td.trip_count = '8-Trips' THEN td.repeat_passenger_count * 100.0 / rp.total_repeat_passenger ELSE 0 
    END), 2) AS `8_Trips`,
    ROUND(SUM(CASE 
      WHEN td.trip_count = '9-Trips' THEN td.repeat_passenger_count * 100.0 / rp.total_repeat_passenger ELSE 0 
    END), 2) AS `9_Trips`,
    ROUND(SUM(CASE 
      WHEN td.trip_count = '10-Trips' THEN td.repeat_passenger_count * 100.0 / rp.total_repeat_passenger ELSE 0 
    END), 2) AS `10_Trips`
FROM 
    dim_repeat_trip_distribution td
JOIN 
    repeat_passenger rp
ON 
    rp.city_id = td.city_id
GROUP BY 
    rp.city_name
ORDER BY 
    rp.city_name;
