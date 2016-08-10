#!/bin/bash
echo "input file $1"

rename_args="-v qair,specific_humidity -v tair,air_temperature -v press,surface_pressure -v rain,precipitation_flux -v swdown,surface_downwelling_shortwave_flux_in_air -v lwdown,surface_downwelling_longwave_flux_in_air -v uwind,eastward_wind -v vwind,northward_wind";

ncrename $rename_args $1
