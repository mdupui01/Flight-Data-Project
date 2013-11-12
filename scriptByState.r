library("ggplot2")
library("scales")
library(maps)
library(maptools)
library(sp)
graphics.off()

setwd('/Users/mfdupuis/Documents/Kaggle/Python/Flight-Data-Project/')

byState <- read.csv('byState.csv')
states <- levels(byState$DepState)

i <- 1
delaysByState = list()
flightsByState = list()
for (state in states){
  tempdf <- subset(byState, DepState == state)
  delaysByState[i] = sum(tempdf$Delays)
  flightsByState[i] = sum(tempdf$NumFlights)
  i = i + 1
}

delaysByState <- as.numeric(delaysByState)
flightsByStates <- as.numeric(flightsByState)
delaysPerFlight <- delaysByState/flightsByStates
delays <- data.frame(states = states, delaysByState = delaysByState, delaysPerFlight = delaysPerFlight, stringsAsFactors = FALSE)
delays <- delays[order(-delays[,2]),]
rownames(delays) <- 1:nrow(delays)

delays$states <- as.character(delays$states)
delays$states <- factor(delays$states, levels=unique(delays$states), ordered=TRUE)
r <- ggplot(delays, aes(x = delays$states, delaysByState))
r <- r + geom_bar(stat = "identity")

# Lets now look at the delays per flight to see if it balances out the distribution

d <- ggplot(delays, aes(x = delays$states, delaysPerFlight))
d <- d + geom_bar(stat = "identity") + geom_hline(yintercept = mean(delays$delaysPerFlight), color = "red")


# Creating a heatmap of the US for number of delays

txt <- "TX CA IL GA FL NY CO AZ NV NC VA PA MI NJ MO MN TN MA MD WA KY OH UT LA OR WI IN AK OK HI AL SC NM AR CT PR NE RI IA MS NH ID ME MT KS SD ND VT WY WV VI TT DE
    1773808 1769815 1362318 1104183 1024202  718390  572391  510283  489058 460899  455987  446730  410916  387529  330835  300035  284939  278549 278182  266981  249903  244765  215596  141319  129782  106949  102392 99588   91199   87037   82424   82149   79880   68390   57501   54806 51303   48938   44007   38790   35530   34863   25608   23713   23343 16465   15207   14708   13119    9210    7492     295     192"

dat <- stack(read.table(text = txt,  header = TRUE))
names(dat)[2] <-'state.abb'
dat$states <- tolower(state.name[match(dat$state.abb,  state.abb)])

mapUSA <- map('state',  fill = TRUE,  plot = FALSE)
nms <- sapply(strsplit(mapUSA$names,  ':'),  function(x)x[1])
USApolygons <- map2SpatialPolygons(mapUSA,  IDs = nms,  CRS('+proj=longlat'))

idx <- match(unique(nms),  dat$states)
dat2 <- data.frame(value = dat$value[idx], state = unique(nms))
row.names(dat2) <- unique(nms)

USAsp <- SpatialPolygonsDataFrame(USApolygons,  data = dat2)

spplot(USAsp['value'])

# Creating a heatmap of the US for number of delays per flight

txt <- "TX CA IL GA FL NY CO AZ NV NC VA PA MI NJ MO MN TN MA MD WA KY OH UT LA OR WI IN AK OK HI AL SC NM AR CT PR NE RI IA MS NH ID ME MT KS SD ND VT WY WV VI TT DE
    0.17655776 0.16739273 0.22977340 0.20696195 0.17474191 0.18129172 0.18681034 0.17701589 0.19946733 0.17095698 0.15792283 0.18599839 0.17256474 0.2132939 0.16323126 0.15832706 0.15949950 0.17134908 0.19953821 0.16218845 0.15544682 0.14667205 0.12830445 0.15350199 0.14209309 0.15329827 0.15164153 0.17458409 0.14780103 0.07600814 0.15690306 0.16694610 0.15805928 0.16275777 0.13893695 0.15619006 0.15197197 0.15010091 0.15601004 0.16212353 0.15411174 0.11735736 0.17702443 0.09350995 0.15195683 0.13366075 0.11784170 0.18351280 0.12992840 0.16898152 0.14456343 0.27673546 0.21573034"

dat <- stack(read.table(text = txt,  header = TRUE))
names(dat)[2] <-'state.abb'
dat$states <- tolower(state.name[match(dat$state.abb,  state.abb)])

mapUSA <- map('state',  fill = TRUE,  plot = FALSE)
nms <- sapply(strsplit(mapUSA$names,  ':'),  function(x)x[1])
USApolygons <- map2SpatialPolygons(mapUSA,  IDs = nms,  CRS('+proj=longlat'))

idx <- match(unique(nms),  dat$states)
dat2 <- data.frame(value = dat$value[idx], state = unique(nms))
row.names(dat2) <- unique(nms)

USAsp <- SpatialPolygonsDataFrame(USApolygons,  data = dat2)

spplot(USAsp['value'])
