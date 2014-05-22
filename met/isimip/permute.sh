#!/bin/bash
#PBS -N narr-repermute
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/isimip
#PBS -m abe
#PBS -e henryb@hush.com
#PBS -q blacklight
#PBS -l nodes=1:ppn=10
#PBS -l mem=50GB



module load gsl hdf5 netcdf nco


INDIR="ipsl_all"
# OUTDIR="gfdl_all"
# file name suffix for ncrcat output file
# SUFFIX="1960_1999_gfdl-esm2m_rcp2p6_2006-2099.nc"
# SUFFIX="1960_1999_hadgem2-es_rcp6p0_2005-2099.nc"
SUFFIX="1960_1999_ipsl-cm5a-lr_rcp2p6_2006-2099.nc"
#VAR="air.2m";
#VAR="$1";

# ifile="${VAR}.nc";
# ofile="${VAR}p.nc";

for VARNM in pr_bced_ ps_bced_ rlds_bced_ rsds_bced_ tas_bced_ tasmax_bced_ tasmin_bced_ uas_bced_ vas_bced_ ;  
do

# requires manual changing for each run
ifile="${INDIR}/${VARNM}${SUFFIX}"

# change end of filename from ".nc" to ".p.nc"
ofile=${ifile//.nc/.p.nc}

    if [ -e $ifile ] && [ ! -e $ofile ]; then
       echo "about to process $ifile"
       ncpdq -4 --no_tmp_fl -h -O -a lat,lon,time "$ifile"  "$ofile" 
    else
      echo "output($ofile) already exists"
    fi


done

# 
