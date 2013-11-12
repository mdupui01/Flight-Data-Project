library("ggplot2")
library("scales")
graphics.off()

setwd('/Users/mfdupuis/Documents/Kaggle/Python/Flight-Data-Project/')

byState <- read.csv('byState.csv')
states <- levels(byState$DepState)

i <- 1
delaysByState = list()
for (state in states){
  tempdf <- subset(byState, DepState == state)
  delaysByState[i] = sum(tempdf$Delays)
  i = i + 1
}

delaysByState <- as.numeric(delaysByState)
delays <- data.frame(states = states, delaysByState = delaysByState, stringsAsFactors = FALSE)
delays <- delays[order(-delays[,2]),]
rownames(delays) <- 1:nrow(delays)

delays$states <- as.character(delays$states)
delays$states <- factor(delays$states, levels=unique(delays$states), ordered=TRUE)
c <- ggplot(delays, aes(x = delays$states, delaysByState))
c <- c + geom_bar(stat = "identity")



