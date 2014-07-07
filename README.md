model-drivers
=============

This directory includes scripts used to download, rechunk, and concatenate soil, meteorological, chemical, and biological drivers used in ecosystem modeling and analysis. 

These scripts convert files to netCDF-4 format with dimensions and variables that are compliant with CF-1.4 and that follow MsTMIP unit and name conventions.

Files are rechunked for fast time series reading, and combined into large files (one per data set).

Note that the original data are large, and not included in this repository. See `wget.sh` and README files for more information about the data sources" 


### looking at file contents

```
ncwa -d lon,0.0 -d lat,51.0 all.nc ncwa.nc
ncdump ncwa.nc |more

## find closest grid point:
ncks -d lon,50.0 -d lat,0.0 in.nc foo.nc
## to end of the range
ncks -d lon,50.0, -d lat,0.0, in.nc foo.nc


## find record by index
ncks -d lon,50 -d lat,0 in.nc foo.nc
```
