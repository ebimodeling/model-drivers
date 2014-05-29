#!/bin/bash
#PBS -N big-Permute-nc-files
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/cruncep/in/lwdown
#PBS -M henryb@hush.com
#PBS -m abe

module load gsl netcdf nco udunits


if [ ! -d $WKDIR ]; then
  echo "directory $WKDIR does not exist"  
  exit 1;
fi

echo $WKDIR
cd $WKDIR


# var name from 1st arg working dir argument
VAR=`basename $WKDIR`  

# this a concatentaion of cruncep_VAR files followed by a rechunking operation
catFile1="ncrcat_${VAR}1.nc"

echo "$catFile1"


for latdx in {000..359}; do

   outFile1="tair_lon${latdx}.nc"
   outFile2="tair_plon${latdx}.nc"
   
   #ncrcat_tair4 - has NO unlimited dims and is netCDF4            
   ncks --no_tmp_fl --mk_rec_dmn lat -O -h -v $VAR -c -d lat,$latdx $catFile1 $outFile1;
  
   if [ -e "$outFile1" ]; then 
      ncpdq --no_tmp_fl -O -h -v $VAR -c -a lat,lon,time $outFile1 $outFile2;
      rm $outFile1; 
   fi

   echo "processed - $outFile1 $outFile2"

done








