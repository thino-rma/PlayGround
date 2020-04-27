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

