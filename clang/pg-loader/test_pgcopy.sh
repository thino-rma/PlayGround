date
echo "\\copy rides FROM 'nyc_data_rides.csv' CSV HEADER" | sudo -u postgres psql nyc_data
date
