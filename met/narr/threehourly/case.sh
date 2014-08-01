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
# usage: case.sh "ACTION" "VARNAME"        

# typical usage:
# create concaenations
#
# case.sh concatenate air.2m
# case.sh concatenate apcp-rescaled
# case.sh concatenate dswrf_rescaled_corrected
# case.sh concatenate rhum.2m
# case.sh concatenate shhum.2m
# case.sh concatenate wnd.10m
#
# do permutes
# case.sh permute air.2m
# case.sh permute apcp-rescaled
# case.sh permute dswrf_rescaled_corrected
# case.sh permute rhum.2m
# case.sh permute shhum.2m
# case.sh permute wnd.10m
#
# do append
# case.sh append

############################################################################################################



module load gsl hdf5 netcdf nco

ACTION="${1,,}";
VAR="$2";

echo "$0: ACTION=$ACTION VAR=$VAR"

# change to working dir
cd "/home/groups/ebimodeling/met/narr/threehourly"



case "$ACTION" in

 concatenate)

   # input files in directory in/$VAR 
   # concatenate along the record dimension from  year start(1979) end(2010)    
   ofile="${VAR}.nc";
   ncrcat --no_tmp_fl  -h -n 32,4,1  "in/${VAR}/${VAR}.u.1979.nc" "$ofile"
   ;;
 
 permute)

   # input file in current directory .
   # permute dims in file from (time/lat/lon) to (lat/lon/time) to speed up access time
   ifile="${VAR}.nc";
   ofile="${VAR}p.nc";
   ncpdq -4 --no_tmp_fl -h -O -a lat,lon,time "$ifile"  "$ofile" 
   ;;

 rechunk)

   # input file in current directory .
   # 
   # rechunk files - don't think this step is needed
   ifile="${VAR}.nc";
   ofile="${VAR}pc.nc";
   
   # really dont like this as  as all the dim sizes are hard coded ?
   ncks --fix_rec_dmn  --no_tmp_fl -4 --cnk_dmn time,93504 --cnk_dmn lat,1 --cnk_dmn lon,480 "${ifile}" "${ofile}"
   ;;


 append)
  # assume all input file in current directory .
  # append vars to create a single file
  cp air.2mp.n all.nc
  ncks -A -h -v dswrf --no_tmp_fl -h -C dswrf_rescaled_correctedp.nc all.nc
  ncks -A -h -v apcp --no_tmp_fl -h -C apcp_resaledp.nc all.nc
  ncks -A -h -v rhum --no_tmp_fl -h -C rhum.2mp.nc  all.nc
  ncks -A -h -v shum --no_tmp_fl -h -C shum.2mp.nc  all.nc
  ncks -A -h -v wnd --no_tmp_fl -h -C wnd.10mp.nc  all.nc
  ;;

 *) 
 echo "action \"$1\" unrecognized: must be one of concatenate/permute/append/rechunk"
 exit 1;
 ;;

esac
