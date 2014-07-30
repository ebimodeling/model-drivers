#!/bin/bash
#PBS -N cruncep-daily-concatenation
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/cruncep
#PBS -m abe
#PBS -e henryb@hush.com

# Date: 18-07-2014
# Author: Henry Butowsky
# Purpose: concatenate files in dir VAR along the record dimension time 
#          start year=1979 end year=2010     
# usage: case.sh "ACTION" "VARNAME"        

############################################################################################################
# typical usage:
# create concaenations
#
# case.sh concatenate rain
# case.sh concatenate tair
# case.sh concatenate qair
# case.sh concatenate swdown
# case.sh concatenate lwdown
# case.sh concatenate uwind
# case.sh concatenate vwind
#
# do permutes
# case.sh permute rain
# case.sh permute tair
# case.sh permute qair
# case.sh permute swdown
# case.sh permute lwdown
# case.sh permute uwind
# case.sh permute vwind

# do append
# case.sh append

############################################################################################################


module load gsl hdf5 netcdf nco

ACTION="${1,,}";
VAR="$2";

echo "$0: ACTION=$ACTION VAR=$VAR"

# change to working dir
cd "/home/groups/ebimodeling/met/cruncep"


case "$ACTION" in

 concatenate)

   # input files in directory in/$VAR 
   catFile="ncrcat_${VAR}.nc"
   catFile1="ncrcat_${VAR}1.nc"
   # concatenate along the record dimension from  year start(1901) end(2010)    
   ncrcat --no_tmp_fl -4 -O -h -n 110,4,1 "in/${VAR}/cruncep_${VAR}_1901.nc" "$catFile";

   # rechunk to optimize access 
   if [ -e "$catFile" ]; then 
     nccopy -k 3 -u -c time/2000,lat/1,lon/720 "$catFile" "$catFile1";
   fi
   ;;

 
 permute)

   # input file in current directory .
   # permute dims in file from (time/lat/lon) to (lat/lon/time) to speed up access time
   catFile="ncrcat_${VAR}1.nc"
   catFile1="${VAR}.nc"
   ncpdq --no_tmp_fl -h -O -a lat,lon,time "$catFile"  "$catFile1" 
   ;;

 rechunk)

   # input file in current directory .
   # 
   # rechunk files - don't think this step is needed
   ;;


 append)
  # assume all input file in current directory .
  # append vars to create a single file
 
  cp press.nc all.nc

  for V in rain tair qair swdown lwdown uwind vwind ;
  do 
    if [ -e "${V}.nc" ] ; then
      ncks --no_tmp_fl -A -C -h -v "${V}"  "${V}.nc" all.nc;
      echo "$0:$ACTION Sucessfully appended ${V} to all.nc";    
    else
      echo "$0:$ACTION Can't locate file \"${V}.nc"   
    fi
  done
  ;;

 *) 
 echo "action \"$1\" unrecognized: must be one of concatenate/permute/append/rechunk"
 exit 1;
 ;;

esac
