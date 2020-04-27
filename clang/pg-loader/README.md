Compile environment on Ubuntu 18.04
===================================
- packages for development
  ```console
  $ sudo apt-get -y install git build-essential
  ```
- PostgreSQL12+PostGIS3
  ```
  $ echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -c -s)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
  $ curl -L https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  $ sudo apt-get update
  $ sudo apt-get -y install postgresql-12 postgresql-12-postgis-3 libpq-dev
  ```
- TimescaleDB latest for PostgreSQL12
  ```
  $ sudo add-apt-repository -y ppa:timescale/timescaledb-ppa
  $ sudo apt-get update
  $ sudo apt-get -y install timescaledb-postgresql-12
  ```
- Setting
  ```
  $ sudo timescaledb-tune --quiet --yes
  $ sudo echo timescaledb.telemetry_level=off >> /etc/postgresql/12/main/postgresql.conf
  $ sudo systemctl restart postgresql
  ```
- Create Table
  ```
  $ sudo -u postgres psql
  postgres =# 
  ```
  > exit with ```\q```

  ```
  CREATE DATABASE nyc_data;
  \c nyc_data;
  CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
  CREATE TABLE "rides"(
      vendor_id TEXT,
      pickup_datetime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
      dropoff_datetime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
      passenger_count NUMERIC,
      trip_distance NUMERIC,
      pickup_longitude  NUMERIC,
      pickup_latitude   NUMERIC,
      rate_code         INTEGER,
      dropoff_longitude NUMERIC,
      dropoff_latitude  NUMERIC,
      payment_type INTEGER,
      fare_amount NUMERIC,
      extra NUMERIC,
      mta_tax NUMERIC,
      tip_amount NUMERIC,
      tolls_amount NUMERIC,
      improvement_surcharge NUMERIC,
      total_amount NUMERIC
  );
  SELECT create_hypertable('rides', 'pickup_datetime', 'payment_type', 2, create_default_indexes=>FALSE);
  ```
- Download nyc_data
  ```
  $ wget https://timescaledata.blob.core.windows.net/datasets/nyc_data.tar.gz
  $ tar xf nyc_data.tar.gz
  ```
- Compile and Execute
  ```
  $ gcc -Wall -g -O2 -I/usr/include/postgresql -L/usr/lib/x86_64-linux-gnu -DLOGSTDOUT -o pg-loader pg-loader.c -lpq
  $ sudo -u postgres ./pg-loader | tee -a test.log
  ```
