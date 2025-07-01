{{
    config(
        materialized='table'
    )
}}

with trips as (
    select * from {{ ref('fact_trips') }}
),
quarterly_trips as (
    SELECT
    service_type,
    EXTRACT(YEAR FROM pickup_datetime) AS year,
    EXTRACT(QUARTER FROM pickup_datetime) AS quarter,
    SUM(total_amount) AS revenue
    FROM trips
    WHERE EXTRACT(YEAR FROM pickup_datetime) IN (2019, 2020)
    GROUP BY 1, 2, 3
    ORDER BY 1, 2, 3
),
lagged as (
    SELECT service_type, year, quarter, revenue,
    LAG(revenue, 4) over (PARTITION BY service_type ORDER BY year, quarter) AS prev_year_revenue
    FROM quarterly_trips
)

SELECT service_type, year, quarter, revenue, prev_year_revenue,
    (revenue - IFNULL(prev_year_revenue, revenue)) / IFNULL(prev_year_revenue, revenue) * 100 AS revenue_growth
FROM lagged
ORDER BY service_type, year, quarter