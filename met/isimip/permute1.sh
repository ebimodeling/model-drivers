#!/bin/bash
#PBS -N narr-repermute
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/isimip
#PBS -m abe
#PBS -e henryb@hush.com


module load gsl hdf5 netcdf nco

cd hadgem2rcp6_all

#VAR="air.2m";
#VAR="$1";

# ifile="${VAR}.nc";
# ofile="${VAR}p.nc";

ncpdq -4 --no_tmp_fl -h -O -a lat,lon,time tasmin_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099.nc tasmin_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099p.nc
ncpdq -4 --no_tmp_fl -h -O -a lat,lon,time uas_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099.nc uas_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099p.nc
ncpdq -4 --no_tmp_fl -h -O -a lat,lon,time vas_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099.nc vas_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099p.nc

