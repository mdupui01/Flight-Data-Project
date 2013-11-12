library("ggplot2")
library("scales")
library("reshape2")
graphics.off()

setwd('/Users/mfdupuis/Documents/Kaggle/Python/Flight-Data-Project/')

data <- read.csv('byCarrier.csv')

i <- 1
numFlights = list()
numDelays = list()
numCancels = list()
for (year in 2000:2013){
  for (month in 1:12){
    tempdf <- subset(data, Year == year & Month == month)
    numFlights[i] = sum(tempdf$NumFlights)
    numDelays[i] = sum(tempdf$Delays)
    numCancels[i] = sum(tempdf$Cancelled)
    i = i + 1
  }
}

temp <- as.numeric(unlist(numFlights))
numDelays <- as.numeric(unlist(numDelays))
numCancels <- as.numeric(unlist(numCancels))

output <- cbind(seq(as.Date("2000-01-01"), as.Date("2013-07-01"), by="month"),temp[1:163], numDelays[1:163], numCancels[1:163])
colnames(output) <- c("Period", "numFlights", "numDelays", "numCancels")
output <- data.frame(output)
output$Period <- seq(as.Date("2000-01-01"), as.Date("2013-07-01"), by = "month")

p <- ggplot(output, aes(x = Period, y = numFlights))
pp <- p + geom_line(stat = "identity") + scale_x_date(labels = date_format("%m/%y")) + xlab("Month/Year") + ylab("Number of flights") + labs(title = "Number of Flights from Sep-2000 to Aug-2013") + theme(axis.text=element_text(size=16, face = "bold"), title=element_text(size=16,face="bold"))
ppp <- pp + geom_vline(xintercept = 11540, color = 'red') + geom_vline(xintercept = 13740, color = 'red') + geom_vline(xintercept = 15000, color = 'blue') + geom_vline(xintercept = 14800, color = 'blue') + geom_vline(xintercept = 15150, color = 'blue') + geom_vline(xintercept = 15370, color = 'blue')


# Now we are going to look at the flights by month

i <- 1
numFlightsMonth = list()
numDelaysMonth = list()
for (month in 1:12){
  tempdf <- subset(data, Month == month)
  numFlightsMonth[i] = sum(tempdf$NumFlights)
  numDelaysMonth[i] = sum(tempdf$Delays)
  i = i + 1
}
numFlightsMonth <- as.numeric(unlist(numFlightsMonth))
numDelaysMonth <- as.numeric(unlist(numDelaysMonth))

monthlyData <- cbind(seq(as.Date("2000-01-01"), as.Date("2000-12-01"), by="month"), numFlightsMonth, numDelaysMonth)
colnames(monthlyData) <- c("Month", "numFlights", "numDelays")
monthlyData <- data.frame(monthlyData)
monthlyData$onTime <- monthlyData$numFlights - monthlyData$numDelays
monthlyData$Month <- seq(as.Date("2000-01-01"), as.Date("2000-12-01"), by = "month")

monthlyData.m <- melt(monthlyData,id.vars='Month',measure.vars=c('numDelays','onTime'))

c <- ggplot(monthlyData.m) + geom_bar(aes(Month,value,fill=variable), stat = "identity") + scale_y_continuous(labels = comma) + theme_bw()

