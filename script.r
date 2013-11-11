library("ggplot2")
library("scales")
graphics.off()

setwd('/Users/mfdupuis/Documents/Kaggle/Python/Flight-Data-Project/')

data <- read.csv('byCarrier.csv')

i <- 0
numFlights = list()
for (year in 2000:2013){
  for (month in 1:12){
    tempdf <- subset(data, Year == year & Month == month)
    numFlights[i] = sum(tempdf$NumFlights)
    i = i + 1
  }
}

temp <- as.numeric(unlist(numFlights))
output <- cbind(seq(as.Date("2000-01-01"), as.Date("2013-07-01"), by="month"),temp[1:163])
colnames(output) <- c("Period", "numFlights")
output <- data.frame(output)
output$Period <- seq(as.Date("2000-01-01"), as.Date("2013-07-01"), by = "month")

p <- ggplot(output, aes(x = Period, y = numFlights))
pp <- p + geom_line(stat = "identity") + scale_x_date(labels = date_format("%m/%y")) + xlab("Month/Year") + ylab("Number of flights") + labs(title = "Number of Flights from Sep-2000 to Aug-2013") + theme(axis.text=element_text(size=16, face = "bold"), title=element_text(size=16,face="bold"))
ppp <- pp + geom_vline(xintercept = 11500, color = 'red') + geom_vline(xintercept = 13700, color = 'red') + geom_vline(xintercept = 14980, color = 'blue') + geom_vline(xintercept = 14760, color = 'blue') + geom_vline(xintercept = 15150, color = 'blue') + geom_vline(xintercept = 15350, color = 'blue')


