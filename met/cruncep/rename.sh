#!/bin/bash
# generated by http://www-app2.igb.illinois.edu/tools/qsub/
# ----------------QSUB Parameters----------------- #
#PBS -S /bin/bash
# \ PBS -q blacklight
# \ PBS -l nodes=1:ppn=1,mem=1000000mb
#PBS -M dlebauer@gmail.com
#PBS -m abe
#PBS -N rename-cruncep
#PBS -d /home/groups/ebimodeling/met/cruncep/
# ----------------Load Modules-------------------- #
module load nco/4.4.8

# ----------------Your Commands------------------- #
#ncrename -O -d lat,latitude -d lon,longitude -v lat,latitude -v lon,longitude out/all_uncompressed.nc all.nc
#ncks -d longitude,-135.0,-67.0 -d latitude,25.0,48.0 all.nc us.nc





