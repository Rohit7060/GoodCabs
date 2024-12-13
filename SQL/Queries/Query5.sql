#REQUEST 5
#Identify the month with the highest revenue for each city

WITH ranking AS (
    SELECT 
        t.city_id,
        MONTHNAME(d.date) AS month,
        SUM(t.fare_amount) AS total_revenue,
        DENSE_RANK() OVER (PARTITION BY t.city_id ORDER BY SUM(t.fare_amount) DESC) AS ranking
    FROM 
        fact_trips t
    JOIN 
        dim_date d
    ON 
        d.date = t.date
    JOIN 
        dim_city c
    ON 
        c.city_id = t.city_id
    GROUP BY 
        t.city_id, MONTHNAME(d.date)
),
aggregated AS (
    SELECT 
        r.city_id,
        r.month,
        r.total_revenue,
        c.city_name,
        SUM(r.total_revenue) OVER (PARTITION BY r.city_id) AS total_city_revenue,
        r.ranking
    FROM 
        ranking r
    JOIN 
        dim_city c
    ON 
        r.city_id = c.city_id
)
SELECT 
    city_name,
    month as highest_revenue_month,
    CONCAT(ROUND(total_revenue / 1000000, 3), " M") AS revenue,
    CONCAT(ROUND((total_revenue * 100.0 / total_city_revenue), 2), " %") AS percentage_contribution
FROM 
    aggregated
WHERE 
    ranking <= 1
ORDER BY 
    percentage_contribution DESC;
