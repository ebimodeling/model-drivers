#!/bin/bash
#PBS -N cruncep-ncks-all
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/cruncep/
#PBS -m abe
#PBS -e dlebauer+biocluster@gmail.com
#PBS -q blacklight
#PBS -l nodes=1:ppn=380
#PBS -l mem=300GB

module load gsl hdf5 netcdf nco

#ncks --no_tmp_fl -A -C -h -v  rain  ncrcat_rain1.nc  ncrcat_press1.nc
#ncks --no_tmp_fl -A -C -h -v  qair  ncrcat_qair1.nc  ncrcat_press1.nc
#ncks --no_tmp_fl -A -C -h -v  swdown  ncrcat_swdown1.nc  ncrcat_press1.nc
#ncks --no_tmp_fl -A -C -h -v  lwdown  ncrcat_lwdown1.nc  ncrcat_press1.nc
#ncks --no_tmp_fl -A -C -h -v  tair  ncrcat_tair1.nc  ncrcat_press1.nc
#ncks --no_tmp_fl -A -C -h -v  uwind  ncrcat_uwind1.nc  ncrcat_press1.nc
ncks --no_tmp_fl -A -C -h -v  vwind  ncrcat_vwind1.nc  ncrcat_press1.nc
