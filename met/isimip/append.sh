#!/bin/bash
# what arubbish script !!

afile="all_1960_1999_hadgem2-es_rcp6p0_2005-2099.nc";
ncks --no_tmp_fl -A -v Adjust$ ps_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099p.nc "$afile"
ncks --no_tmp_fl -A -v Adjust$ rlds_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099p.nc "$afile"
ncks --no_tmp_fl -A -v Adjust$ rsds_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099p.nc "$afile"
ncks --no_tmp_fl -A -v Adjust$ tas_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099pt.nc "$afile"
ncks --no_tmp_fl -A -v Adjust$ tasmax_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099pt.nc "$afile"
ncks --no_tmp_fl -A -v Adjust$ tasmin_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099pt.nc "$afile"
ncks --no_tmp_fl -A -v Adjust$ uas_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099p.nc "$afile"
ncks --no_tmp_fl -A -v Adjust$ vas_bced_1960_1999_hadgem2-es_rcp6p0_2005-2099p.nc "$afile"

