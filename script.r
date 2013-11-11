library("ggplot2")
graphics.off()

setwd('/Users/mfdupuis/Documents/Kaggle/Python/Flight-Data-Project/Flight Data/')

df <- read.csv('output13.csv')

df$DEP_DEL15[is.na(df$DEP_DEL15)] <- 0
delays_by_carrier <- data.frame(tapply(df$DEP_DEL15, df$UNIQUE_CARRIER, sum))
delays_by_carrier <- cbind(row.names(delays_by_carrier), delays_by_carrier)
colnames(delays_by_carrier) <- c("Carrier","NumDelays")
rownames(delays_by_carrier) <- c(array(1:nrow(delays_by_carrier)))

delays_by_carrier <- delays_by_carrier[order(delays_by_carrier$NumDelays),]
rownames(delays_by_carrier) <- c(array(1:nrow(delays_by_carrier)))

c <- ggplot(delays_by_carrier, aes(Carrier,NumDelays))
c + geom_bar(stat = "identity")
