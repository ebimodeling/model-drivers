#!/bin/bash
#PBS -j oe
#PBS -S /bin/bash
#PBS -d /home/a-m/dlebauer/met/cruncep/in/ # run from dir
#PBS -M dlebauer@gmail.com

echo $WKDIR
cd $WKDIR
for i in *.nc.gz 
do
    gunzip $i
    rm $i
done
cd /home/a-m/dlebauer/met/cruncep/in/




