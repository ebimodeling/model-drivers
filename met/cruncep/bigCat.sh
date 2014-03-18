#!/bin/bash

cd /home/groups/ebimodeling/met/cruncep/in/tair
# chunking policy - concate 360 files together only variables - lat, tair
time ncrcat --cnk_plc=g3d  --cnk_dmn lon,1 --cnk_dmn time,4000 --no_tmp_fl -h -C -v lat,tair  -n 360,3,1 tair_plon000.nc ncrcat_tair_out.nc