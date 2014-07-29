#!/bin/bash
# Date: 18-07-14
# Author: Henry Butowsky
# usage: lim2unlim.sh "VARNAME"
#  e.g  lim2unlim.sh air.2m
#
########################################################################################################

# script make the dim "time" a record dimension 
# The scripts loops through files in directory "$VAR" 
# input filenames - ${VAR}.${year}.nc   
#    eg air.2m.1979.nc,air.2m.1980.nc,air.2m.1981.nc ...
#
# output filenames - ${VAR}.u.${year}.nc  
#   eg air.2m.u.1979.nc,air.2m.u.1980.nc,air.2m.u.1981.nc ...
#######################################################################################################


# grab var name for first arg
VAR="$1";


for year in {1979..2010} ;
do

ifile="${VAR}/${VAR}.${year}.nc"
ofile="${VAR}/${VAR}.u.${year}.nc"

   if [ -e $ifile ] ; then
      echo "$ifile";
      ncks --no_tmp_fl --mk_rec_dmn time -h "$ifile" "$ofile";
   fi 

done
