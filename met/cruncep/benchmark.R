library(ncdf4)
.libPaths("/home/a-m/dlebauer/library/R")

library(rbenchmark)

all.nc <- "/home/groups/ebimodeling/met/cruncep/vars2/all.nc"
all.nc <- nc_open(all.nc)

 
#benchmark(all.ts = ncvar_get(all.nc, "lwdown", 
#              start = c(100, 184, 1), 
#              count = c(1, 1, 16070)),#160708 total 
#          replications = 10)

benchmark(ans = as.numeric(ncvar_get(nc = all.nc,
               varid = "lwdown",
               start = c(200, 100, 1),
               count = c(1, 1, 438))),
          replications = 10)
