#!/bin/bash
#PBS -N narr-daily-concatenation
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/narr/threehourly
#PBS -m abe
#PBS -e henryb@hush.com

# Date: 18-07-2014
# Author: Henry Butowsky
# Purpose: concatenate files in dir VAR along the record dimension time 
#          start year=1979 end year=2010     
# usage: concatenate.sh "VARNAME"          

module load gsl hdf5 netcdf nco


VAR="$1";

ofile="${VAR}.nc";

ncrcat --no_tmp_fl  -h -n 32,4,1  "${VAR}/${VAR}.u.1979.nc" "$ofile"

