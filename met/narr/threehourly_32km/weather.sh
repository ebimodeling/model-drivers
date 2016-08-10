#!/bin/bash
#PBS -N narr-threehourly32km-ncks
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/groups/ebimodeling/met/narr/threehourly_32km/
#PBS -m abe
#PBS -e dlebauer+biocluster@gmail.com

module load gsl hdf5 netcdf nco

## submit for each year : 
## for YEAR in `seq 1979 2013`; do export year=${YEAR}; qsub -V weather.sh; done


INPUT="/home/groups/ebimodeling/met/narr/threehourly_32km/"
OUTPUT="/home/groups/ebimodeling/met/narr/threehourly_32km/out/"

## variables 1= start year 2 = end year
#for year in `seq 1979 2014`; do
for year in 2009; do
    echo "processing $year"
    for var in air.2m. apcp. dswrf. rhum.2m. soilm. uwnd.10m. vwnd.10m.;
      do
      for file in ${var}${year}.nc; do
	  echo ${INPUT}${file}
	  ncks -A ${INPUT}/${file} ${OUTPUT}/${year}.nc
      done
    done
    echo "$(date) done processing $y"
done

#echo "$(date) concatting all years"
#nohup ionice -n 2 ncrcat -n 110,3,1 1901.nc all.nc 
#echo "$(date) done concatting all years"
