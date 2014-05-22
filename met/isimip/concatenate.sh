#!/bin/bash
#PBS -N isimip-concatenate
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/isimip
#PBS -m abe
#PBS -e henryb@hush.com


module load gsl hdf5 netcdf nco

INDIR="ipsl"
OUTDIR="ipsl_all"
# file name suffix for ncrcat output file
SUFFIX="1960_1999_ipsl-cm5a-lr_rcp2p6_2006-2099.nc"




for VARNM in pr_bced_ ps_bced_ rlds_bced_ rsds_bced_ tas_bced_ tasmax_bced_ tasmin_bced_ uas_bced_ vas_bced_ ;  
do
     # requires manual changing for each run
     ofile="${OUTDIR}/${VARNM}${SUFFIX}"
     catfiles=`ls -1 ${INDIR}/${VARNM}*.nc|tr '\n' ' '`;
     echo "About to concatenate $VARNM files"  
     ncrcat --no_tmp_fl -h -O $catfiles "$ofile"
     
     if [ -e "$ofile" ]; then 
       echo "Concatenation of $VARNM files sucessfull"
     fi             


done

