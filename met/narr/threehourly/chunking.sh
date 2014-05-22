#!/bin/bash
#PBS -N narr-rechunking
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/narr/threehourly
#PBS -m abe
#PBS -e henryb@hush.com

module load gsl hdf5 netcdf nco

VAR="air.2m";

ifile="${VAR}.nc";
ofile="${VAR}p.nc";


ncks --fix_rec_dmn  --no_tmp_fl -4 --cnk_dmn time,93504 --cnk_dmn lat,1 --cnk_dmn lon,480 "${ifile}" "${ofile}"

