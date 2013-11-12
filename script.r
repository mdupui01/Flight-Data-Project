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

# Plotting delays and cancellation over time.

plotData <- melt(output, id = "Period")
f <- ggplot(data = plotData, aes(x = Period, y = value, color = variable)) + geom_line()

# Now we are going to look at the flights by month

i <- 1
numFlightsMonth = list()
numDelaysMonth = list()
numCancelsMonth = list()
for (month in 1:12){
  tempdf <- subset(data, Month == month)
  numFlightsMonth[i] = sum(tempdf$NumFlights)
  numDelaysMonth[i] = sum(tempdf$Delays)
  numCancelsMonth[i] = sum(tempdf$Cancelled)
  i = i + 1
}
numFlightsMonth <- as.numeric(unlist(numFlightsMonth))
numDelaysMonth <- as.numeric(unlist(numDelaysMonth))
numCancelsMonth <- as.numeric(unlist(numCancelsMonth))

monthlyData <- cbind(seq(as.Date("2000-01-01"), as.Date("2000-12-01"), by="month"), numFlightsMonth, numDelaysMonth, numCancelsMonth)
colnames(monthlyData) <- c("Month", "numFlights", "numDelays", "numCancels")
monthlyData <- data.frame(monthlyData)
monthlyData$onTime <- monthlyData$numFlights - monthlyData$numDelays - monthlyData$numCancels
monthlyData$Month <- seq(as.Date("2000-01-01"), as.Date("2000-12-01"), by = "month")

monthlyData.m <- melt(monthlyData,id.vars='Month',measure.vars=c('numDelays', 'numCancels', 'onTime'))

c <- ggplot(monthlyData.m) + geom_bar(aes(Month,value,fill=variable), stat = "identity") + scale_y_continuous(labels = comma) + theme_bw()

# The information in the previous graph on the number of delays and cancellations per month isn't particularly interesting if it's not expressed as a percentage.

monthlyData_norm <- monthlyData
monthlyData_norm$numDelays <- monthlyData$numDelays / monthlyData$numFlights
monthlyData_norm$numCancels <- monthlyData$numCancels / monthlyData$numFlights
monthlyData_norm$numFlights <- monthlyData$numFlights / monthlyData$numFlights

monthlyData_norm$onTime <- monthlyData_norm$numFlights - monthlyData_norm$numDelays - monthlyData_norm$numCancels

monthlyData.m_norm <- melt(monthlyData_norm,id.vars='Month',measure.vars=c('numDelays', 'numCancels', 'onTime'))

q <- ggplot(monthlyData.m_norm) + geom_bar(aes(Month,value,fill=variable), stat = "identity") + scale_y_continuous(labels = comma) + theme_bw()

# Now we want to look at the causes for delay

tempdf <- subset(data, Year > 2004)
tempdf <- subset(tempdf, select = -c(CarrierID))
pieData <- colSums(tempdf)
pieData <- pieData[-c(1, 2, 4, 6, 8, 11)]

slices <- pieData
lbls <- c("Carrier", "Late Aircraft", "NAS", "Security", "Weather")
pie(slices, labels = lbls, main="Pie Chart of Countries")

