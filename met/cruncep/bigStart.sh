#!/bin/bash
#PBS -N bigstart-nc-files
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/cruncep/in/lwdown
#PBS -M henryb@hush.com
#PBS -m abe

# purpose concatenate var files and then create copy  with different chunking parameters

module load gsl netcdf nco udunits


if [ ! -d $WKDIR ]; then
  echo "directory $WKDIR does not exist"  
  exit 1;
fi

echo $WKDIR
cd $WKDIR


# var name from 1st arg working dir argument
VAR=`basename $WKDIR`  

catFile="ncrcat_${VAR}.nc"
catFile1="ncrcat_${VAR}1.nc"

echo "$catFile $catFile1"


ncrcat --no_tmp_fl -4 -O -h -n 110,4,1 cruncep_${VAR}_1901.nc $catFile;



# rechunk to optimize access 
if [ -e "$catFile" ]; then 
  nccopy -k 3 -u -c time/2000,lat/1,lon/720 $catFile $catFile1;
fi









