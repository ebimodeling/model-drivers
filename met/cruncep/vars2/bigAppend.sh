#!/bin/bash
#PBS -N bigAppend - append-individual-var-files
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

# cp pressp.nc all.nc

for VAR in rain tair qair swdown lwdown uwind vwind ;
do 
  if="${VAR}p.nc" 
  if [ -e "$if" ];then  
   echo "About to append $if"
     ncks --no_tmp_fl -A -C -h -v "${VAR}"  "$if" all.nc        
   echo "have appended append $if status ($?)"
  fi

done



