#!/bin/bash
#PBS -N narr-daily-concatenation
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/narr/threehourly
#PBS -m abe
#PBS -e henryb@hush.com

module load gsl hdf5 netcdf nco

#VAR="air.2m";
#VAR="$1";

ofile="${VAR}.nc";

ncrcat --no_tmp_fl  -h -n 32,4,1  "${VAR}/${VAR}.u.1979.nc" "$ofile"

