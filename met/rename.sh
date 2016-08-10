#!/bin/bash

renameString="-v psAdjust,surface_pressure -v rldsAdjust,surface_downwelling_longwave_flux_in_air -v rsdsAdjust,surface_downwelling_shortwave_flux_in_air -v tasAdjust,air_temperature -v tasmaxAdjust,air_temperature_max -v tasminAdjust,air_temperature_min -v uasAdjust,eastward_wind -v vasAdjust,northward_wind -v prAdjust,precipitation_flux -v hurs,relative_humidity"

ncrename -h -O $renameString $1
