#!/bin/bash
#PBS -N narr-permute
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/NARR/out/
#PBS -m abe
#PBS -e dlebauer@gmail.com
#PBS -q default

module load gsl hdf5 nco netcdf/4.3.1.1

#rm *ts.nc
#for year in `seq 1979 2013`; do
#    nccopy -m 4G -c 'time/366,lat/5,lon/5' ${year}.nc ${year}ts.nc 
#done

#for year in `seq 1979 2013`; do
#    ncrcat -n ts.nc allts.nc
#done
ncrcat -n 34,4,1 1980.nc allts.nc 
