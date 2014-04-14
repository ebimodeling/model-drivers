## CRUNCEP - PREPARATION

The actual scripts used to prepare files are in this folder. Here is an overview of what they do.

1. Download data

 ```bash
nohup ionice -n 7 wget -r -nH --cut-dirs=6 ftp://nacp.ornl.gov/synthesis/2009/frescati/model_driver/cru_ncep/analysis &
 ```

2. Unzip data

 ```bash
./gunzipall.sh
 ```

3. Concatenate variables files along the time dimension

For example the following command uses the NCO operator  ncrcat to concentate the yearly files for qair ( air specific humditiy) for the years 1901-2010 . 
The output file ncrcat_qair.nc is in netcdf-4 format.

 ```bash
ncrcat --no_tmp_fl -4 -O -h -n 110,4,1 cruncep_qair_1901.nc  ncrcat_qair.nc
 ```

This operation is more depenadent  on good disk I/O than processor speed

2. Rechunk dimensions and convert the  time dimension from unlimited to fixed.
Access to file created in 1.  is very very slow because the  dimension time is unlimited  so netcdf-4 reads  a single  record at a time. The nccopy utility in the netcdf-4 package is used to rechunk and convert the time dim to limited.

 ```bash
nccopy -k 3 -u -c time/2000,lat/1,lon/720 ncrcat_qair.nc qairf.nc
 ```

This command may take 3-4 hours per variable. Typical input dims:
Time=160708   lat=360, lon=720  


3. Permute the dimensions from (time,lat,lon) to (lat,lon,time).

We wish to speeed up access for a given lat/lon spot  - by permuting the dims from (time,lat,lon) to (lat,lon,time)  it means all the variable  values we require are contiguous in file and so access is super quick.

 ```bash
ncpdq --no_tmp_fl -h -O -a lat,lon,time qairf.nc qair.nc
 ```

The memory requirements for this a command are approx 2*var_size.
For example the qiar file (size 157G) required 310G on the biocluster.igb.illinois.edu cluster "blacklight" queue, and took about 4 hours to permute. There is no obvious  way to speed up this step as `ncpdq` is not threaded. If memory is limited then the alternative is to break the file up along the lat dim – repermute , then reconcatenate along the lat dim.

4. Append together the individual files from
   
This step is to combine files into a single script, for ease of programming the applications that use it (e.g. to have one large rather than many small files).
It should not affect the access speed.

Example scripts:

 ```bash
for VAR in rain press lwdown swdown tair qair uwind vwind ; do      
  nccopy -k 3 -u -c time/2000,lat/1,lon/720 “ncrcat_${VAR}.nc” “${VAR}f.nc"                         
done                                                                                                                                                             
 ```

 ```
for VAR in rain press lwdown swdown tair qair uwind vwind ;                                                                                                       do                                                                                                                                                               
  ncpdq --no_tmp_fl -h -O -a lat,lon,time “${VAR}f.nc” “${VAR}.nc"                                                                                             
done                                                                                                                                                             
 ```

 ```
cp rain.nc all.nc
for VAR in press lwdown swdown tair qair uwind vwind ;                                                                                                       do                                                                                                                                                               
 ncks --no_tmp_fl -A -C -h -v  “${VAR}”  “${VAR}.nc”  all.nc
done                                                                                                                                                             
 ```
