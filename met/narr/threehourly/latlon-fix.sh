#!/bin/bash
#PBS j -oe
#PBS -d /home/groups/ebimodeling/met/narr/threehourly/

ncks --mk_rec_dmn latitude --mk_rec_dmn longitude -h champaign.nc champaign2.nc

