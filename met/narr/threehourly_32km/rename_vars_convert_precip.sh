#!/bin/bash
#PBS -N narr-threehourly32km-ncks
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/narr/threehourly_32km/
#PBS -m abe
#PBS -e dlebauer+biocluster@gmail.com
#PBS -q blacklight
#PBS -l mem=100GB

module load gsl hdf5 netcdf nco


ncrename -v apcp,precipitation_flux -v dswrf,surface_downwelling_shortwave_flux_in_air -v rhum,relative_humidity -v air,air_temperature -v vwnd,northward_wind -v uwnd,eastward_wind 1979_2013.nc 1979_2013_rename2.nc


#ncflint -C -v precipitation_flux -w 10800.0,0.0 1979_2013_rename2.nc 1979_2013_rename2.nc foo.nc 

#ncap2 -v -A -C --no_tmp_fl -s precipitation_flux/=10800.0d 1979_2013_rename.nc foo.nc

#ncatted -a units,precipitation_flux,o,c,'kg m-2 s-1' foo.nc foo2.nc
