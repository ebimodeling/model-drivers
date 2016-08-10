#!/bin/bash
#PBS -N narr-daily-ncks
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/NARR/air.2m/
#PBS -m abe
#PBS -e dlebauer+biocluster@gmail.com

module load gsl hdf5 netcdf nco


#for year in `seq 1979 2013`; do
#    nccopy -m 4G -c 'time/366,lat/5,lon/5' ${year}.nc ${year}ts.nc
#    cp ${year}ts.nc ${year}.nc
#done

#ncrcat -n 34,4,1 1980.nc threehourly_airT.nc 
#ncrcat 198[0123456789].nc 1980s.nc
#ncrcat 199[0123456789].nc 1990s.nc
#ncrcat 1979.nc 1980s.nc 1990s.nc 1979_1999.nc

ncrcat 200[0123456789].nc 2000s.nc
ncrcat 201[123].nc 2010s.nc
ncrcat 2000s.nc 2010s.nc 2000_2013.nc
ncrcat 1979_1999.nc 2000_2013.nc all.nc
