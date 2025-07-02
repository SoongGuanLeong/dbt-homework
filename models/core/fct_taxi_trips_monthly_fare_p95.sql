{{
    config(
        materialized='table'
    )
}}

with trips as (
    select *,
    EXTRACT(YEAR FROM pickup_datetime) AS year,
    EXTRACT(MONTH FROM pickup_datetime) AS month,
    CONCAT(service_type, '_', EXTRACT(YEAR FROM pickup_datetime), '_', EXTRACT(MONTH FROM pickup_datetime)) AS service_type_year_month,

    from {{ ref('fact_trips') }}
),

trips2 AS (
    SELECT *,
    {{ fivetran_utils.percentile(percentile_field='fare_amount', partition_field='service_type_year_month', percent='0.97') }} AS p97,
    {{ fivetran_utils.percentile(percentile_field='fare_amount', partition_field='service_type_year_month', percent='0.95') }} AS p95,
    {{ fivetran_utils.percentile(percentile_field='fare_amount', partition_field='service_type_year_month', percent='0.90') }} AS p90,
    row_number()over(partition by service_type_year_month) as rn
    FROM trips
    WHERE
    fare_amount > 0 
    AND trip_distance > 0 
    AND payment_type_description IN ('Cash', 'Credit card')
    {% if target.type == 'postgres' %} group by service_type_year_month {% endif %}
)

SELECT 
    service_type, year, month, p97, p95, p90
FROM trips2
WHERE rn = 1
ORDER BY 1, 2, 3
