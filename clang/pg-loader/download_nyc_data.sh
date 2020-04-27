if [ -f nyc_data.tar.gz ]; then
    wget https://timescaledata.blob.core.windows.net/datasets/nyc_data.tar.gz
fi
if [ -f nyc_data_rides.csv ]; then
    tar xf nyc_data.tar.gz
fi

