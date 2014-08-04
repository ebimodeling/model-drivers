Using isimipCondition.pl


The perl script [`bin/isimipCondition.pl`](bin/isimipCondition.pl) allows the user to create a single netcdf file for a given scenario and model. 
The operation is split into five actions: 

1. list: lists files to be concatenated
2. concatenate: combines variables together
3. reorder / append: combines years into a single file record
4. convert: converts units
5. rename: renames variables


The location  of the source nc files (for each scenario) and final target dirctory are detailed in the file bin/myConfig.pm.

Below is a single var as detailed in the file [bin/myConfig.pm](bin/myConfig.pm).

```
'pr' => {                           # abbreviation as used in the vars flag       
   'iName'=>'prAdjust',             # the netcdf name in the input files                             
   'oName'=>'precipitation_flux',   # the isimip name we want in the final output  
   'fName'=>'pr_bced',              # the abbreviation used in the isimip filenames 
   'iUnits'=>'kg m-2 s-1',          # units used in the input isimip files   
   'oUnits'=>'kg m-2 s-1'           # units wanted in the final output nc file    
},

```

Documentation and examples can be found in the header of [`bin/isimipCondition.pl`](bin/isimipCondition.pl).

```
 options flags

 (required) -action list|concatenate|append|convert|rename     
 -m | -model       the model prefix as defined in %MODELS in myConfig.pm
 -s | -scenario    the scenario prefix as defined in %SCENARIOS in myConfig.pm
 -vars             a list of vars to be processed - these are defined in %VARS - for each var there is
                   1) iName - the netcdf name of the var                             
                   2) oName - the isimip names - the one we want in the final output file
                   3) fName - the var prefixed used in the nc file name
                   4) iUnits - the the units attribute of the var in the nc file
                   5) oUnits - the requried final units

 -D                Output debug information
 -V                vebose output information
                                  
  list - the files to be concatenated ( model gfdl / scenario rcp8 )
  isimipCondition.pl  -action list -s rcp8 -m hadgem -vars hurs,pr,rlds,rsds,tas,tasmax,tasmin,wind
     
  concatenate - 
  isimipCondition.pl  -action concatenate -s rcp8 -m hadgem -vars hurs,pr,rlds,rsds,tas,tasmax,tasmin,wind
  ifall goes wellthere should 8 hadgem/rcp8 files located at $OUT/scratch

  reorder and append - 
  isimipCondition.pl  -action append -m hadgem -s rcp8 -vars hurs,pr,rlds,rsds,tas,tasmax,tasmin,wind
  if all goes well a single all file will be created e.g $OUT/scratch/all_hadgem2-es_rcp8p5_2005-2099.nc

  convert - the units of temperature from k(elvin) to Celsius 
  This applies to vars tasAdjust, tasmaxAdjust,tasminAdjust. This action requries a single nc filename
  isimipCondition.pl  -action convert $OUT/scratch/all_hadgem2-es_rcp8p5_2005-2099.nc

  rename - the vars from short_name to long_name e.g tasAdjust/air_temperature 
   rsds/ surface_downwelling_shortwave_flux_in_air, windAdjust / wind_speed
  isimipCondition.pl  -action rename $OUT/scratch/all_hadgem2-es_rcp8p5_2005-2099.nc   

```

