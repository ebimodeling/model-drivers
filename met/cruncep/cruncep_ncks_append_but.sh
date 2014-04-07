#!/bin/bash
#PBS -N cruncep-ncks-all
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/cruncep/
#PBS -m abe
#PBS -e henryb@hush.com
#PBS -q blacklight
#PBS -l nodes=1:ppn=100
#PBS -l mem=300GB

module load gsl hdf5 netcdf nco

#ncks --no_tmp_fl -A -C -h -v  qair  qairp.nc  all.nc

ncks --no_tmp_fl -A -C -h -v  tair  vars2/tairp.nc    vars2/all.nc
ncks --no_tmp_fl -A -C -h -v  press  vars2/pressp.nc  vars2/all.nc
ncks --no_tmp_fl -A -C -h -v  rain   vars2/rainp.nc   vars2/all.nc
ncks --no_tmp_fl -A -C -h -v  swdown  vars2/swdownp.nc  vars2/all.nc
ncks --no_tmp_fl -A -C -h -v  lwdown  vars2/lwdownp.nc  vars2/all.nc
ncks --no_tmp_fl -A -C -h -v  uwind  vars2/uwindp.nc  vars2/all.nc
ncks --no_tmp_fl -A -C -h -v  vwind  vars2/vwindp.nc  vars2/all.nc





