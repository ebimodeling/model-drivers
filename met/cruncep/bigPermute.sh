#!/bin/bash
#PBS -N big-permute-ncfile
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/cruncep/
#PBS -m abe
#PBS -e henryb@hush.com
#PBS -q blacklight
#PBS -l nodes=1:ppn=380
#PBS -l mem=300GB

module load gsl hdf5  netcdf nco udunits


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
outFile="${VAR}.nc"

ncpdq --no_tmp_fl -h -O -a lat,lon,time "$catFile1"  "$outFile" 





