{{
    config(
        materialized='table'
    )
}}

with trips as (
    select *,
    CONCAT(year, '_', month, '_', pickup_locationid, '_', dropoff_locationid) AS y_m_pu_locid_do_locid,
    TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS trip_duration
    from {{ ref('dim_fhv_trips') }}
),
trips2 AS (
    SELECT *,
     {{ fivetran_utils.percentile(percentile_field='trip_duration', partition_field='y_m_pu_locid_do_locid', percent='0.9') }} AS p90
    FROM trips
    {% if target.type == 'postgres' %} group by y_m_pu_locid_do_locid {% endif %}
)
SELECT *
FROM trips2
WHERE year=2019
AND month=11
AND pickup_zone IN ("Newark Airport", "SoHo", "Yorkville East")
ORDER BY p90 DESC
