
setwd('/Users/mfdupuis/Documents/Kaggle/Python/flightData/')
data2012 <- read.csv('2012data_Weka.csv')

wekaData <- data2012
wekaData$X <- NULL
wekaData$UNIQUE_CARRIER <- as.numeric(wekaData$UNIQUE_CARRIER)
wekaData$ORIGIN_STATE_ABR <- as.numeric(wekaData$ORIGIN_STATE_ABR)
wekaData$DEST_STATE_ABR <- as.numeric(wekaData$DEST_STATE_ABR)
wekaData$DELAY <- wekaData$DEP_DEL15
wekaData$DEP_DEL15 <- NULL

write.csv(wekaData, file = "wekaData.csv" , sep = ",")
