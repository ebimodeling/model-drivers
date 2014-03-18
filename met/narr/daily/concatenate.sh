#!/bin/bash
#PBS -N narr-daily-ncks${year}
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/NARR/out/
#PBS -m abe
#PBS -e dlebauer+biocluster@gmail.com

module load gsl hdf5 netcdf nco

ncrcat -n 35,4,1 1979.nc all.nc 

