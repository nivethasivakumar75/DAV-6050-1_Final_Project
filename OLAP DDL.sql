-- Drop schema if it exists
DROP SCHEMA IF EXISTS green_taxi_dw CASCADE;
CREATE SCHEMA green_taxi_dw;

-- Drop tables if they exist
DROP TABLE IF EXISTS green_taxi_dw.date_dim;
DROP TABLE IF EXISTS green_taxi_dw.trip_type_dim;
DROP TABLE IF EXISTS green_taxi_dw.passenger_dim;
DROP TABLE IF EXISTS green_taxi_dw.payment_type_dim;
DROP TABLE IF EXISTS green_taxi_dw.weather_dim;
DROP TABLE IF EXISTS green_taxi_dw.rate_code_dim;
DROP TABLE IF EXISTS green_taxi_dw.fact_table;

-- Create date dimension
CREATE TABLE IF NOT EXISTS green_taxi_dw.date_dim (
    sk_date SERIAL PRIMARY KEY,
    date DATE,
    year INT, 
    month INT,
    day INT,
    hour INT
);

-- Create trip_type dimension
CREATE TABLE IF NOT EXISTS green_taxi_dw.trip_type_dim (
    sk_trip_type SERIAL PRIMARY KEY,
    trip_type INT
);

-- Create passenger dimension
CREATE TABLE IF NOT EXISTS green_taxi_dw.passenger_dim (
    sk_passenger SERIAL PRIMARY KEY,
    passenger_count INT
);

-- Create payment dimension
CREATE TABLE IF NOT EXISTS green_taxi_dw.payment_type_dim (
    sk_payment_type SERIAL PRIMARY KEY,
    payment_type INT
);

-- Create weather dimension
CREATE TABLE IF NOT EXISTS green_taxi_dw.weather_dim (
    sk_weather SERIAL PRIMARY KEY,
    weather_recorded_date DATE,
    hour INT,
    temp NUMERIC(10, 6), 
    feelslike NUMERIC(10, 6),
    dew NUMERIC(10, 6),
    humidity NUMERIC(10, 6),
    precip NUMERIC(10, 6),
    snow NUMERIC(10, 6),
    windspeed NUMERIC(10, 6), 
    icon VARCHAR(100)
);

-- Create rate code dimension
CREATE TABLE IF NOT EXISTS green_taxi_dw.rate_code_dim (
    sk_rate_code SERIAL PRIMARY KEY,
    rate_code INT
);

-- Create fact table
CREATE TABLE IF NOT EXISTS green_taxi_dw.fact_table (
    sk_date INT REFERENCES green_taxi_dw.date_dim(sk_date),
    sk_trip_type INT REFERENCES green_taxi_dw.trip_type_dim(sk_trip_type),
    sk_passenger INT REFERENCES green_taxi_dw.passenger_dim(sk_passenger),
    sk_payment_type INT REFERENCES green_taxi_dw.payment_type_dim(sk_payment_type),
    sk_weather INT REFERENCES green_taxi_dw.weather_dim(sk_weather),
    sk_rate_code INT REFERENCES green_taxi_dw.rate_code_dim(sk_rate_code),
    trip_distance NUMERIC(10, 6),
    fare_amount NUMERIC(10, 6),
    tip_amount NUMERIC(10, 6),
    extra_amount NUMERIC(10, 6),
    mta_tax NUMERIC(10, 6),
    improvement_surcharge NUMERIC(10, 6),
    tolls_amount NUMERIC(10, 6),
    total_amount NUMERIC(10, 6),
    congestion_surcharge NUMERIC(10, 6),
    number_of_trips INT,
    PRIMARY KEY (sk_date, sk_trip_type, sk_passenger, sk_payment_type, sk_weather, sk_rate_code)
);
