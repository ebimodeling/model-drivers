package myConfig;
# AUTHOR: Henry Butowsky
# Date: 22-6-2014
# global strings and hashes

use Exporter;
use vars qw(@ISA @EXPORT );
@ISA =('Exporter');

@EXPORT=qw($IN $OUT %VARS %MODELS %SCENARIOS);

$IN="/home/groups/ebimodeling/met/isimip/in";
$OUT="/home/groups/ebimodeling/met/isimip/out";


 %VARS=(
    'hurs' => {
              'iName'=>'hurs',
              'oName'=>'relative_humidity',     
              'fName'=>'hurs',
              'iUnits'=>'%',
              'oUnits'=>'%'
              },
    
    'pr' => {                                  # abbreviation as used in the -vars flag       
              'iName'=>'prAdjust',             # the netcdf name in the input files                             
              'oName'=>'precipitation_flux',   # the isimip name we want in the final output  
              'fName'=>'pr_bced',              # the abbreviation used in the isimip filenames 
              'iUnits'=>'kg m-2 s-1',          # units used in the input isimip files   
              'oUnits'=>'kg m-2 s-1'           # units wanted in the final output nc file    
              },

    'ps' => {
              'iName'=>'psAdjust',
              'oName'=>'surface_pressure',     
              'fName'=>'ps_bced',
              'iUnits'=>'Pa',
              'oUnits'=>'Pa'
              },

    'rlds' => {
              'iName'=>'rldsAdjust',
              'oName'=>'surface_downwelling_longwave_flux_in_air',     
              'fName'=>'rlds_bced',
              'iUnits'=>'W m-2',
              'oUnits'=>'W m-2'
              },

    'rsds' => {
              'iName'=>'rsdsAdjust',
              'oName'=>'surface_downwelling_shortwave_flux_in_air',     
              'fName'=>'rsds_bced',
              'iUnits'=>'W m-2',
              'oUnits'=>'W m-2'
              },

    'tas' => {
              'iName'=>'tasAdjust',
              'oName'=>'air_temperature',
              'fName'=>'tas_bced',
              'iUnits'=>'K',
              'oUnits'=>'Celsius'
              },

    'tasmax' => {
              'iName'=>'tasmaxAdjust',
              'oName'=>'air_temperature_max',
              'fName'=>'tasmax_bced',
              'iUnits'=>'K',
              'oUnits'=>'Celsius'
              },


    'tasmin' => {
              'iName'=>'tasminAdjust',
              'oName'=>'air_temperature_min',
              'fName'=>'tasmin_bced',
              'iUnits'=>'K',
              'oUnits'=>'Celsius'
              },

    'uas' => {
              'iName'=>'uasAdjust',
              'oName'=>'eastward_wind',
              'fName'=>'uas_bced',
              'iUnits'=>'m s-1',
              'oUnits'=>'m s-1'
              },

    'vas' => {
              'iName'=>'vasAdjust',
              'oName'=>'northward_wind',
              'fName'=>'vas_bced',
              'iUnits'=>'m s-1',
              'oUnits'=>'m s-1'
              },


    'wind' => {
              'iName'=>'windAdjust',
              'oName'=>'wind_speed',
              'fName'=>'wind_bced',
              'iUnits'=>'m s-1',
              'oUnits'=>'m s-1'
              }

);

 %MODELS =(
      'gfdl' => {                            # abbreviation used as arg to -model flag      
                'fName'=> 'gfdl-esm2m'       # abbreviation used in the filename    
                },  

      'hadgem' => {
                'fName'=> 'hadgem2-es'    
                },  

      'ipsl' => {
                'fName'=> 'ipsl-cm5a-lr'    
                },  

      'miroc' => {
                'fName'=> 'miroc-esm-chem'    
                },  

      'noresm' => {
                'fName'=> 'noresm1-m'    
                }
);

 %SCENARIOS =(

      'rcp8' => {                               # abbreviation used as arg to -scenario flag    
               'fName'=> 'rcp8p5',              # abbreviation used in the filename    
               'dir' => "${IN}/rcp8"            # location of the files     
                },  

      'rcp6' => {
                'fName'=> 'rcp6p0',    
                 'dir' => "${IN}/rcp6"     
                }, 

      'history' => {
                'fName'=> 'hist',    
                 'dir' => "${IN}/history"     
                } 


);



