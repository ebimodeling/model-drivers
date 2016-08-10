#!/bin/bash
#PBS j -oe
#PBS -d /home/groups/ebimodeling/met/narr/threehourly/

# http://www.unidata.ucar.edu/blogs/developer/en/entry/netcdf_compression
nccopy -u -d9 -s out/all.nc all_compressed.nc


