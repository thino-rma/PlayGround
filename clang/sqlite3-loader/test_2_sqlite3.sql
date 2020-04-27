PRAGMA cache_size=10000;
PRAGMA synchronous = OFF;
PRAGMA journal_mode = MEMORY;
.mode csv
.import '|tail -n +2 nyc_data_rides.csv' rides
.q
