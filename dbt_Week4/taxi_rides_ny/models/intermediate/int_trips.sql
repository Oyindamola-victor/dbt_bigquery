-- Enrich and deduplicate trip data (BigQuery: QUALIFY supported natively)

WITH unioned AS (
    SELECT * FROM {{ ref('int_trips_unioned') }}
),

payment_types AS (
    SELECT * FROM {{ ref('payment_type_lookup') }}
),

cleaned_and_enriched AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['u.vendor_id', 'u.pickup_datetime', 'u.pickup_location_id', 'u.service_type']) }} AS trip_id,

        u.vendor_id,
        u.service_type,
        u.rate_code_id,

        u.pickup_location_id,
        u.dropoff_location_id,

        u.pickup_datetime,
        u.dropoff_datetime,

        u.store_and_fwd_flag,
        u.passenger_count,
        u.trip_distance,
        u.trip_type,

        u.fare_amount,
        u.extra,
        u.mta_tax,
        u.tip_amount,
        u.tolls_amount,
        u.ehail_fee,
        u.improvement_surcharge,
        u.total_amount,

        COALESCE(u.payment_type, 0) AS payment_type,
        COALESCE(pt.description, 'Unknown') AS payment_type_description

    FROM unioned AS u
    LEFT JOIN payment_types AS pt
        ON COALESCE(u.payment_type, 0) = pt.payment_type
)

SELECT * FROM cleaned_and_enriched
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY vendor_id, pickup_datetime, pickup_location_id, service_type
    ORDER BY dropoff_datetime
) = 1
