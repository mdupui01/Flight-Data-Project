# Script to organize the data created in Python by carrier.

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

# Putting all the data in data frames.
temp <- as.numeric(unlist(numFlights))
numDelays <- as.numeric(unlist(numDelays))
numCancels <- as.numeric(unlist(numCancels))

# Make sure to organize the dates as dates in the data frame.
output <- cbind(seq(as.Date("2000-01-01"), as.Date("2013-07-01"), by="month"),temp[1:163], numDelays[1:163], numCancels[1:163])
colnames(output) <- c("Period", "All_Flights", "Delayed", "Cancelled")
output <- data.frame(output)
output$Period <- seq(as.Date("2000-01-01"), as.Date("2013-07-01"), by = "month")

p <- ggplot(output, aes(x = Period, y = All_Flights))
p <- p + geom_line(stat = "identity") + scale_x_date(labels = date_format("%m/%y")) + xlab("Month/Year") + ylab("Number of flights") + labs(title = "Number of Flights from Sep-2000 to Aug-2013") + theme(axis.text=element_text(size=16, face = "bold"), title=element_text(size=16,face="bold")) + scale_y_continuous(labels=comma)
p <- p + geom_vline(xintercept = 11540, color = 'red') + geom_vline(xintercept = 13740, color = 'red') + geom_vline(xintercept = 15000, color = 'blue') + geom_vline(xintercept = 14800, color = 'blue') + geom_vline(xintercept = 15150, color = 'blue') + geom_vline(xintercept = 15370, color = 'blue')

# Plotting delays and cancellation over time.

plotData <- melt(output, id = "Period")
colnames(plotData) <- c("Period", "Status", "Value")
f <- ggplot(data = plotData, aes(x = Period, y = Value, color = Status)) + geom_line()
f <- f + xlab("Month/Year") + ylab("Number of Flights") + labs(title = "Number of Flights, Delays and Cancellations") + theme(axis.text=element_text(size=16, face = "bold"), title=element_text(size=16,face="bold")) + scale_y_continuous(labels=comma) + scale_x_date(labels = date_format("%m/%y"))
f <- f + geom_vline(xintercept = 11540, color = 'red') + geom_vline(xintercept = 13740, color = 'red') + geom_vline(xintercept = 15000, color = 'blue') + geom_vline(xintercept = 14800, color = 'blue') + geom_vline(xintercept = 15150, color = 'blue') + geom_vline(xintercept = 15370, color = 'blue')

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
colnames(monthlyData) <- c("Month", "All_Flights", "Delayed", "Cancelled")
monthlyData <- data.frame(monthlyData)
monthlyData$On_Time <- monthlyData$All_Flights - monthlyData$Delayed - monthlyData$Cancelled
monthlyData$Month <- seq(as.Date("2000-01-01"), as.Date("2000-12-01"), by = "month")

monthlyData.m <- melt(monthlyData,id.vars='Month',measure.vars=c('Delayed', 'Cancelled', 'On_Time'))
colnames(monthlyData.m) <- c("Month", "Status", "Value")

nums <- c(13, 13, 13, 13, 13, 13, 13, 13, 13, 12, 12, 12)
c <- ggplot(monthlyData.m) + geom_bar(aes(Month,Value/nums,fill=Status), stat = "identity") + scale_y_continuous(labels = comma) + theme_bw()
c <- c + xlab("Month") + ylab("Average Number of Flights") + labs(title = "Average number of Flights by Month from Jan-2000 to Aug-2013") + theme(axis.text=element_text(size=16, face = "bold"), title=element_text(size=16,face="bold")) + scale_x_date(labels = date_format("%m"))

# The information in the previous graph on the number of delays and cancellations per month isn't particularly interesting if it's not expressed as a percentage.

monthlyData_norm <- monthlyData
monthlyData_norm$Delayed <- monthlyData$Delayed / monthlyData$All_Flights
monthlyData_norm$Cancelled <- monthlyData$Cancelled / monthlyData$All_Flights
monthlyData_norm$All_Flights <- monthlyData$All_Flights / monthlyData$All_Flights

monthlyData_norm$On_Time <- monthlyData_norm$All_Flights - monthlyData_norm$Delayed - monthlyData_norm$Cancelled

monthlyData.m_norm <- melt(monthlyData_norm,id.vars='Month',measure.vars=c('Delayed', 'Cancelled', 'On_Time'))
colnames(monthlyData.m_norm) <- c("Month", "Status", "Value")

q <- ggplot(monthlyData.m_norm) + geom_bar(aes(Month,Value,fill=Status), stat = "identity") + scale_y_continuous(labels = comma) + theme_bw()
q <- q + xlab("Month") + ylab("Delay-to-Flights Ratio") + labs(title = "Flight Status by Ratio by Month from Jan-2000 to Aug-2013") + theme(axis.text=element_text(size=16, face = "bold"), title=element_text(size=16,face="bold")) + scale_x_date(labels = date_format("%m"))


# Now we want to look at the causes for delay

tempdf <- subset(data, Year > 2004)
tempdf <- subset(tempdf, select = -c(CarrierID))
pieData <- colSums(tempdf)
pieData <- pieData[-c(1, 2, 4, 6, 8, 11)]

slices <- pieData
lbls <- c("Carrier Delay", "Late Aircraft Delay", "NAS Mandated Delay", "Security Delay", "Weather Delay")
pie(slices, labels = lbls, main="Causes of Delay")


# Finally, lets look at the delays by carrier

carriers <- levels(data$CarrierID)

i <- 1
delaysByCarrier = list()
flightsByCarrier = list()
cancelsByCarrier = list()
for (carrier in carriers){
  tempdf <- subset(data, CarrierID == carrier & Year > 2004)
  delaysByCarrier[i] = sum(tempdf$Delays)
  flightsByCarrier[i] = sum(tempdf$NumFlights)
  cancelsByCarrier[i] = sum(tempdf$Cancelled)
  i = i + 1
}

delaysByCarrier <- as.numeric(delaysByCarrier)
flightsByCarrier <- as.numeric(flightsByCarrier)
cancelsByCarrier <- as.numeric(cancelsByCarrier)

carrierData <- data.frame(carriers, flightsByCarrier, delaysByCarrier, cancelsByCarrier, stringsAsFactors = FALSE)
carrierData <- carrierData[order(-carrierData[,3]),]
rownames(carrierData) <- 1:nrow(carrierData)

carrierData$carriers <- as.character(carrierData$carriers)
carrierData$carriers <- factor(carrierData$carriers, levels=unique(carrierData$carriers), ordered=TRUE)
carrierData <- carrierData[-24,]
m <- ggplot(carrierData, aes(x = carrierData$carriers, delaysByCarrier))
m <- m + geom_bar(stat = "identity") + scale_y_continuous(labels=comma) + theme(axis.text.x=element_text(angle=70, hjust=1))
m <- m + xlab("Carriers") + ylab("Number of Delayed Flights") + labs(title = "Number of Delayed Flights by Airline from Jan-2000 to Aug-2013") + theme(axis.text=element_text(size=16, face = "bold"), title=element_text(size=16,face="bold"))


# Again, lets look at the same data in terms of frequency per flight to put all airlines on the same playing field

carrierData <- data.frame(carriers, flightsByCarrier, delaysByCarrier, cancelsByCarrier, stringsAsFactors = FALSE)
carrierData$normDelays <- carrierData$delaysByCarrier / carrierData$flightsByCarrier
carrierData <- carrierData[order(-carrierData[,5]),]
rownames(carrierData) <- 1:nrow(carrierData)
carrierData$carriers <- as.character(carrierData$carriers)
carrierData$carriers <- factor(carrierData$carriers, levels=unique(carrierData$carriers), ordered=TRUE)
carrierData <- carrierData[-24,]

n <- ggplot(carrierData, aes(x = carrierData$carriers, normDelays))
n <- n + geom_bar(stat = "identity") + theme(axis.text.x=element_text(angle=70, hjust=1)) + scale_y_continuous(labels=comma) + geom_hline(yintercept = mean(carrierData$normDelays), color = "red")
n <- n + xlab("Carriers") + ylab("Ratio of Delayed Flights") + labs(title = "Delays-to-Flight Ratio by Airline from Jan-2000 to Aug-2013") + theme(axis.text=element_text(size=16, face = "bold"), title=element_text(size=16,face="bold"))
