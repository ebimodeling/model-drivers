#!/bin/bash
#PBS -N narr-threehourly32km-wget
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/narr/threehourly_32km/
#PBS -m abe
#PBS -e dlebauer+biocluster@gmail.com


for var in apcp air.2m dswrf rhum.2m shum.2m uwnd.10m vwnd.10m; do
    wget -r -nH --cut-dirs=3 ftp://ftp.cdc.noaa.gov/Datasets/NARR/monolevel/${var}*
done
