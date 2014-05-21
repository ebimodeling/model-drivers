source("/home/a-m/dlebauer/dev/pecan/models/biocro/inst/met_functions.R")
library(data.table)
library(ncdf4)
library(lubridate)
library(udunits2)
library(PEcAn.data.atmosphere)
library(BioCro)
Lat <- 40.08
Lon <- -88.2
 
narr <- data.table(getNARRforBioCro(lat = Lat, lon = Lon, year = 2010))

## NARR 3 hourly
met.nc <- nc_open("/home/groups/ebimodeling/met/narr/threehourly/all/all.nc")
narr2 <- get.weather(lat = Lat, lon =Lon, met.nc = met.nc, start.date = "2010-01-01", end.date="2010-12-31")
###HACK
narr2$RH <- narr2[,qair2rh(qair = RH, temp = DailyTemp.C)]




met.nc <- nc_open("/home/groups/ebimodeling/met/cruncep/vars2/all.nc")
cruncep <- get.weather(lat = Lat, lon =Lon, met.nc = met.nc, start.date = "2010-01-01", end.date="2010-12-31")
###HACK
cruncep$RH <- cruncep[,qair2rh(qair = RH, temp = DailyTemp.C)]

ebifarm <- data.table(read.csv("/home/groups/ebimodeling/ebifarm_met_2009_2011.csv"), key = "yeardoytime")
ebifarm.sun <- data.table(read.csv("/home/groups/ebimodeling/ebifarm_flux_2010.csv"), key = "yeardoytime")
ebifarm <- merge(ebifarm, ebifarm.sun[,list(yeardoytime, solar = PARDown_Avg)])

time <- ebifarm[,list(year = substr(yeardoytime, 1, 4), doy = substr(yeardoytime, 5,7), hour = paste0(substr(yeardoytime, 8,9), ifelse(substr(yeardoytime, 10,10) == "0", ".0", ".5")))]
time <- data.table(sapply(time, as.numeric))
ebifarm <- cbind(time, ebifarm[,list(Temp = Tair_f, RH = RH_f, precip = rain, wind = ws, solar = solar)])
ebifarm <- ebifarm[year == 2010 & !grepl(".5", hour)]
## Compare Wind
library(ggplot2)

getdate <- function(dataset, timezone = hours(0)){
    date <- ymd_hms("2009-12-31 00:00:00") + days(dataset$doy) + hours(dataset$hour) + timezone
    return(cbind(date, dataset))
}
ebifarm <- getdate(ebifarm)
narr <- getdate(narr)
narr2 <- getdate(narr2, timezone = hours(-6))
cruncep <- getdate(cruncep, timezone = hours(-6))

cruncep$source <- "cruncep"
narr$source <- "narr"
narr2$source <- "narr2"
ebifarm$source <- "ebifarm"

met <- rbind(cruncep[,list(source, date, temp = DailyTemp.C, RH, wind = WindSpeed, precip, solar = solarR)],
             narr[,list(source, date, temp = Temp, RH, wind = WS, precip, solar = SolarR)],
             narr2[,list(source, date, temp = DailyTemp.C, RH, wind = WindSpeed, precip, solar = solarR)],
             ebifarm[,list(source, date, temp = Temp, RH = RH/100, wind, precip, solar = solar)])

theme_set(theme_bw())

rh <- ggplot() +
    geom_line(data = met, aes(date, RH, color = source)) +
    xlim(ymd("2010-08-01"), ymd("2010-08-31")) + ggtitle("Relative Humidity (0-1)")

precip <- ggplot() +
    geom_line(data = met, aes(date, precip, color = source)) +
    xlim(ymd("2010-08-01"), ymd("2010-08-31")) + ggtitle("Precipitation mm/d")

temp <- ggplot() +
    geom_line(data = met, aes(date, temp, color = source)) +
    xlim(ymd("2010-08-01"), ymd("2010-08-31")) + ggtitle("Temperature C")
wind <- ggplot() +
    geom_line(data = met, aes(date, wind, color = source)) +
    xlim(ymd("2010-08-01"), ymd("2010-08-31")) + ggtitle("Wind Speed m/s")

solar <- ggplot() +
    geom_line(data = met, aes(date, solar, color = source)) +
    xlim(ymd("2010-08-01"), ymd("2010-08-31")) + ggtitle("PAR")


s <- met[,list(date, day = yday(date), solar, source )]
s <- s[,list(date = min(date), solar = max(solar)), by = 'day,source']

maxsolar <- ggplot() +
    geom_line(data = s, aes(date, solar, color = source)) +
    xlim(ymd("2010-06-01"), ymd("2010-08-31")) + ggtitle("Max Daily PAR")

par(mfrow = c(1,4))
ebifarm[hour == 12,plot(solar, Temp, col = "red", main = "PAR and Temp at noon\n Observed")]
narr[hour == 12,plot(SolarR, Temp, main = "PAR and Temp at noon\n using weach NARR")]
narr2[hour == 12,plot(solarR, DailyTemp.C, main = "\n using 3 hourly NARR")]
cruncep[hour == 12,plot(solarR, DailyTemp.C, main = "\n using 6 hourly Cruncep")]

narr[,plot(RH, Temp, ylim = c(-15,30), xlim = c(-0,1),main = "RH and Temp at noon\n using weach NARR")]
narr2[,plot(RH, DailyTemp.C,ylim = c(-15,30), xlim = c(-0,1), main = "\n using 3 hourly NARR")]
ebifarm[,plot(RH/100, Temp, ylim = c(-15,30), xlim = c(-0,1), main = "\n observed")]
cruncep[,plot(RH, DailyTemp.C,ylim = c(-15,30), xlim = c(-0,1), main = "\n using 3 hourly NARR")]

narr2[precip > 0.1 & solarR > 100,plot(solarR, precip, main = "\n using 3 hourly NARR")]
narr[precip > 0.1 & SolarR > 100,plot(SolarR, precip, main = "\n using 3 hourly NARR")]

allsolar <- merge(ebifarm[,list(obs = max(solar)),by=date],
                  met[source == "narr",list(narr=max(solar)),by=date],
                  by='date')
allsolar <- merge(allsolar,    met[source == "cruncep",list(cruncep=max(solar), day = min(date)),key=date],by='date')
allsolar <- merge(allsolar,    met[source == "narr2",list(narr2=max(solar), day = min(date)),key=date],by='date')
allsolar$day <- yday(allsolar$date)
maxsolar <- allsolar[,list(obs=max(obs),cruncep=max(cruncep), narr = max(narr), narr2=max(narr2), date = min(date)), by = day]

narrsolar <- ggplot() + geom_point(data = maxsolar, aes(obs, narr, color = month(date)))+ scale_color_gradientn(colours = c("Red", "Orange", "Yellow", "Green", "Blue"))+ geom_line(aes(0:2000, 0:2000)) + ggtitle("NARR obs v. model") +xlim(c(0,2100)) + ylim(c(0,2100))

cruncepsolar <- ggplot() + geom_point(data = maxsolar, aes(obs, cruncep, color = month(date))) + geom_line(aes(0:2000, 0:2000)) + ggtitle("Max Daily PAR: CRUNCEP obs v. model") + scale_color_gradientn(colours = c("Red", "Orange", "Yellow", "Green", "Blue"))+ geom_line(aes(0:2000, 0:2000)) + xlim(c(0,2100)) + ylim(c(0,2100))

narr2solar <- ggplot() + geom_point(data = maxsolar, aes(obs, narr2, color = month(date)))+ scale_color_gradientn(colours = c("Red", "Orange", "Yellow", "Green", "Blue"))+ geom_line(aes(0:2000, 0:2000)) + ggtitle("NARR 3Hourly obs v. model") +xlim(c(0,2100)) + ylim(c(0,2100))

weachnarr_narr2 <- ggplot() +
    geom_point(data = maxsolar, aes(narr, narr2, color = month(date)))+
    scale_color_gradientn(colours = c("Red", "Orange", "Yellow", "Green", "Blue"))+
    geom_line(aes(0:2000, 0:2000)) + ggtitle("Weach NARR v. 3 hourly NARR") +xlim(c(0,2100)) + ylim(c(0,2100))

c <- met[source == "cruncep", .SD, key = date]
x11()
gridExtra::grid.arrange(rh, precip, temp, wind, solar)
gridExtra::grid.arrange(narrsolar, narr2solar, cruncepsolar)
weachnarr_narr2
met[,range(temp), by = source]
met[,mean(temp), by = source]
met[,mean(RH*100), by = source]
met[,sum(precip), by = source]

par(mfrow = c(1,2))
solarresiduals <- ggplot(data=allsolar[narr+obs>100]) +
    geom_point(aes(date, narr - obs), alpha = 0.1, color = "blue") +
    geom_point(aes(date, narr2 - obs), alpha = 0.1, color = "red") +
    geom_point(aes(date, cruncep - obs), alpha = 0.1, color = "green") +
#    geom_hline(aes(0,1))+
    geom_smooth(aes(date, narr - obs), alpha = 0.5, color = "blue") +
    geom_smooth(aes(date, narr2 - obs), alpha = 0.5, color = "red") +
    geom_smooth(aes(date, cruncep - obs), alpha = 0.5, color = "green") +
    geom_hline(aes(date,  rep(0, length(date))))+
    ggtitle("observed vs. modeled solar radiation:\n daily narr / weach (blue), cruncep 6 hourly (green), narr 3hourly (red)") +
    ylab("Modeled - Observed Solar Radiation (umol / h )")

solarresiduals

library(GGally)
c <- month(allsolar$date)
ggpairs(maxsolar[,list(cruncep, obs, narr)])

### separate 
obs <- merge(met[!source == "ebifarm"], met[source == "ebifarm"], by = "date")
obs$yday <- yday(obs$date)
dailyprecip <- obs[,list(precip.x = mean(precip.x), precip.y = mean(precip.y)), by = 'source.x,yday']

gridExtra::grid.arrange(
ggplot(data = obs, aes(date, RH.x-RH.y, color = source.x)) +
    geom_point(alpha = 0.1) +
    geom_smooth() + geom_hline(aes(date,0)) + ggtitle("RH"),

ggplot(data = obs, aes(date, temp.x-temp.y, color = source.x)) +
    geom_point(alpha = 0.1) +
    geom_smooth() + geom_hline(aes(date,0)) + ggtitle("Temperature C"),
 
ggplot(data = obs, aes(date, solar.x-solar.y, color = source.x)) +
    geom_point(alpha = 0.1) +
    geom_smooth() + geom_hline(aes(date,0)) + ggtitle("Solar Radiation umol/h/m2"),

ggplot(data = obs, aes(date, wind.x-wind.y, color = source.x)) +
    geom_point(alpha = 0.1) +
    geom_smooth() + geom_hline(aes(date,0)) + ggtitle("Wind m/s"),
ggplot(data = dailyprecip, aes(yday, precip.x-precip.y, color = source.x))+ geom_point(alpha = 0.3) +
    geom_smooth() + geom_hline(aes(yday,0)) +
    ylim(c(-0.5,0.5))+ ggtitle("Precip (daily average)")
)
 
met$yday <- yday(met$date)
dailyprecip2 <- met[,list(precip = mean(precip)), by = 'source,yday']
gridExtra::grid.arrange(
ggplot(data = met, aes(date, RH, color = source)) +
    geom_point(alpha = 0.1) +
    geom_smooth() + geom_hline(aes(date,0)) + ggtitle("RH"),

ggplot(data = met[precip > 0], aes(date, temp, color = source)) +
    geom_point(alpha = 0.1) +
    geom_smooth() + geom_hline(aes(date,0)) + ggtitle("Temperature C"),
 
ggplot(data = met, aes(date, solar, color = source)) +
    geom_point(alpha = 0.1) +
    geom_smooth() + geom_hline(aes(date,0)) + ggtitle("Solar Radiation umol/h/m2"),

ggplot(data = met, aes(date, wind, color = source)) +
    geom_point(alpha = 0.1) +
    geom_smooth() + ggtitle("Wind m/s"),


    ggplot(data = dailyprecip2, aes(yday, precip, color = source))+ geom_point(alpha = 0.1) +
    geom_smooth()+
    ylim(c(-0.5,0.5))+ ggtitle("Precip (daily average)")
)
