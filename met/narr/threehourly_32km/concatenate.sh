#!/bin/bash
#PBS -N narr-threehourly-concatenate
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/narr/threehourly_32km/out/
#PBS -m abe
#PBS -e dlebauer+biocluster@gmail.com

module load gsl hdf5 netcdf nco

#ncrcat -4  -x -v oldtime -O --no_tmp_fl 198[0123456789].nc 1980s.nc
#ncrcat -4  -x -v oldtime -O --no_tmp_fl 199[0123456789].nc 1990s.nc
#ncrcat -4  -x -v oldtime -O --no_tmp_fl 200{0..9}.nc  2000s.nc
#ncrcat -4 -O --no_tmp_fl 201{0..4}.nc 2010s.nc

ncrcat  -4  -x -v oldtime -O --no_tmp_fl 1979.nc 1980s.nc 1990s.nc  1979_1999_3h.nc
ncrcat  -4 -O --no_tmp_fl 1979_1999_3h.nc 2010s.nc  mstmip_narr_1979_2013_3h.nc
