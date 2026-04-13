SELECT
    -- identifiers
    CAST(vendorid AS INT64) AS vendor_id,
    CAST(ratecodeid AS INT64) AS rate_code_id,
    CAST(pulocationid AS INT64) AS pickup_location_id,
    CAST(dolocationid AS INT64) AS dropoff_location_id,

    -- timestamps
    CAST(lpep_pickup_datetime AS TIMESTAMP) AS pickup_datetime,
    CAST(lpep_dropoff_datetime AS TIMESTAMP) AS dropoff_datetime,

    -- trip info
    store_and_fwd_flag,
    CAST(passenger_count AS INT64) AS passenger_count,
    CAST(trip_distance AS FLOAT64) AS trip_distance,
    CAST(trip_type AS INT64) AS trip_type,

    -- payment info
    CAST(fare_amount AS NUMERIC) AS fare_amount,
    CAST(extra AS NUMERIC) AS extra,
    CAST(ehail_fee AS NUMERIC) AS ehail_fee,
    CAST(mta_tax AS NUMERIC) AS mta_tax,
    CAST(tip_amount AS NUMERIC) AS tip_amount,
    CAST(tolls_amount AS NUMERIC) AS tolls_amount,
    CAST(improvement_surcharge AS NUMERIC) AS improvement_surcharge,
    CAST(total_amount AS NUMERIC) AS total_amount,
    CAST(payment_type AS INT64) AS payment_type

FROM {{ source('raw_data', 'green_tripdata') }}
WHERE vendorid IS NOT NULL
