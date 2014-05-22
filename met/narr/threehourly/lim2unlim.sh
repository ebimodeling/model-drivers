#!/bin/bash



# VAR="air.2m";
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