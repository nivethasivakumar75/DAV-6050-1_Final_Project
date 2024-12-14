-- Insert data into date_dim
INSERT INTO green_taxi_dw.date_dim (date, year, month, day, hour)
SELECT 
    DATE(lpep_pickup_datetime) AS date,
    EXTRACT(YEAR FROM lpep_pickup_datetime) AS year,
    EXTRACT(MONTH FROM lpep_pickup_datetime) AS month,
    EXTRACT(DAY FROM lpep_pickup_datetime) AS day,
    EXTRACT(HOUR FROM lpep_pickup_datetime) AS hour
FROM green_taxi_db.trips
GROUP BY 1, 2, 3, 4, 5;

SELECT COUNT(*) FROM green_taxi_dw.date_dim;

-----------------------------------------------------------------------------------------------------------------------------------
-- Insert data into trip_type_dim
INSERT INTO green_taxi_dw.trip_type_dim (trip_type)
SELECT DISTINCT trip_type FROM green_taxi_db.trips;

SELECT * FROM green_taxi_dw.trip_type_dim;

-----------------------------------------------------------------------------------------------------------------------------------
-- Insert data into passenger_dim
INSERT INTO green_taxi_dw.passenger_dim (passenger_count)
SELECT DISTINCT passenger_count FROM green_taxi_db.trips
ORDER BY passenger_count;

SELECT * FROM green_taxi_dw.passenger_dim;

-----------------------------------------------------------------------------------------------------------------------------------
-- Insert data into payment_type_dim
INSERT INTO green_taxi_dw.payment_type_dim (payment_type)
SELECT DISTINCT payment_type FROM green_taxi_db.trips
ORDER BY payment_type;

SELECT * FROM green_taxi_dw.payment_type_dim;

-----------------------------------------------------------------------------------------------------------------------------------
-- Insert data into weather_dim
INSERT INTO green_taxi_dw.weather_dim (weather_recorded_date, hour, temp, feelslike, dew, humidity, precip, snow, windspeed, icon)
SELECT 
    source_date AS weather_recorded_date, 
    hour, 
    temp, 
    feelslike, 
    dew, 
    humidity, 
    precip, 
    snow, 
    windspeed, 
    icon
FROM green_taxi_db.trips
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10;

SELECT COUNT(*) FROM green_taxi_dw.weather_dim;

-----------------------------------------------------------------------------------------------------------------------------------
-- Insert data into rate_code_dim
INSERT INTO green_taxi_dw.rate_code_dim (rate_code)
SELECT DISTINCT RatecodeID AS rate_code FROM green_taxi_db.trips
ORDER BY RatecodeID;

SELECT * FROM green_taxi_dw.rate_code_dim;

-----------------------------------------------------------------------------------------------------------------------------------
-- Insert data into fact_table
INSERT INTO green_taxi_dw.fact_table (
    sk_date, sk_trip_type, sk_passenger, sk_payment_type, sk_weather, sk_rate_code, 
    trip_distance, fare_amount, tip_amount, extra_amount, mta_tax, 
    improvement_surcharge, tolls_amount, total_amount, congestion_surcharge
)
SELECT 
    B.sk_date,
    C.sk_trip_type,
    D.sk_passenger,
    E.sk_payment_type,
    F.sk_weather,
    G.sk_rate_code,
    AVG(trip_distance) AS trip_distance,
    AVG(fare_amount) AS fare_amount,
    AVG(tip_amount) AS tip_amount,
    AVG(extra) AS extra_amount,
    AVG(mta_tax) AS mta_tax,
    AVG(improvement_surcharge) AS improvement_surcharge,
    AVG(tolls_amount) AS tolls_amount,
    AVG(total_amount) AS total_amount,
    AVG(congestion_surcharge) AS congestion_surcharge
FROM 
    green_taxi_db.trips A
JOIN green_taxi_dw.date_dim B 
    ON A.source_date = B.date AND EXTRACT(HOUR FROM A.lpep_pickup_datetime) = B.hour
JOIN green_taxi_dw.trip_type_dim C 
    ON A.trip_type = C.trip_type
JOIN green_taxi_dw.passenger_dim D 
    ON A.passenger_count = D.passenger_count
JOIN green_taxi_dw.payment_type_dim E 
    ON A.payment_type = E.payment_type
JOIN green_taxi_dw.weather_dim F 
    ON A.source_date = F.weather_recorded_date AND EXTRACT(HOUR FROM A.lpep_pickup_datetime) = F.hour
JOIN green_taxi_dw.rate_code_dim G 
    ON A.RatecodeID = G.rate_code
GROUP BY 1, 2, 3, 4, 5, 6;

SELECT COUNT(*) FROM green_taxi_dw.fact_table;
