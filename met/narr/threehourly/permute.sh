#!/bin/bash
#PBS -N narr-repermute
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/narr/threehourly
#PBS -m abe
#PBS -e henryb@hush.com
#PBS -q blacklight
#PBS -l nodes=1:ppn=10
#PBS -l mem=300GB

# Date: 18-07-2014
# Author: Henry Butowsky
# Purpose: permute dims for faster access
#          start dims order (time/lat/lon) -              
#          output dims order (lat,lon,time )               
#          
# usage: permute.sh "VARNAME"          
#        looks in the cwd() for the file "VARNAME.nc"      

module load gsl hdf5 netcdf nco

#VAR="air.2m";
#VAR="$1";

ifile="${VAR}.nc";
ofile="${VAR}p.nc";

ncpdq -4 --no_tmp_fl -h -O -a lat,lon,time "$ifile"  "$ofile" 
