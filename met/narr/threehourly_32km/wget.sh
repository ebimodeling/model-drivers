!#/bin/bash

for var in apcp air.2m dswrf rhum.2m shum.2m uwnd.10m vwnd.10m; do
    wget -r -nH --cut-dirs=3 ftp://ftp.cdc.noaa.gov/Datasets/NARR/monolevel/${var}*
done